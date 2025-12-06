import 'package:sqflite/sqflite.dart';
import '../../db_helper.dart';
import '../../models/doctor.dart';
import '../../models/result.dart';
import 'doctor_repository.dart';

class DBDoctorRepository implements DoctorRepository {

  String? _validateLongInput(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (value.length < 15) return 'Enter at least 15 characters';
    return null;
  }

  String? _validateMediumInput(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (value.length < 10) return 'Enter at least 10 characters';
    return null;
  }

  String? _validateMediumOptionalInput(String? value) {
    if (value != null && value.isNotEmpty && value.length < 10) return 'Enter at least 10 characters';
    return null;
  }

  String? _validateShortInput(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (value.length < 5) return 'Enter at least 5 characters';
    return null;
  }

  String? _validateShortOptionalInput(String? value) {
    if (value != null && value.isNotEmpty && value.length < 5) return 'Enter at least 5 characters';
    return null;
  }

  String? _validateLicenceNumber(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (!RegExp(r'^\d{4,6}$').hasMatch(value)) return 'Enter a valid licence number';
    return null;
  }

  String? _validateYearsOfExperience(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    final n = int.tryParse(value);
    if (n == null || n < 0 || n > 60) return 'Enter a valid number of years';
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
    if (!RegExp(r'^[0-9]{18}$').hasMatch(value)) {
      return 'Enter a valid NIN';
    }
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
  Future<ReturnResult<Doctor>> createDoctor(Doctor doctor) async {
    final db = await DBHelper.getDatabase();

    final firstNameError = _validateFirstName(doctor.firstname);
    if (firstNameError != null) return ReturnResult(state: false, message: firstNameError);

    final lastNameError = _validateLastName(doctor.lastname);
    if (lastNameError != null) return ReturnResult(state: false, message: lastNameError);

    final phoneError = _validatePhoneNumber(doctor.phoneNumber);
    if (phoneError != null) return ReturnResult(state: false, message: phoneError);

    final ninError = _validateNin(doctor.nin);
    if (ninError != null) return ReturnResult(state: false, message: ninError);

    final emailError = _validateEmail(doctor.email);
    if (emailError != null) return ReturnResult(state: false, message: emailError);

    final passwordError = _validatePassword(doctor.password);
    if (passwordError != null) return ReturnResult(state: false, message: passwordError);

    if (await _emailExists(db, doctor.email)) {
      return ReturnResult(state: false, message: 'Email already used');
    }

    final bioError = _validateLongInput(doctor.bio);
    if (bioError != null) return ReturnResult(state: false, message: bioError);

    final workError = _validateShortInput(doctor.locationOfWork);
    if (workError != null) return ReturnResult(state: false, message: workError);

    final degreeError = _validateShortInput(doctor.degree);
    if (degreeError != null) return ReturnResult(state: false, message: degreeError);

    final uniError = _validateShortInput(doctor.university);
    if (uniError != null) return ReturnResult(state: false, message: uniError);

    final certError = _validateShortOptionalInput(doctor.certification);
    if (certError != null) return ReturnResult(state: false, message: certError);

    final instError = _validateShortOptionalInput(doctor.institution);
    if (instError != null) return ReturnResult(state: false, message: instError);

    final residencyError = _validateMediumOptionalInput(doctor.residency);
    if (residencyError != null) return ReturnResult(state: false, message: residencyError);

    if (doctor.licenseNumber == null) return ReturnResult(state: false, message: 'License number required');
    final licError = _validateLicenceNumber(doctor.licenseNumber);
    if (licError != null) return ReturnResult(state: false, message: licError);

    final licDescError = _validateMediumOptionalInput(doctor.licenseDescription);
    if (licDescError != null) return ReturnResult(state: false, message: licDescError);

    if (doctor.yearsExperience != null) {
      final yearsError = _validateYearsOfExperience(doctor.yearsExperience.toString());
      if (yearsError != null) return ReturnResult(state: false, message: yearsError);
    }

    final areasError = _validateMediumInput(doctor.areasOfExpertise);
    if (areasError != null) return ReturnResult(state: false, message: areasError);

    try {
      final userId = await db.insert(
        'users',
        {
          'role': doctor.role,
          'firstname': doctor.firstname,
          'lastname': doctor.lastname,
          'email': doctor.email,
          'password': doctor.password,
          'phone_number': doctor.phoneNumber,
          'nin': doctor.nin,
          'profile_picture': doctor.profilePicture,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await db.insert(
        'doctors',
        {
          'doctor_id': userId,
          'speciality_id': doctor.specialityId,
          'bio': doctor.bio,
          'location_of_work': doctor.locationOfWork,
          'degree': doctor.degree,
          'university': doctor.university,
          'certification': doctor.certification,
          'institution': doctor.institution,
          'residency': doctor.residency,
          'license_number': doctor.licenseNumber,
          'license_description': doctor.licenseDescription,
          'years_experience': doctor.yearsExperience,
          'areas_of_expertise': doctor.areasOfExpertise,
          'price_per_hour': doctor.pricePerHour,
          'average_rating': doctor.averageRating,
          'reviews_count': doctor.reviewsCount,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return ReturnResult(state: true, message: 'Doctor inserted successfully', data: doctor);
    } catch (e) {
      return ReturnResult(state: false, message: 'Doctor could not be inserted: $e');
    }
  }

  @override
  Future<ReturnResult<Doctor?>> getDoctorById(int id) async {
    final db = await DBHelper.getDatabase();
    try {
      final result = await db.rawQuery('''
        SELECT u.*, d.speciality_id, d.bio, d.location_of_work, d.degree, d.university,
               d.certification, d.institution, d.residency, d.license_number,
               d.license_description, d.years_experience, d.areas_of_expertise,
               d.price_per_hour, d.average_rating, d.reviews_count
        FROM users u
        JOIN doctors d ON u.user_id = d.doctor_id
        WHERE u.user_id = ?
      ''', [id]);

      if (result.isNotEmpty) {
        return ReturnResult(state: true, message: 'Doctor found', data: Doctor.fromMap(result.first));
      }
      return ReturnResult(state: false, message: 'Doctor not found');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error fetching doctor: $e');
    }
  }

  @override
  Future<ReturnResult<List<Doctor>>> getAllDoctors() async {
    final db = await DBHelper.getDatabase();
    try {
      final result = await db.rawQuery('''
        SELECT u.*, d.speciality_id, d.bio, d.location_of_work, d.degree, d.university,
               d.certification, d.institution, d.residency, d.license_number,
               d.license_description, d.years_experience, d.areas_of_expertise,
               d.price_per_hour, d.average_rating, d.reviews_count
        FROM users u
        JOIN doctors d ON u.user_id = d.doctor_id
        ORDER BY u.user_id
      ''');

      final doctors = result.map((row) => Doctor.fromMap(row)).toList();
      return ReturnResult(state: true, message: 'Doctors fetched', data: doctors);
    } catch (e) {
      return ReturnResult(state: false, message: 'Error fetching doctors: $e', data: []);
    }
  }

  @override
  Future<ReturnResult<Doctor>> updateDoctor(Doctor doctor) async {
    final db = await DBHelper.getDatabase();

    final firstNameError = _validateFirstName(doctor.firstname);
    if (firstNameError != null) return ReturnResult(state: false, message: firstNameError);

    final lastNameError = _validateLastName(doctor.lastname);
    if (lastNameError != null) return ReturnResult(state: false, message: lastNameError);

    final phoneError = _validatePhoneNumber(doctor.phoneNumber);
    if (phoneError != null) return ReturnResult(state: false, message: phoneError);

    final ninError = _validateNin(doctor.nin);
    if (ninError != null) return ReturnResult(state: false, message: ninError);

    final emailError = _validateEmail(doctor.email);
    if (emailError != null) return ReturnResult(state: false, message: emailError);

    final passwordError = _validatePassword(doctor.password);
    if (passwordError != null) return ReturnResult(state: false, message: passwordError);

    if (doctor.userId != null) {
      if (await _emailExistsForAnother(db, doctor.email, doctor.userId!)) {
        return ReturnResult(state: false, message: 'Email already used by another account');
      }
    }

    final bioError = _validateLongInput(doctor.bio);
    if (bioError != null) return ReturnResult(state: false, message: bioError);

    final workError = _validateShortInput(doctor.locationOfWork);
    if (workError != null) return ReturnResult(state: false, message: workError);

    final degreeError = _validateShortInput(doctor.degree);
    if (degreeError != null) return ReturnResult(state: false, message: degreeError);

    final uniError = _validateShortInput(doctor.university);
    if (uniError != null) return ReturnResult(state: false, message: uniError);

    final certError = _validateShortOptionalInput(doctor.certification);
    if (certError != null) return ReturnResult(state: false, message: certError);

    final instError = _validateShortOptionalInput(doctor.institution);
    if (instError != null) return ReturnResult(state: false, message: instError);

    final residencyError = _validateMediumOptionalInput(doctor.residency);
    if (residencyError != null) return ReturnResult(state: false, message: residencyError);

    if (doctor.licenseNumber == null) return ReturnResult(state: false, message: 'License number required');
    final licError = _validateLicenceNumber(doctor.licenseNumber);
    if (licError != null) return ReturnResult(state: false, message: licError);

    final licDescError = _validateMediumOptionalInput(doctor.licenseDescription);
    if (licDescError != null) return ReturnResult(state: false, message: licDescError);

    if (doctor.yearsExperience != null) {
      final yearsError = _validateYearsOfExperience(doctor.yearsExperience.toString());
      if (yearsError != null) return ReturnResult(state: false, message: yearsError);
    }

    final areasError = _validateMediumInput(doctor.areasOfExpertise);
    if (areasError != null) return ReturnResult(state: false, message: areasError);

    try {
      final userCount = await db.update(
        'users',
        {
          'role': doctor.role,
          'firstname': doctor.firstname,
          'lastname': doctor.lastname,
          'email': doctor.email,
          'password': doctor.password,
          'phone_number': doctor.phoneNumber,
          'nin': doctor.nin,
          'profile_picture': doctor.profilePicture,
        },
        where: 'user_id = ?',
        whereArgs: [doctor.userId],
      );

      final doctorCount = await db.update(
        'doctors',
        {
          'speciality_id': doctor.specialityId,
          'bio': doctor.bio,
          'location_of_work': doctor.locationOfWork,
          'degree': doctor.degree,
          'university': doctor.university,
          'certification': doctor.certification,
          'institution': doctor.institution,
          'residency': doctor.residency,
          'license_number': doctor.licenseNumber,
          'license_description': doctor.licenseDescription,
          'years_experience': doctor.yearsExperience,
          'areas_of_expertise': doctor.areasOfExpertise,
          'price_per_hour': doctor.pricePerHour,
          'average_rating': doctor.averageRating,
          'reviews_count': doctor.reviewsCount,
        },
        where: 'doctor_id = ?',
        whereArgs: [doctor.userId],
      );

      if (userCount > 0 && doctorCount > 0) {
        return ReturnResult(state: true, message: 'Doctor updated successfully', data: doctor);
      }
      return ReturnResult(state: false, message: 'Doctor not found');
    } catch (e) {
      return ReturnResult(state: false, message: 'Doctor could not be updated: $e');
    }
  }

  @override
  Future<ReturnResult> deleteDoctor(int id) async {
    final db = await DBHelper.getDatabase();
    try {
      final count = await db.delete('users', where: 'user_id = ?', whereArgs: [id]);
      if (count > 0) return ReturnResult(state: true, message: 'Doctor deleted successfully');
      return ReturnResult(state: false, message: 'Doctor not found');
    } catch (e) {
      return ReturnResult(state: false, message: 'Doctor could not be deleted: $e');
    }
  }
}
