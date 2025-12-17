// dummy_auth_repo.dart
import '../../models/user.dart';
import '../../models/result.dart';
import '../../models/patient.dart';
import '../../models/doctor.dart';
import 'auth_repository.dart';

class DummyAuthRepository implements AuthRepository {
  final List<User> _users = [];
  User? _currentUser;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';
    if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$').hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';
    final strong = value.length >= 8 &&
        RegExp(r'[a-z]').hasMatch(value) &&
        RegExp(r'[A-Z]').hasMatch(value) &&
        RegExp(r'[0-9]').hasMatch(value) &&
        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);
    if (!strong) return 'Weak password';
    return null;
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName cannot be empty';
    if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) return 'Enter a valid $fieldName';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number cannot be empty';
    if (!RegExp(r'^0[567][0-9]{8}$').hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  String? _validateNin(String? value) {
    if (value == null || value.isEmpty) return 'NIN cannot be empty';
    if (!RegExp(r'^[0-9]{18}$').hasMatch(value)) return 'Enter a valid NIN';
    return null;
  }

  String? _validateDob(String? dob) {
    if (dob == null || dob.isEmpty) return 'Date of birth cannot be empty';
    try {
      DateTime parsed;
      if (dob.contains('/')) {
        final parts = dob.split('/');
        parsed = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      } else {
        parsed = DateTime.parse(dob);
      }
      if (parsed.year >= DateTime.now().year - 16) return 'You must be at least 16 years old';
    } catch (_) {
      return 'Invalid date format';
    }
    return null;
  }

  String? _validateDoctorFields(Doctor doctor) {
    if (doctor.bio == null || doctor.bio!.isEmpty) return 'Bio cannot be empty';
    if (doctor.bio!.length < 15) return 'Bio must be at least 15 characters';

    if (doctor.locationOfWork == null || doctor.locationOfWork!.isEmpty) return 'Location of work cannot be empty';
    if (doctor.locationOfWork!.length < 5) return 'Location of work must be at least 5 characters';

    if (doctor.degree == null || doctor.degree!.isEmpty) return 'Degree cannot be empty';
    if (doctor.degree!.length < 5) return 'Degree must be at least 5 characters';

    if (doctor.university == null || doctor.university!.isEmpty) return 'University cannot be empty';
    if (doctor.university!.length < 5) return 'University must be at least 5 characters';

    if (doctor.certification != null && doctor.certification!.isNotEmpty && doctor.certification!.length < 5) return 'Certification too short';
    if (doctor.institution != null && doctor.institution!.isNotEmpty && doctor.institution!.length < 5) return 'Institution too short';

    if (doctor.residency != null && doctor.residency!.isNotEmpty && doctor.residency!.length < 10) return 'Residency too short';

    if (doctor.licenseNumber == null || doctor.licenseNumber!.isEmpty) return 'License number required';
    if (!RegExp(r'^\d{4,6}$').hasMatch(doctor.licenseNumber!)) return 'Invalid license number';

    if (doctor.licenseDescription != null && doctor.licenseDescription!.isNotEmpty && doctor.licenseDescription!.length < 10) return 'License description too short';

    if (doctor.yearsExperience != null && (doctor.yearsExperience! < 0 || doctor.yearsExperience! > 60)) return 'Years of experience invalid';

    if (doctor.areasOfExpertise == null || doctor.areasOfExpertise!.isEmpty) return 'Areas of expertise cannot be empty';
    if (doctor.areasOfExpertise!.length < 10) return 'Areas of expertise too short';
    return null;
  }

  bool _emailExists(String email) {
    return _users.any((u) => u.email == email);
  }

  @override
  Future<ReturnResult<User>> login(String email, String password) async {
    final emailError = _validateEmail(email);
    if (emailError != null) return ReturnResult(state: false, message: emailError);

    if (password.isEmpty) return ReturnResult(state: false, message: 'Password cannot be empty');

    final user = _users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => User(
        userId: 0,
        role: '',
        firstname: '',
        lastname: '',
        email: '',
        password: '',
        phoneNumber: '',
        nin: '',
      ),
    );

    if (user.userId == 0) return ReturnResult(state: false, message: 'Invalid email or password');

    _currentUser = user;
    return ReturnResult(state: true, message: 'Login successful', data: user);
  }

  @override
  Future<ReturnResult<User>> signup(User user, String password, {Patient? patientData, Doctor? doctorData}) async {
    final emailError = _validateEmail(user.email);
    if (emailError != null) return ReturnResult(state: false, message: emailError);

    final passwordError = _validatePassword(password);
    if (passwordError != null) return ReturnResult(state: false, message: passwordError);

    final firstNameError = _validateName(user.firstname, 'First name');
    if (firstNameError != null) return ReturnResult(state: false, message: firstNameError);

    final lastNameError = _validateName(user.lastname, 'Last name');
    if (lastNameError != null) return ReturnResult(state: false, message: lastNameError);

    final phoneError = _validatePhone(user.phoneNumber);
    if (phoneError != null) return ReturnResult(state: false, message: phoneError);

    final ninError = _validateNin(user.nin);
    if (ninError != null) return ReturnResult(state: false, message: ninError);

    if (user.role == 'patient') {
      if (patientData == null) return ReturnResult(state: false, message: 'Patient data required');
      final dobError = _validateDob(patientData.dateOfBirth);
      if (dobError != null) return ReturnResult(state: false, message: dobError);
    } else if (user.role == 'doctor') {
      if (doctorData == null) return ReturnResult(state: false, message: 'Doctor data required');
      final doctorError = _validateDoctorFields(doctorData);
      if (doctorError != null) return ReturnResult(state: false, message: doctorError);
    }

    if (_emailExists(user.email)) return ReturnResult(state: false, message: 'Email already in use');

    final newUser = User(
      userId: _users.length + 1,
      role: user.role,
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email,
      password: password,
      phoneNumber: user.phoneNumber,
      nin: user.nin,
    );

    _users.add(newUser);
    _currentUser = newUser;
    return ReturnResult(state: true, message: 'Signup successful', data: newUser);
  }

  @override
  Future<ReturnResult> logout() async {
    _currentUser = null;
    return ReturnResult(state: true, message: '');
  }

  @override
  Future<ReturnResult<User?>> getCurrentUser() async {
    return ReturnResult(state: true, message: '', data: _currentUser);
  }
}
