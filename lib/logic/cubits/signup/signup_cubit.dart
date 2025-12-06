// signup_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_state.dart';
import '../../../data/repo/auth/auth_repository.dart';
import '../../../data/models/user.dart';
import '../../../data/models/patient.dart';
import '../../../data/models/doctor.dart';
import '../../../data/models/result.dart';
import 'package:intl/intl.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;

  SignupCubit({required this.authRepository}) : super(SignupState());

  // ---------------- Reset ----------------
  /// Resets the signup state to initial values
  void reset() {
    emit(SignupState());
  }

  // ---------------- Account step ----------------
  void setEmail(String value) =>
      emit(state.copyWith(email: value, emailError: _validateEmail(value)));

  void setPassword(String value) {
    final flags = _passwordFlags(value);
    final strong = flags.values.every((v) => v);

    emit(state.copyWith(
      password: value,
      long: flags['long'],
      hasLowercase: flags['lower'],
      hasUppercase: flags['upper'],
      hasNumber: flags['number'],
      hasSpecial: flags['special'],
      strongPassword: strong,
      firstTry: state.firstTry ? state.firstTry : false,
      passwordError: _validatePassword(value, strong),
    ));

    if (state.confirmPassword.isNotEmpty) setConfirmPassword(state.confirmPassword);
  }

  void setConfirmPassword(String value) =>
      emit(state.copyWith(confirmPassword: value, confirmPasswordError: _validateConfirmPassword(value)));

  void setRole(bool patient) => emit(state.copyWith(isPatient: patient));

  // ---------------- Personal data step ----------------
  void setFirstName(String value) =>
      emit(state.copyWith(firstName: value, firstNameError: _validateFirstName(value)));

  void setLastName(String value) =>
      emit(state.copyWith(lastName: value, lastNameError: _validateLastName(value)));

  void setDob(String value) => emit(state.copyWith(dob: value, dobError: _validateDob(value)));

  void setPhoneNumber(String value) =>
      emit(state.copyWith(phoneNumber: value, phoneError: _validatePhoneNumber(value)));

  void setNin(String value) => emit(state.copyWith(nin: value, ninError: _validateNin(value)));

  void toggleAgreeBox() => emit(state.copyWith(
      agreeBoxChecked: !state.agreeBoxChecked,
      redCheckBox: state.agreeBoxChecked ? false : state.redCheckBox));

  // ---------------- Professional info step ----------------
  void setBio(String value) =>
      emit(state.copyWith(bio: value, bioError: _validateBio(value)));

  void setSpeciality(String? value) =>
      emit(state.copyWith(speciality: value ?? '', specialityError: _validateSpeciality(value)));

  void setWorkingPlace(String value) =>
      emit(state.copyWith(workingPlace: value, workingPlaceError: _validateWorkingPlace(value)));

  void setDegree(String value) =>
      emit(state.copyWith(degree: value, degreeError: _validateDegree(value)));

  void setUniversity(String value) =>
      emit(state.copyWith(university: value, universityError: _validateUniversity(value)));

  void setCertification(String value) =>
      emit(state.copyWith(certification: value, certificationError: _validateCertification(value)));

  void setCertificationInstitution(String value) =>
      emit(state.copyWith(certificationInstitution: value, certificationInstitutionError: _validateCertificationInstitution(value)));

  void setTraining(String value) =>
      emit(state.copyWith(training: value, trainingError: _validateTraining(value)));

  void setLicenceNumber(String value) =>
      emit(state.copyWith(licenceNumber: value, licenceNumberError: _validateLicenceNumber(value)));

  void setLicenceDesc(String value) =>
      emit(state.copyWith(licenceDesc: value, licenceDescError: _validateLicenceDesc(value)));

  void setYearsOfExperience(String value) =>
      emit(state.copyWith(yearsOfExperience: value, yearsOfExperienceError: _validateYearsOfExperience(value)));

  void setAreasOfExperience(String value) =>
      emit(state.copyWith(areasOfExperience: value, areasOfExperienceError: _validateAreasOfExperience(value)));

  void setConsultationPrice(String value) =>
      emit(state.copyWith(consultationPrice: value, consultationPriceError: _validateConsultationPrice(value)));

  void toggleProfessionalAgreeBox() => emit(state.copyWith(
      professionalAgreeBoxChecked: !state.professionalAgreeBoxChecked,
      professionalRedCheckBox: state.professionalAgreeBoxChecked ? false : state.professionalRedCheckBox));

  void setSpecialityId(int id) {
    emit(state.copyWith(specialityId: id));
  }

  void setSpecialityName(String name) {
    emit(state.copyWith(
      specialityName: name,
      specialityError: _validateSpeciality(name),
    ));
  }

  // ---------------- Submission ----------------
  /// Validates **account info only** for Step 1
  bool validateAccountStep() {
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password, state.strongPassword);
    final confirmError = _validateConfirmPassword(state.confirmPassword);

    emit(state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmError,
    ));

    return emailError == null && passwordError == null && confirmError == null;
  }

  /// Validates **personal info only** for Step 2
  bool validatePersonalStep() {
    final firstError = _validateFirstName(state.firstName);
    final lastError = _validateLastName(state.lastName);
    final dobError = state.isPatient ? _validateDob(state.dob) : null;
    final phoneError = _validatePhoneNumber(state.phoneNumber);
    final ninError = _validateNin(state.nin);
    final checkboxError = state.isPatient && !state.agreeBoxChecked;

    emit(state.copyWith(
      firstNameError: firstError,
      lastNameError: lastError,
      dobError: dobError,
      phoneError: phoneError,
      ninError: ninError,
      redCheckBox: checkboxError,
    ));

    return firstError == null &&
        lastError == null &&
        phoneError == null &&
        ninError == null &&
        (state.isPatient ? dobError == null && !checkboxError : true);
  }

  /// Validates **professional info only** for Step 3
  bool validateProfessionalStep() {
    final bioError = _validateBio(state.bio);
    final specialityError = _validateSpeciality(state.speciality);
    final workError = _validateWorkingPlace(state.workingPlace);
    final degreeError = _validateDegree(state.degree);
    final universityError = _validateUniversity(state.university);
    final licenceError = _validateLicenceNumber(state.licenceNumber);
    final yearsError = _validateYearsOfExperience(state.yearsOfExperience);
    final areasError = _validateAreasOfExperience(state.areasOfExperience);
    final priceError = _validateConsultationPrice(state.consultationPrice);
    final checkboxError = !state.professionalAgreeBoxChecked;

    emit(state.copyWith(
      bioError: bioError,
      specialityError: specialityError,
      workingPlaceError: workError,
      degreeError: degreeError,
      universityError: universityError,
      licenceNumberError: licenceError,
      yearsOfExperienceError: yearsError,
      areasOfExperienceError: areasError,
      consultationPriceError: priceError,
      professionalRedCheckBox: checkboxError,
    ));

    return bioError == null &&
        specialityError == null &&
        workError == null &&
        degreeError == null &&
        universityError == null &&
        licenceError == null &&
        yearsError == null &&
        areasError == null &&
        priceError == null &&
        !checkboxError;
  }

  Future<void> submitPersonalData() async {
    if (state.currentStep == SignupStep.account) {
      if (!validateAccountStep()) return;

      // Move to personal step
      emit(state.copyWith(
        message: '',
        currentStep: SignupStep.personal,
      ));
      return;
    }

    if (state.currentStep == SignupStep.personal) {
      if (!validatePersonalStep()) return;

      emit(state.copyWith(isLoading: true, message: ''));

      // --- Patient signup happens right here ---
      if (state.isPatient) {
        try {
          final user = User(
            role: 'patient',
            firstname: state.firstName,
            lastname: state.lastName,
            email: state.email,
            password: state.password,
            phoneNumber: state.phoneNumber,
            nin: state.nin,
          );

          final patientData = Patient(
            role: 'patient',
            firstname: state.firstName,
            lastname: state.lastName,
            email: state.email,
            password: state.password,
            phoneNumber: state.phoneNumber,
            nin: state.nin,
            dateOfBirth: state.dob,
          );

          final result = await authRepository.signup(
            user,
            state.password,
            patientData: patientData,
          );

          emit(state.copyWith(
            isLoading: false,
            message: result.state ? 'Success' : result.message,
          ));
        } catch (e) {
          emit(state.copyWith(isLoading: false, message: 'An error occurred'));
        }
        return;
      }

      // --- Doctor goes to professional page ---
      emit(state.copyWith(
        isLoading: false,
        message: 'NextStep',
        currentStep: SignupStep.professional,
      ));
    }
  }

  /// Dedicated method to submit personal data for patients
  Future<void> submitPatientPersonalData() async {
    // Validate personal data first
    if (!validatePersonalStep()) return;

    emit(state.copyWith(isLoading: true, message: ''));

    try {
      final user = User(
        role: 'patient',
        firstname: state.firstName,
        lastname: state.lastName,
        email: state.email,
        password: state.password,
        phoneNumber: state.phoneNumber,
        nin: state.nin,
      );

      final patientData = Patient(
        role: 'patient',
        firstname: state.firstName,
        lastname: state.lastName,
        email: state.email,
        password: state.password,
        phoneNumber: state.phoneNumber,
        nin: state.nin,
        dateOfBirth: state.dob,
      );

      final result = await authRepository.signup(
        user,
        state.password,
        patientData: patientData,
      );

      emit(state.copyWith(
        isLoading: false,
        message: result.state ? 'Success' : result.message,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: 'An error occurred'));
    }
  }

  /// Final step for doctor: perform signup using BOTH personal + professional data
  Future<void> submitProfessionalData() async {
    if (!validateProfessionalStep()) return;

    emit(state.copyWith(isLoading: true, message: ''));

    try {
      final user = User(
        role: 'doctor',
        firstname: state.firstName,
        lastname: state.lastName,
        email: state.email,
        password: state.password,
        phoneNumber: state.phoneNumber,
        nin: state.nin,
      );

      final doctorData = Doctor(
        role: 'doctor',
        firstname: state.firstName,
        lastname: state.lastName,
        email: state.email,
        password: state.password,
        phoneNumber: state.phoneNumber,
        nin: state.nin,
        bio: state.bio,
        locationOfWork: state.workingPlace,
        degree: state.degree,
        university: state.university,
        certification: state.certification,
        institution: state.certificationInstitution,
        licenseNumber: state.licenceNumber,
        licenseDescription: state.licenceDesc,
        yearsExperience: int.tryParse(state.yearsOfExperience),
        areasOfExpertise: state.areasOfExperience,
        pricePerHour: int.tryParse(state.consultationPrice),
      );

      final result = await authRepository.signup(
        user,
        state.password,
        doctorData: doctorData,
      );

      emit(state.copyWith(
        isLoading: false,
        message: result.state ? 'Success' : result.message,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: 'An error occurred'));
    }
  }

  // ---------------- Validators ----------------
  String? _validateEmail(String value) {
    if (value.isEmpty) return 'Email cannot be empty';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String value, bool strongPassword) {
    if (value.isEmpty) return 'Password cannot be empty';
    if (!strongPassword) return 'Weak password';
    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) return 'Password confirmation cannot be empty';
    if (value != state.password) return 'Passwords do not match';
    return null;
  }

  Map<String, bool> _passwordFlags(String value) => {
        'long': value.length >= 8,
        'lower': RegExp(r'[a-z]').hasMatch(value),
        'upper': RegExp(r'[A-Z]').hasMatch(value),
        'number': RegExp(r'[0-9]').hasMatch(value),
        'special': RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value),
      };

  String? _validateFirstName(String value) {
    if (value.isEmpty) return 'First name cannot be empty';
    if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) return 'Enter a valid first name';
    return null;
  }

  String? _validateLastName(String value) {
    if (value.isEmpty) return 'Last name cannot be empty';
    if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) return 'Enter a valid last name';
    return null;
  }

  String? _validateDob(String value) {
    if (!state.isPatient) return null;

    if (value.isEmpty) return 'Date of birth cannot be empty';

    try {
      // Parse exactly what your widget produces: DD/MM/YYYY
      final date = DateFormat('dd/MM/yyyy').parseStrict(value);

      // Age check: year >= 2008 => too young
      if (date.year >= 2008) {
        return 'You are too young to have an account';
      }

    } catch (_) {
      return 'Invalid date format (use DD/MM/YYYY)';
    }

    return null;
  }

  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) return 'Phone number cannot be empty';
    if (!RegExp(r'^0[567][0-9]{8}$').hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  String? _validateNin(String value) {
    if (value.isEmpty) return 'NIN cannot be empty';
    if (!RegExp(r'^[0-9]{18}$').hasMatch(value)) return 'Enter a valid NIN';
    return null;
  }

  // ---------------- Professional info validators ----------------
  String? _validateBio(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (value.length < 15) return 'Enter at least 15 characters';
    return null;
  }

  String? _validateSpeciality(String? value) {
    if (value == null || value.isEmpty) return 'Please select your speciality';
    return null;
  }

  String? _validateSpecialityId(int? value) {
    if (value == null || value == 0) return 'Please select your speciality';
    return null;
  }

  String? _validateWorkingPlace(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (value.length < 5) return 'Enter at least 5 characters';
    return null;
  }

  String? _validateDegree(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (value.length < 5) return 'Enter at least 5 characters';
    return null;
  }

  String? _validateUniversity(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (value.length < 5) return 'Enter at least 5 characters';
    return null;
  }

  String? _validateCertification(String? value) {
    if (value != null && value.isNotEmpty && value.length < 5) return 'Enter at least 5 characters';
    return null;
  }

  String? _validateCertificationInstitution(String? value) {
    if (value != null && value.isNotEmpty && value.length < 5) return 'Enter at least 5 characters';
    return null;
  }

  String? _validateTraining(String? value) {
    if (value != null && value.isNotEmpty && value.length < 10) return 'Enter at least 10 characters';
    return null;
  }

  String? _validateLicenceNumber(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (!RegExp(r'^\d{4,6}$').hasMatch(value)) return 'Enter a valid licence number';
    return null;
  }

  String? _validateLicenceDesc(String? value) {
    if (value != null && value.isNotEmpty && value.length < 10) return 'Enter at least 10 characters';
    return null;
  }

  String? _validateYearsOfExperience(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (!RegExp(r'^\d{1,2}$').hasMatch(value) || int.parse(value) > 60) return 'Enter a valid number of years';
    return null;
  }

  String? _validateAreasOfExperience(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (value.length < 10) return 'Enter at least 10 characters';
    return null;
  }

  String? _validateConsultationPrice(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    if (!RegExp(r'^\d{3,7}$').hasMatch(value)) return 'Enter a valid price in DA';
    return null;
  }
}
