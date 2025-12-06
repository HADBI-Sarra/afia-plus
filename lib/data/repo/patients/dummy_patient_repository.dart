import '../../models/patient.dart';
import '../../models/result.dart';
import 'patient_repository.dart';

class DummyPatientRepository implements PatientRepository {
  final List<Patient> _patients = [];
  int _autoId = 1;

  String? _validateDob(String? value) {
    if (value == null || value.isEmpty) return 'Date of birth cannot be empty';

    try {
      DateTime parsed;
      if (value.contains('/')) {
        final parts = value.split('/');
        parsed = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else if (value.contains('-')) {
        parsed = DateTime.parse(value);
      } else {
        return 'Invalid date format';
      }

      if (parsed.year >= DateTime.now().year - 16) {
        return 'You must be at least 16 years old';
      }
    } catch (_) {
      return 'Invalid date format';
    }

    return null;
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) return 'First name cannot be empty';
    if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) {
      return 'Enter a valid first name';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) return 'Last name cannot be empty';
    if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) {
      return 'Enter a valid last name';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Phone number cannot be empty';
    if (!RegExp(r'^0[567][0-9]{8}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateNin(String? value) {
    if (value == null || value.isEmpty) return 'NIN cannot be empty';
    if (!RegExp(r'^[0-9]{18}$').hasMatch(value)) return 'Enter a valid NIN';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';
    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
      return 'Enter a valid email address';
    }
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

  bool _emailExists(String email) {
    return _patients.any((p) => p.email == email);
  }

  bool _emailExistsForAnother(String email, int userId) {
    return _patients.any((p) => p.email == email && p.userId != userId);
  }

  @override
  Future<ReturnResult<Patient>> createPatient(Patient patient) async {
    final f = _validateFirstName(patient.firstname);
    if (f != null) return ReturnResult(state: false, message: f);

    final l = _validateLastName(patient.lastname);
    if (l != null) return ReturnResult(state: false, message: l);

    final p = _validatePhoneNumber(patient.phoneNumber);
    if (p != null) return ReturnResult(state: false, message: p);

    final n = _validateNin(patient.nin);
    if (n != null) return ReturnResult(state: false, message: n);

    final e = _validateEmail(patient.email);
    if (e != null) return ReturnResult(state: false, message: e);

    final passwordError = _validatePassword(patient.password);
    if (passwordError != null) return ReturnResult(state: false, message: passwordError);

    final dobErr = _validateDob(patient.dateOfBirth);
    if (dobErr != null) return ReturnResult(state: false, message: dobErr);

    if (_emailExists(patient.email)) {
      return ReturnResult(state: false, message: 'Email is already registered');
    }

    final newPatient = Patient(
      userId: _autoId++,
      role: patient.role,
      firstname: patient.firstname,
      lastname: patient.lastname,
      email: patient.email,
      password: patient.password,
      phoneNumber: patient.phoneNumber,
      nin: patient.nin,
      profilePicture: patient.profilePicture,
      dateOfBirth: patient.dateOfBirth,
    );

    _patients.add(newPatient);
    return ReturnResult(state: true, message: 'Patient created successfully', data: newPatient);
  }

  @override
  Future<ReturnResult<Patient?>> getPatientById(int id) async {
    try {
      final index = _patients.indexWhere((p) => p.userId == id);
      if (index != -1) {
        return ReturnResult(state: true, message: 'Patient found', data: _patients[index]);
      }
      return ReturnResult(state: false, message: 'Patient not found');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error fetching patient: $e');
    }
  }

  @override
  Future<ReturnResult<List<Patient>>> getAllPatients() async {
    try {
      return ReturnResult(state: true, message: 'Patients fetched', data: List.from(_patients));
    } catch (e) {
      return ReturnResult(state: false, message: 'Error fetching patients: $e', data: []);
    }
  }

  @override
  Future<ReturnResult<Patient>> updatePatient(Patient patient) async {
    final f = _validateFirstName(patient.firstname);
    if (f != null) return ReturnResult(state: false, message: f);

    final l = _validateLastName(patient.lastname);
    if (l != null) return ReturnResult(state: false, message: l);

    final p = _validatePhoneNumber(patient.phoneNumber);
    if (p != null) return ReturnResult(state: false, message: p);

    final n = _validateNin(patient.nin);
    if (n != null) return ReturnResult(state: false, message: n);

    final e = _validateEmail(patient.email);
    if (e != null) return ReturnResult(state: false, message: e);

    final passwordError = _validatePassword(patient.password);
    if (passwordError != null) return ReturnResult(state: false, message: passwordError);

    if (patient.userId != null) {
      if (_emailExistsForAnother(patient.email, patient.userId!)) {
        return ReturnResult(state: false, message: 'Email already used by another account');
      }
    }

    final dobError = _validateDob(patient.dateOfBirth);
    if (dobError != null) return ReturnResult(state: false, message: dobError);

    final index = _patients.indexWhere((p) => p.userId == patient.userId);
    if (index == -1) return ReturnResult(state: false, message: 'Patient not found');

    _patients[index] = patient;
    return ReturnResult(state: true, message: 'Patient updated successfully', data: patient);
  }

  @override
  Future<ReturnResult> deletePatient(int id) async {
    final index = _patients.indexWhere((p) => p.userId == id);
    if (index == -1) return ReturnResult(state: false, message: 'Patient not found');

    _patients.removeAt(index);
    return ReturnResult(state: true, message: 'Patient deleted successfully');
  }
}
