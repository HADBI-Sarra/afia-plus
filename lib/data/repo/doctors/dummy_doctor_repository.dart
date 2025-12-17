import '../../models/doctor.dart';
import '../../models/result.dart';
import '../../models/review.dart';
import 'doctor_repository.dart';

class DummyDoctorRepository implements DoctorRepository {
	final List<Doctor> _doctors = [];
	int _autoId = 1;

	String? _validateLongInput(String? value) {
		if (value == null || value.isEmpty) return 'Field cannot be empty';
		if (value.length < 15) return 'Enter at least 15 characters';
		return null;
	}

	String? _validateShortInput(String? value) {
		if (value == null || value.isEmpty) return 'Field cannot be empty';
		if (value.length < 5) return 'Enter at least 5 characters';
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

	String? _validateShortOptionalInput(String? value) {
		if (value != null && value.isNotEmpty && value.length < 5) return 'Enter at least 5 characters';
		return null;
	}

	String? _validateLicenceNumber(String? value) {
		if (value == null || value.isEmpty) return 'Field cannot be empty';
		if (!RegExp(r'^\d{4,6}$').hasMatch(value)) return 'Enter a valid licence number';
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
		if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
			return 'Enter a valid email';
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
		return _doctors.any((d) => d.email == email);
	}

	bool _emailExistsForAnother(String email, int userId) {
		return _doctors.any((d) => d.email == email && d.userId != userId);
	}

	String? _validateYearsOfExperience(String? value) {
		if (value == null || value.isEmpty) return 'Field cannot be empty';
		final n = int.tryParse(value);
		if (n == null || n < 0 || n > 60) return 'Enter a valid number of years';
		return null;
	}

	@override
	Future<ReturnResult<Doctor>> createDoctor(Doctor doctor) async {
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

		if (_emailExists(doctor.email)) {
			return ReturnResult(state: false, message: 'Email is already registered');
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

	final newDoctor = Doctor(
		userId: _autoId++,
		role: doctor.role,
		firstname: doctor.firstname,
		lastname: doctor.lastname,
		email: doctor.email,
		password: doctor.password,
		phoneNumber: doctor.phoneNumber,
		nin: doctor.nin,
		profilePicture: doctor.profilePicture,
		specialityId: doctor.specialityId,
		bio: doctor.bio,
		locationOfWork: doctor.locationOfWork,
		degree: doctor.degree,
		university: doctor.university,
		certification: doctor.certification,
		institution: doctor.institution,
		residency: doctor.residency,
		licenseNumber: doctor.licenseNumber,
		licenseDescription: doctor.licenseDescription,
		yearsExperience: doctor.yearsExperience,
		areasOfExpertise: doctor.areasOfExpertise,
		pricePerHour: doctor.pricePerHour,
		averageRating: doctor.averageRating,
		reviewsCount: doctor.reviewsCount,
	);		_doctors.add(newDoctor);
		return ReturnResult(state: true, message: 'Doctor created successfully', data: newDoctor);
	}

	@override
	Future<ReturnResult<Doctor?>> getDoctorById(int id) async {
		try {
			final index = _doctors.indexWhere((d) => d.userId == id);
			if (index != -1) return ReturnResult(state: true, message: 'Doctor found', data: _doctors[index]);
			return ReturnResult(state: false, message: 'Doctor not found');
		} catch (e) {
			return ReturnResult(state: false, message: 'Error fetching doctor: $e');
		}
	}

	@override
	Future<ReturnResult<List<Doctor>>> getAllDoctors() async {
		try {
			return ReturnResult(state: true, message: 'Doctors fetched', data: List.from(_doctors));
		} catch (e) {
			return ReturnResult(state: false, message: 'Error fetching doctors: $e', data: []);
		}
	}

	@override
	Future<ReturnResult<Doctor>> updateDoctor(Doctor updated) async {
		final firstNameError = _validateFirstName(updated.firstname);
		if (firstNameError != null) return ReturnResult(state: false, message: firstNameError);

		final lastNameError = _validateLastName(updated.lastname);
		if (lastNameError != null) return ReturnResult(state: false, message: lastNameError);

		final phoneError = _validatePhoneNumber(updated.phoneNumber);
		if (phoneError != null) return ReturnResult(state: false, message: phoneError);

		final ninError = _validateNin(updated.nin);
		if (ninError != null) return ReturnResult(state: false, message: ninError);

		final emailError = _validateEmail(updated.email);
		if (emailError != null) return ReturnResult(state: false, message: emailError);

		final passwordError = _validatePassword(updated.password);
		if (passwordError != null) return ReturnResult(state: false, message: passwordError);

		if (updated.userId != null) {
			if (_emailExistsForAnother(updated.email, updated.userId!)) {
				return ReturnResult(state: false, message: 'Email already used by another account');
			}
		}

		final bioError = _validateLongInput(updated.bio);
		if (bioError != null) return ReturnResult(state: false, message: bioError);

		final workError = _validateShortInput(updated.locationOfWork);
		if (workError != null) return ReturnResult(state: false, message: workError);

		final degreeError = _validateShortInput(updated.degree);
		if (degreeError != null) return ReturnResult(state: false, message: degreeError);

		final uniError = _validateShortInput(updated.university);
		if (uniError != null) return ReturnResult(state: false, message: uniError);

		final certError = _validateShortOptionalInput(updated.certification);
		if (certError != null) return ReturnResult(state: false, message: certError);

		final instError = _validateShortOptionalInput(updated.institution);
		if (instError != null) return ReturnResult(state: false, message: instError);

		final residencyError = _validateMediumOptionalInput(updated.residency);
		if (residencyError != null) return ReturnResult(state: false, message: residencyError);

		if (updated.licenseNumber == null) return ReturnResult(state: false, message: 'License number required');
		final licError = _validateLicenceNumber(updated.licenseNumber);
		if (licError != null) return ReturnResult(state: false, message: licError);

		final licDescError = _validateMediumOptionalInput(updated.licenseDescription);
		if (licDescError != null) return ReturnResult(state: false, message: licDescError);

		if (updated.yearsExperience != null) {
			final yearsError = _validateYearsOfExperience(updated.yearsExperience.toString());
			if (yearsError != null) return ReturnResult(state: false, message: yearsError);
		}

		final areasError = _validateMediumInput(updated.areasOfExpertise);
		if (areasError != null) return ReturnResult(state: false, message: areasError);

	final index = _doctors.indexWhere((d) => d.userId == updated.userId);
	if (index == -1) return ReturnResult(state: false, message: 'Doctor not found');		_doctors[index] = updated;
		return ReturnResult(state: true, message: 'Doctor updated successfully', data: updated);
	}

	@override
	Future<ReturnResult> deleteDoctor(int id) async {
		final index = _doctors.indexWhere((d) => d.userId == id);
		if (index == -1) return ReturnResult(state: false, message: 'Doctor not found');
		_doctors.removeAt(index);
		return ReturnResult(state: true, message: 'Doctor deleted successfully');
	}

	@override
	Future<ReturnResult<List<Review>>> getReviewsByDoctorId(int doctorId) async {
		// Dummy implementation - return empty list
		// In a real scenario, you might want to return some dummy reviews for testing
		return ReturnResult(state: true, message: 'Reviews fetched successfully', data: []);
	}
}

