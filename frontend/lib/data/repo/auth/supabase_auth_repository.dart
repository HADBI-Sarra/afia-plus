import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../../models/user.dart';
import '../../models/result.dart';
import '../../models/patient.dart';
import '../../models/doctor.dart';
import '../../api/api_client.dart';
import './auth_repository.dart';
import '../auth/token_provider.dart';

class SupabaseAuthRepository implements AuthRepository {
  final TokenProvider _tokenProvider = GetIt.instance<TokenProvider>();

  @override
  Future<ReturnResult<User>> login(String email, String password) async {
    try {
      final response = await ApiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return ReturnResult(
          state: false,
          message: data['message'] ?? 'Login failed',
        );
      }

      // 🔑 STORE TOKEN GLOBALLY
      final accessToken = data['access_token'];
      _tokenProvider.setToken(accessToken);

      // 🔁 FETCH CURRENT USER USING TOKEN
      final meResponse = await ApiClient.get('/auth/me', token: accessToken);

      if (meResponse.statusCode != 200) {
        _tokenProvider.clear();
        return ReturnResult(
          state: false,
          message: 'Failed to fetch user profile',
        );
      }

      final userMap = jsonDecode(meResponse.body);

      return ReturnResult(
        state: true,
        message: 'Login successful',
        data: User.fromMap(userMap),
      );
    } catch (e) {
      // Provide user-friendly error messages
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage =
            'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage =
            'Network error. Please check your internet connection and try again.';
      } else {
        errorMessage = 'Login failed: ${e.toString()}';
      }
      return ReturnResult(state: false, message: errorMessage);
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
      final response = await ApiClient.post('/auth/signup', {
        'email': user.email,
        'password': password,
        'firstname': user.firstname,
        'lastname': user.lastname,
        'phone_number': user.phoneNumber,
        'nin': user.nin,
        'date_of_birth': patientData?.dateOfBirth,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return ReturnResult(
          state: false,
          message: data['message'] ?? 'Signup failed',
        );
      }

      // Backend returns { user: {...}, access_token: ..., refresh_token: ... }
      // Store the access token if provided (user is automatically logged in after signup)
      final accessToken = data['access_token'];
      if (accessToken != null &&
          accessToken is String &&
          accessToken.isNotEmpty) {
        _tokenProvider.setToken(accessToken);
      } else {
        // If no token was returned, try to login automatically as fallback
        try {
          final loginResult = await login(user.email, password);
          if (loginResult.state && loginResult.data != null) {
            // Token is now stored from login, return the user from login
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

      // Add password to the user map since backend doesn't return it
      // but User.fromMap requires it (we use the password we already have)
      final userWithPassword = Map<String, dynamic>.from(userMap);
      userWithPassword['password'] = password;

      return ReturnResult(
        state: true,
        message: 'Signup successful',
        data: User.fromMap(userWithPassword),
      );
    } catch (e) {
      // Provide user-friendly error messages
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage =
            'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage =
            'Network error. Please check your internet connection and try again.';
      } else {
        errorMessage = 'Signup failed: ${e.toString()}';
      }
      return ReturnResult(state: false, message: errorMessage);
    }
  }

  @override
  Future<ReturnResult> logout() async {
    // 🔥 CLEAR TOKEN GLOBALLY
    _tokenProvider.clear();

    return ReturnResult(state: true, message: 'Logged out');
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

      final response = await ApiClient.get('/auth/me', token: token);

      if (response.statusCode != 200) {
        _tokenProvider.clear();
        return ReturnResult(
          state: false,
          message: 'Session expired',
          data: null,
        );
      }

      return ReturnResult(
        state: true,
        message: 'User loaded',
        data: User.fromMap(jsonDecode(response.body)),
      );
    } catch (e) {
      // Provide user-friendly error messages
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage =
            'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage =
            'Network error. Please check your internet connection and try again.';
      } else {
        errorMessage = 'Failed to fetch user: ${e.toString()}';
      }
      return ReturnResult(state: false, message: errorMessage);
    }
  }

  @override
  Future<bool> emailExists(String email) async {
    try {
      final response = await ApiClient.get('/users/email-exists?email=$email');

      final data = jsonDecode(response.body);
      return data['exists'] ?? false;
    } catch (e) {
      // Re-throw the exception so it can be handled in the cubit
      rethrow;
    }
  }
}
