import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/user.dart';
import '../../models/result.dart';
import '../../models/patient.dart';
import '../../models/doctor.dart';
import '../../api/api_client.dart';
import './auth_repository.dart';
import '../auth/token_provider.dart';

class SupabaseAuthRepository implements AuthRepository {
  final TokenProvider _tokenProvider = GetIt.instance<TokenProvider>();

  // Helper function to parse User/Patient/Doctor from map based on role
  User _parseUserFromMap(Map<String, dynamic> userMap, String password) {
    final role = (userMap['role'] as String?)?.toLowerCase() ?? '';
    
    // Add password to the map since backend doesn't return it
    final userWithPassword = Map<String, dynamic>.from(userMap);
    userWithPassword['password'] = password;

    if (role == 'patient') {
      return Patient.fromMap(userWithPassword);
    } else if (role == 'doctor') {
      return Doctor.fromMap(userWithPassword);
    } else {
      return User.fromMap(userWithPassword);
    }
  }

  /// Send FCM device token to backend after login/signup
  /// This is called automatically after successful authentication
  Future<void> _sendFCMTokenToBackend(int userId) async {
    try {
      // Get FCM token
      final token = await FirebaseMessaging.instance.getToken();
      
      if (token == null || token.isEmpty) {
        print('⚠️ No FCM token available to send');
        return;
      }

      // Determine device type
      String deviceType = 'android';
      if (Platform.isIOS) {
        deviceType = 'ios';
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        deviceType = 'web';
      }

      // Send token to backend
      final response = await ApiClient.post(
        '/device-tokens',
        {
          'userId': userId,
          'token': token,
          'deviceType': deviceType,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ FCM token sent to backend successfully');
      } else {
        print('⚠️ Failed to send FCM token: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Don't throw - token sending failure shouldn't block login/signup
      print('⚠️ Error sending FCM token to backend: $e');
    }
  }

  @override
  Future<ReturnResult<User>> login(String email, String password) async {
    try {
      final response = await ApiClient.post(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);
      print('Login response status: ${response.statusCode}');
      print('Login response keys: ${data.keys}');
      print('Login response has user: ${data.containsKey('user')}');
      if (data.containsKey('user')) {
        print('Login response user type: ${data['user'].runtimeType}');
        if (data['user'] is Map) {
          print('Login response user keys: ${(data['user'] as Map).keys}');
        }
      }

      if (response.statusCode != 200) {
        return ReturnResult(
          state: false,
          message: data['message'] ?? 'Login failed',
        );
      }

      // 🔑 STORE TOKEN GLOBALLY
      final accessToken = data['access_token'];
      if (accessToken == null || accessToken is! String) {
        print('ERROR: No access token in response');
        return ReturnResult(
          state: false,
          message: 'Login failed: No access token received',
        );
      }
      await _tokenProvider.setToken(accessToken);
      print('Token stored successfully');

      // Backend now returns user data directly in the login response
      final userMap = data['user'];
      print('User map from response: $userMap');
      print('User map is Map: ${userMap is Map<String, dynamic>}');
      
      if (userMap != null && userMap is Map<String, dynamic>) {
        try {
          print('Attempting to parse user from login response...');
          print('User role: ${userMap['role']}');
          print('User has date_of_birth: ${userMap.containsKey('date_of_birth')}');
          print('date_of_birth value: ${userMap['date_of_birth']}');
          print('User has speciality_id: ${userMap.containsKey('speciality_id')}');
          print('speciality_id value: ${userMap['speciality_id']}');
          final user = _parseUserFromMap(userMap, password);
          print('User parsed successfully: ${user.email}');
          if (user is Patient) {
            print('Parsed as Patient, dateOfBirth: ${user.dateOfBirth}');
          } else if (user is Doctor) {
            print('Parsed as Doctor, specialityId: ${user.specialityId}');
          }
          // Send FCM token to backend after successful login
          if (user.userId != null) {
            _sendFCMTokenToBackend(user.userId!);
          }
          
          return ReturnResult(
            state: true,
            message: 'Login successful',
            data: user,
          );
        } catch (e, stackTrace) {
          print('ERROR parsing user from login response: $e');
          print('Stack trace: $stackTrace');
          print('User map keys: ${userMap.keys}');
          // Fall through to use /auth/me fallback
        }
      } else {
        print('User map is null or not a Map, falling back to /auth/me');
      }
      
      // Fallback: fetch user using /auth/me if not in response or parsing failed
      final meResponse = await ApiClient.get(
        '/auth/me',
        token: accessToken,
      );

      if (meResponse.statusCode != 200) {
        await _tokenProvider.clear();
        return ReturnResult(
          state: false,
          message: 'Failed to fetch user profile',
        );
      }

      final meUserMap = jsonDecode(meResponse.body);
      if (meUserMap is! Map<String, dynamic>) {
        return ReturnResult(
          state: false,
          message: 'Invalid user data format',
        );
      }
      
      final user = _parseUserFromMap(meUserMap, password);
      
      // Send FCM token to backend after successful login
      if (user.userId != null) {
        _sendFCMTokenToBackend(user.userId!);
      }
      
      return ReturnResult(
        state: true,
        message: 'Login successful',
        data: user,
      );
    } catch (e) {
      // Provide user-friendly error messages
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else {
        errorMessage = 'Login failed: ${e.toString()}';
      }
      return ReturnResult(
        state: false,
        message: errorMessage,
      );
    }
  }

  @override
  Future<ReturnResult<User>> signup(
    User user,
    String password, {
    Patient? patientData,
    Doctor? doctorData,
  }) async {
    try {
      // Validate role is set
      if (user.role == null || user.role.isEmpty) {
        return ReturnResult(
          state: false,
          message: 'User role is required',
        );
      }

      final Map<String, dynamic> body = {
        'email': user.email,
        'password': password,
        'firstname': user.firstname,
        'lastname': user.lastname,
        'phone_number': user.phoneNumber,
        'nin': user.nin,
        'role': user.role, // Explicitly set role
      };

      // Add patient-specific fields ONLY for patients
      if (user.role == 'patient' && patientData != null) {
        body['date_of_birth'] = patientData.dateOfBirth;
      }

      // Explicit safeguard: Ensure date_of_birth is NEVER sent for doctors
      // This prevents any accidental patient creation
      if (user.role == 'doctor') {
        body.remove('date_of_birth'); // Remove if somehow present
      }

      // Add doctor-specific fields ONLY for doctors
      if (user.role == 'doctor' && doctorData != null) {
        body['speciality_id'] = doctorData.specialityId;
        body['bio'] = doctorData.bio;
        body['location_of_work'] = doctorData.locationOfWork;
        body['degree'] = doctorData.degree;
        body['university'] = doctorData.university;
        body['certification'] = doctorData.certification;
        body['institution'] = doctorData.institution;
        body['residency'] = doctorData.residency;
        body['license_number'] = doctorData.licenseNumber;
        body['license_description'] = doctorData.licenseDescription;
        body['years_experience'] = doctorData.yearsExperience;
        body['areas_of_expertise'] = doctorData.areasOfExpertise;
        body['price_per_hour'] = doctorData.pricePerHour;
      }

      final response = await ApiClient.post(
        '/auth/signup',
        body,
      );

      // Handle non-200 status codes
      if (response.statusCode != 200) {
        String errorMessage = 'Signup failed';
        try {
          final data = jsonDecode(response.body);
          errorMessage = data['message'] ?? errorMessage;
        } catch (e) {
          // If JSON decode fails, try to use response body as string
          errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
        }
        print('Signup error: $errorMessage (status: ${response.statusCode})');
        return ReturnResult(
          state: false,
          message: errorMessage,
        );
      }

      final data = jsonDecode(response.body);

      // Backend returns { user: {...}, access_token: ..., refresh_token: ... }
      // Store the access token if provided (user is automatically logged in after signup)
      final accessToken = data['access_token'];
      if (accessToken != null && accessToken is String && accessToken.isNotEmpty) {
        await _tokenProvider.setToken(accessToken);
      } else {
        // If no token was returned, try to login automatically as fallback
        try {
          final loginResult = await login(user.email!, password);
          if (loginResult.state && loginResult.data != null) {
            // Token is now stored from login, and FCM token is sent in login method
            // Return the user from login
            return ReturnResult(
              state: true,
              message: 'Signup successful',
              data: loginResult.data!,
            );
          }
        } catch (e) {
          // If auto-login fails, continue with returning the user object
          // The frontend can handle re-authentication if needed
        }
      }

      // Extract the user object
      Map<String, dynamic> userMap;
      if (data['user'] != null && data['user'] is Map<String, dynamic>) {
        userMap = data['user'] as Map<String, dynamic>;
      } else {
        // Fallback: if structure is different, use data directly
        userMap = data as Map<String, dynamic>;
      }

      final createdUser = _parseUserFromMap(userMap, password);
      
      // Send FCM token to backend after successful signup
      if (createdUser.userId != null) {
        _sendFCMTokenToBackend(createdUser.userId!);
      }

      return ReturnResult(
        state: true,
        message: 'Signup successful',
        data: createdUser,
      );
    } catch (e) {
      // Provide user-friendly error messages
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else {
        errorMessage = 'Signup failed: ${e.toString()}';
      }
      return ReturnResult(
        state: false,
        message: errorMessage,
      );
    }
  }

  @override
  Future<ReturnResult> logout() async {
    // 🔥 CLEAR TOKEN GLOBALLY
    await _tokenProvider.clear();

    return ReturnResult(
      state: true,
      message: 'Logged out',
    );
  }

  @override
  Future<ReturnResult<User?>> getCurrentUser() async {
    try {
      final token = _tokenProvider.accessToken;

      if (token == null) {
        return ReturnResult(
          state: true,
          message: 'No authenticated user',
          data: null,
        );
      }

      final response = await ApiClient.get(
        '/auth/me',
        token: token,
      );

      if (response.statusCode != 200) {
        print('⚠️ getCurrentUser failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        await _tokenProvider.clear();
        return ReturnResult(
          state: false,
          message: 'Session expired or invalid token',
          data: null,
        );
      }

      final userMap = jsonDecode(response.body);
      if (userMap is! Map<String, dynamic>) {
        return ReturnResult(
          state: false,
          message: 'Invalid user data format',
          data: null,
        );
      }

      print('getCurrentUser - User role: ${userMap['role']}');
      print('getCurrentUser - User has date_of_birth: ${userMap.containsKey('date_of_birth')}');
      print('getCurrentUser - date_of_birth value: ${userMap['date_of_birth']}');
      print('getCurrentUser - User has speciality_id: ${userMap.containsKey('speciality_id')}');
      print('getCurrentUser - speciality_id value: ${userMap['speciality_id']}');
      print('getCurrentUser - User has email_confirmed_at: ${userMap.containsKey('email_confirmed_at')}');
      print('getCurrentUser - email_confirmed_at value: ${userMap['email_confirmed_at']}');

      // Use empty password since we don't have it in getCurrentUser
      // The password field is required but won't be used for authentication
      final user = _parseUserFromMap(userMap, '');
      if (user is Patient) {
        print('getCurrentUser - Parsed as Patient, dateOfBirth: ${user.dateOfBirth}');
        print('getCurrentUser - Patient isEmailVerified: ${user.isEmailVerified}');
      } else if (user is Doctor) {
        print('getCurrentUser - Parsed as Doctor, specialityId: ${user.specialityId}');
        print('getCurrentUser - Doctor isEmailVerified: ${user.isEmailVerified}');
      }
      return ReturnResult(
        state: true,
        message: 'User loaded',
        data: user,
      );
    } catch (e) {
      // Provide user-friendly error messages
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else {
        errorMessage = 'Failed to fetch user: ${e.toString()}';
      }
      return ReturnResult(
        state: false,
        message: errorMessage,
      );
    }
  }

  @override
  Future<bool> emailExists(String email) async {
    try {
      final response =
          await ApiClient.get('/users/email-exists?email=$email');

      final data = jsonDecode(response.body);
      return data['exists'] ?? false;
    } catch (e) {
      // Re-throw the exception so it can be handled in the cubit
      rethrow;
    }
  }

  @override
  Future<ReturnResult<String>> uploadProfilePicture(String imagePath) async {
    try {
      final token = _tokenProvider.accessToken;
      if (token == null) {
        return ReturnResult(
          state: false,
          message: 'Not authenticated',
        );
      }

      final response = await ApiClient.postMultipart(
        '/auth/upload-profile-picture',
        imagePath,
        token: token,
        fieldName: 'profile_picture',
      );

      // Log response for debugging
      print('Upload response status: ${response.statusCode}');
      print('Upload response body: ${response.body}');

      if (response.statusCode != 200) {
        String errorMessage = 'Failed to upload profile picture';
        try {
          if (response.body.isNotEmpty) {
            final data = jsonDecode(response.body);
            errorMessage = data['message'] ?? errorMessage;
          }
        } catch (e) {
          // If response is not JSON, use the raw body or status code
          if (response.body.isNotEmpty) {
            errorMessage = response.body;
          } else {
            errorMessage = 'Server error (${response.statusCode})';
          }
        }
        return ReturnResult(
          state: false,
          message: errorMessage,
        );
      }

      // Parse successful response
      String? profilePictureUrl;
      try {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          profilePictureUrl = data['profile_picture_url'] as String?;
        }
      } catch (e) {
        print('Error parsing response: $e');
        return ReturnResult(
          state: false,
          message: 'Invalid response from server',
        );
      }
      
      if (profilePictureUrl == null) {
        return ReturnResult(
          state: false,
          message: 'No profile picture URL returned',
        );
      }

      return ReturnResult(
        state: true,
        message: 'Profile picture uploaded successfully',
        data: profilePictureUrl,
      );
    } catch (e) {
      print('Upload error: $e');
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else if (e.toString().contains('FormatException') || e.toString().contains('unexpected character')) {
        errorMessage = 'Server returned invalid response. Please try again.';
      } else {
        errorMessage = 'Failed to upload profile picture: ${e.toString()}';
      }
      return ReturnResult(
        state: false,
        message: errorMessage,
      );
    }
  }

  @override
  Future<ReturnResult<User>> verifyOtp(String email, String otp, String password) async {
    try {
      final response = await ApiClient.post(
        '/auth/verify-otp',
        {
          'email': email.trim(),
          'otp': otp.trim(),
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      // CRITICAL: Only return error when backend explicitly returns failure status
      // Backend returns status 400 for expired/invalid OTP, 200 for success
      if (response.statusCode != 200) {
        // Backend explicitly returned an error - this is the only case where we show error
        final bool codeExpired = data['code_expired'] == true;
        print('❌ Backend returned error status ${response.statusCode}: ${data['message']}');
        print('❌ Code expired flag: $codeExpired');
        return ReturnResult(
          state: false,
          message: data['message'] ?? 'OTP verification failed',
          codeExpired: codeExpired,
        );
      }

      // Backend returned 200 - check if verified flag is true
      // If verified=false, backend still returned 200 but verification didn't succeed
      final bool verified = data['verified'] == true;
      if (!verified) {
        print('⚠️ Backend returned 200 but verified=false: ${data['message']}');
        return ReturnResult(
          state: false,
          message: data['message'] ?? 'Email verification failed. Please try again.',
        );
      }

      // Backend returned 200 AND verified=true - this is success
      print('✅ Backend returned success: verified=true');

      // Parse user from response
      Map<String, dynamic> userMap;
      if (data['user'] != null && data['user'] is Map<String, dynamic>) {
        userMap = data['user'] as Map<String, dynamic>;
      } else {
        return ReturnResult(
          state: false,
          message: 'Invalid user data in response',
        );
      }

      // Backend has already verified that Supabase verifyOtp succeeded
      // If backend returns verified: true, we trust it - backend guarantees success if Supabase verified
      final emailConfirmedAt = userMap['email_confirmed_at'];
      if (emailConfirmedAt != null && emailConfirmedAt.toString().isNotEmpty) {
        print('✅ Email confirmed at: $emailConfirmedAt');
      } else {
        // Edge case: backend returned success but email_confirmed_at not set
        // Backend handles this case and still returns success if Supabase verifyOtp succeeded
        print('⚠️ Email confirmed at is null, but backend returned verified: true (Supabase verifyOtp succeeded)');
      }

      final user = _parseUserFromMap(userMap, ''); // Password not needed after verification

      // Store token if provided - ONLY if verification is complete
      // Check both session.access_token and direct access_token
      String? accessToken;
      if (data['access_token'] != null) {
        accessToken = data['access_token'] as String;
      } else if (data['session'] != null && data['session']['access_token'] != null) {
        accessToken = data['session']['access_token'] as String;
      }
      
      if (accessToken != null && accessToken.isNotEmpty) {
        await _tokenProvider.setToken(accessToken);
        print('✅ Token saved after OTP verification: ${accessToken.substring(0, 20)}...');
        
        // Verify token was saved
        final savedToken = _tokenProvider.accessToken;
        if (savedToken == null || savedToken != accessToken) {
          print('⚠️ Token save verification failed');
        } else {
          print('✅ Token save verified');
        }
      } else {
        print('⚠️ No access token in OTP verification response');
        print('Response keys: ${data.keys}');
        if (data['session'] != null) {
          print('Session keys: ${(data['session'] as Map).keys}');
        }
        // If requires_login is true, verification succeeded but user needs to login separately
        if (data['requires_login'] == true) {
          return ReturnResult(
            state: true,
            message: data['message'] ?? 'Email verified successfully. Please log in with your email and password.',
            data: user,
          );
        }
      }
      
      // Send FCM token to backend after successful verification
      if (user.userId != null) {
        _sendFCMTokenToBackend(user.userId!);
      }

      return ReturnResult(
        state: true,
        message: data['message'] ?? 'Email verified successfully',
        data: user,
      );
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else {
        errorMessage = 'OTP verification failed: ${e.toString()}';
      }
      return ReturnResult(
        state: false,
        message: errorMessage,
      );
    }
  }

  @override
  Future<ReturnResult> resendOtp(String email) async {
    try {
      final response = await ApiClient.post(
        '/auth/resend-otp',
        {
          'email': email.trim(),
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return ReturnResult(
          state: false,
          message: data['message'] ?? 'Failed to resend OTP',
        );
      }

      return ReturnResult(
        state: true,
        message: data['message'] ?? 'OTP code sent successfully',
      );
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else {
        errorMessage = 'Failed to resend OTP: ${e.toString()}';
      }
      return ReturnResult(
        state: false,
        message: errorMessage,
      );
    }
  }
}
