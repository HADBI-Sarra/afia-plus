import 'package:sqflite/sqflite.dart';
import '../../db_helper.dart';
import '../../models/patient.dart';
import '../../models/result.dart';
import 'patient_repository.dart';

class DBPatientRepository implements PatientRepository {

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

  String? _validateDob(String? dob) {
    if (dob == null || dob.isEmpty) return 'Date of birth cannot be empty';

    try {
      DateTime parsed;
      if (dob.contains('/')) {
        final parts = dob.split('/');
        parsed = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else if (dob.contains('-')) {
        parsed = DateTime.parse(dob);
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

  Future<bool> _emailExists(Database db, String email) async {
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> _emailExistsForAnother(Database db, String email, int userId) async {
    final result = await db.query(
      'users',
      where: 'email = ? AND user_id != ?',
      whereArgs: [email, userId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  @override
  Future<ReturnResult<Patient>> createPatient(Patient patient) async {
    final db = await DBHelper.getDatabase();

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

    if (await _emailExists(db, patient.email)) {
      return ReturnResult(
        state: false,
        message: 'Email is already registered',
      );
    }

    try {
      final userId = await db.insert(
        'users',
        {
          'role': patient.role,
          'firstname': patient.firstname,
          'lastname': patient.lastname,
          'email': patient.email,
          'password': patient.password,
          'phone_number': patient.phoneNumber,
          'nin': patient.nin,
          'profile_picture': patient.profilePicture,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await db.insert(
        'patients',
        {
          'patient_id': userId,
          'date_of_birth': patient.dateOfBirth,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final createdPatient = patient.copyWith(userId: userId);

      return ReturnResult(
        state: true,
        message: 'Patient inserted successfully',
        data: createdPatient,
      );
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Patient could not be inserted: $e',
      );
    }
  }

  @override
  Future<ReturnResult<Patient?>> getPatientById(int id) async {
    final db = await DBHelper.getDatabase();
    try {
      final result = await db.rawQuery('''
        SELECT u.*, p.date_of_birth
        FROM users u
        JOIN patients p ON u.user_id = p.patient_id
        WHERE u.user_id = ?
      ''', [id]);

      if (result.isNotEmpty) {
        return ReturnResult(
          state: true,
          message: 'Patient found',
          data: Patient.fromMap(result.first),
        );
      }

      return ReturnResult(state: false, message: 'Patient not found');
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Error fetching patient: $e',
      );
    }
  }

  @override
  Future<ReturnResult<List<Patient>>> getAllPatients() async {
    final db = await DBHelper.getDatabase();
    try {
      final result = await db.rawQuery('''
        SELECT u.*, p.date_of_birth
        FROM users u
        JOIN patients p ON u.user_id = p.patient_id
        ORDER BY u.user_id
      ''');

      final patients = result.map((row) => Patient.fromMap(row)).toList();

      return ReturnResult(
        state: true,
        message: 'Patients fetched',
        data: patients,
      );
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Error fetching patients: $e',
        data: [],
      );
    }
  }

  @override
  Future<ReturnResult<Patient>> updatePatient(Patient patient) async {
    final db = await DBHelper.getDatabase();

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
      if (await _emailExistsForAnother(db, patient.email, patient.userId!)) {
        return ReturnResult(state: false, message: 'Email already used by another account');
      }
    }

    final dobErr = _validateDob(patient.dateOfBirth);
    if (dobErr != null) return ReturnResult(state: false, message: dobErr);

    try {
      final userCount = await db.update(
        'users',
        {
          'role': patient.role,
          'firstname': patient.firstname,
          'lastname': patient.lastname,
          'email': patient.email,
          'password': patient.password,
          'phone_number': patient.phoneNumber,
          'nin': patient.nin,
          'profile_picture': patient.profilePicture,
        },
        where: 'user_id = ?',
        whereArgs: [patient.userId],
      );

      final patientCount = await db.update(
        'patients',
        {
          'date_of_birth': patient.dateOfBirth,
        },
        where: 'patient_id = ?',
        whereArgs: [patient.userId],
      );

      if (userCount > 0 && patientCount > 0) {
        return ReturnResult(
          state: true,
          message: 'Patient updated successfully',
          data: patient,
        );
      }

      return ReturnResult(state: false, message: 'Patient not found');
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Patient could not be updated: $e',
      );
    }
  }

  @override
  Future<ReturnResult> deletePatient(int id) async {
    final db = await DBHelper.getDatabase();

    try {
      final count = await db.delete(
        'users',
        where: 'user_id = ?',
        whereArgs: [id],
      );

      if (count > 0) {
        return ReturnResult(
          state: true,
          message: 'Patient deleted successfully',
        );
      }

      return ReturnResult(state: false, message: 'Patient not found');
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Patient could not be deleted: $e',
      );
    }
  }
}
