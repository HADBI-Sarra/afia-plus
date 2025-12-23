// signup_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_state.dart';
import '../../../data/repo/auth/auth_repository.dart';
import '../../../data/models/user.dart';
import '../../../data/models/patient.dart';
import '../../../data/models/doctor.dart';
import 'package:intl/intl.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;

  SignupCubit({required this.authRepository}) : super(SignupState());

  // ---------------- Reset ----------------
  /// Resets the signup state to initial values
  void reset() {
    emit(SignupState());
  }

  /// Sets the current step in the signup flow
  void setCurrentStep(SignupStep step) {
    emit(state.copyWith(currentStep: step));
  }

  /// Clears the message in the state
  void clearMessage() {
    emit(state.copyWith(message: ''));
  }

  // ---------------- Account step ----------------
  void setEmail(String value) {
    final trimmed = value.trim();
    // Only update value here; validation happens in validateAccountStep.
    // Preserve all existing errors so they stay until next validation.
    emit(state.copyWith(
      email: trimmed,
      emailError: state.emailError,
      passwordError: state.passwordError,
      confirmPasswordError: state.confirmPasswordError,
    ));
  }

  void setPassword(String value) {
    final flags = _passwordFlags(value);
    final strong = flags.values.every((v) => v);

    // Live-update passwordError after the first submit attempt:
    // - Before first try: no inline "Weak password" yet.
    // - After first try: keep showing "Weak password" until the password becomes strong.
    String? passwordError = state.passwordError;
    if (!state.firstTry) {
      if (value.isEmpty) {
        passwordError = 'Password cannot be empty';
      } else if (!strong) {
        passwordError = 'Weak password';
      } else {
        passwordError = null;
      }
    }

    emit(state.copyWith(
      password: value,
      long: flags['long'],
      hasLowercase: flags['lower'],
      hasUppercase: flags['upper'],
      hasNumber: flags['number'],
      hasSpecial: flags['special'],
      strongPassword: strong,
      // firstTry is controlled by validateAccountStep; do not flip it here
      firstTry: state.firstTry,
      emailError: state.emailError,
      passwordError: passwordError,
      confirmPasswordError: state.confirmPasswordError,
    ));

    if (state.confirmPassword.isNotEmpty) setConfirmPassword(state.confirmPassword);
  }

  void setConfirmPassword(String value) =>
      // Only store the value; confirmPasswordError is set during validateAccountStep.
      // Preserve all existing errors so they stay until next validation.
      emit(state.copyWith(
        confirmPassword: value,
        emailError: state.emailError,
        passwordError: state.passwordError,
        confirmPasswordError: state.confirmPasswordError,
      ));

  void setRole(bool patient) => emit(state.copyWith(isPatient: patient));

  // ---------------- Personal data step ----------------
  void setFirstName(String value) =>
      emit(state.copyWith(
        firstName: value.trim(),
        firstNameError: state.firstNameError,
        lastNameError: state.lastNameError,
        dobError: state.dobError,
        phoneError: state.phoneError,
        ninError: state.ninError,
      ));

  void setLastName(String value) =>
      emit(state.copyWith(
        lastName: value.trim(),
        firstNameError: state.firstNameError,
        lastNameError: state.lastNameError,
        dobError: state.dobError,
        phoneError: state.phoneError,
        ninError: state.ninError,
      ));

  void setDob(String value) =>
      emit(state.copyWith(
        dob: value,
        firstNameError: state.firstNameError,
        lastNameError: state.lastNameError,
        dobError: state.dobError,
        phoneError: state.phoneError,
        ninError: state.ninError,
      ));

  void setPhoneNumber(String value) =>
      emit(state.copyWith(
        phoneNumber: value.trim(),
        firstNameError: state.firstNameError,
        lastNameError: state.lastNameError,
        dobError: state.dobError,
        phoneError: state.phoneError,
        ninError: state.ninError,
      ));

  void setNin(String value) =>
      emit(state.copyWith(
        nin: value.trim(),
        firstNameError: state.firstNameError,
        lastNameError: state.lastNameError,
        dobError: state.dobError,
        phoneError: state.phoneError,
        ninError: state.ninError,
      ));

  void toggleAgreeBox() => emit(state.copyWith(
      agreeBoxChecked: !state.agreeBoxChecked,
      redCheckBox: state.agreeBoxChecked ? false : state.redCheckBox));

  // ---------------- Professional info step ----------------
  void setBio(String value) =>
      emit(state.copyWith(
        bio: value.trim(),
        bioError: state.bioError,
      ));

  void setSpeciality(String? value) =>
      emit(state.copyWith(
        speciality: (value ?? '').trim(),
        specialityError: state.specialityError,
      ));

  void setWorkingPlace(String value) =>
      emit(state.copyWith(
        workingPlace: value.trim(),
        workingPlaceError: state.workingPlaceError,
      ));

  void setDegree(String value) =>
      emit(state.copyWith(
        degree: value.trim(),
        degreeError: state.degreeError,
      ));

  void setUniversity(String value) =>
      emit(state.copyWith(
        university: value.trim(),
        universityError: state.universityError,
      ));

  void setCertification(String value) =>
      emit(state.copyWith(
        certification: value.trim(),
        certificationError: state.certificationError,
      ));

  void setCertificationInstitution(String value) =>
      emit(state.copyWith(
        certificationInstitution: value.trim(),
        certificationInstitutionError: state.certificationInstitutionError,
      ));

  void setTraining(String value) =>
      emit(state.copyWith(
        training: value.trim(),
        trainingError: state.trainingError,
      ));

  void setLicenceNumber(String value) =>
      emit(state.copyWith(
        licenceNumber: value.trim(),
        licenceNumberError: state.licenceNumberError,
      ));

  void setLicenceDesc(String value) =>
      emit(state.copyWith(
        licenceDesc: value.trim(),
        licenceDescError: state.licenceDescError,
      ));

  void setYearsOfExperience(String value) =>
      emit(state.copyWith(
        yearsOfExperience: value.trim(),
        yearsOfExperienceError: state.yearsOfExperienceError,
      ));

  void setAreasOfExperience(String value) =>
      emit(state.copyWith(
        areasOfExperience: value.trim(),
        areasOfExperienceError: state.areasOfExperienceError,
      ));

  void setConsultationPrice(String value) =>
      emit(state.copyWith(
        consultationPrice: value.trim(),
        consultationPriceError: state.consultationPriceError,
      ));

  void toggleProfessionalAgreeBox() => emit(state.copyWith(
      professionalAgreeBoxChecked: !state.professionalAgreeBoxChecked,
      professionalRedCheckBox: state.professionalAgreeBoxChecked ? false : state.professionalRedCheckBox));

  void setSpecialityId(int id) {
    emit(state.copyWith(specialityId: id));
  }

  void setSpecialityName(String name) {
    final trimmed = name.trim();
    emit(state.copyWith(
      specialityName: trimmed,
      specialityError: _validateSpeciality(trimmed),
    ));
  }

  // ---------------- Submission ----------------
  /// Validates **account info only** for Step 1 (synchronous validation)
  bool validateAccountStep() {
    final emailError = _validateEmail(state.email);
    // Recompute password strength flags on submit
    final passwordFlags = _passwordFlags(state.password);
    final isStrongPassword = passwordFlags.values.every((v) => v);
    final passwordError = _validatePassword(state.password, isStrongPassword);
    final confirmError = _validateConfirmPassword(state.confirmPassword);

    // Decide when to show / hide the detailed password criteria:
    // - Once the user has attempted any non-empty password, show criteria (firstTry = false).
    // - When the password is strong and the user presses Next, hide criteria again (firstTry = true).
    final hasTypedPassword = state.password.isNotEmpty;
    final shouldResetCriteria = hasTypedPassword && isStrongPassword;

    emit(state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmError,
      long: passwordFlags['long'],
      hasLowercase: passwordFlags['lower'],
      hasUppercase: passwordFlags['upper'],
      hasNumber: passwordFlags['number'],
      hasSpecial: passwordFlags['special'],
      strongPassword: isStrongPassword,
      // If strong on submit: hide criteria. Otherwise, once the user typed something, show criteria.
      firstTry: shouldResetCriteria
          ? true
          : (hasTypedPassword ? false : state.firstTry),
    ));

    return emailError == null && passwordError == null && confirmError == null;
  }

  /// Async check for email existence; call this after validateAccountStep succeeds
  Future<bool> checkEmailExists() async {
    try {
      final exists = await authRepository.emailExists(state.email);
      if (exists) {
        emit(state.copyWith(
          emailError: 'Email already in use',
          message: 'Email already in use',
        ));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Validates **personal info only** for Step 2 - Patient flow
  bool validatePersonalPatientStep() {
    final firstError = _validateFirstName(state.firstName);
    final lastError = _validateLastName(state.lastName);
    final dobError = _validateDob(state.dob);
    final phoneError = _validatePhoneNumber(state.phoneNumber);
    final ninError = _validateNin(state.nin);
    final checkboxError = !state.agreeBoxChecked;

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
        dobError == null &&
        !checkboxError;
  }

  /// Validates **personal info only** for Step 2 - Doctor flow
  bool validatePersonalDoctorStep() {
    final firstError = _validateFirstName(state.firstName);
    final lastError = _validateLastName(state.lastName);
    final phoneError = _validatePhoneNumber(state.phoneNumber);
    final ninError = _validateNin(state.nin);

    emit(state.copyWith(
      firstNameError: firstError,
      lastNameError: lastError,
      phoneError: phoneError,
      ninError: ninError,
    ));

    return firstError == null &&
        lastError == null &&
        phoneError == null &&
        ninError == null;
  }

  /// Validates **professional info only** for Step 3
  bool validateProfessionalStep() {
    final bioError = _validateBio(state.bio);
    final specialityError = _validateSpecialityId(state.specialityId);
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

      // Check if email already exists (async check)
      final emailExists = await checkEmailExists();
      if (emailExists) {
        return;
      }

      // Move to personal step
      emit(state.copyWith(
        message: '',
        currentStep: SignupStep.personal,
      ));
      return;
    }

    if (state.currentStep == SignupStep.personal) {
      // Choose the appropriate personal-step validator based on role
      final isValid = state.isPatient
          ? validatePersonalPatientStep()
          : validatePersonalDoctorStep();
      if (!isValid) return;

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
    // Validate personal data for patient flow
    if (!validatePersonalPatientStep()) return;

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
        specialityId: state.specialityId,
        bio: state.bio,
        locationOfWork: state.workingPlace,
        degree: state.degree,
        university: state.university,
        certification: state.certification,
        institution: state.certificationInstitution,
        residency: state.training,
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
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Email cannot be empty';
    if (!RegExp(r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$").hasMatch(trimmed)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String value, bool strongPassword) {
    if (strongPassword) return null;
    if (value.isEmpty) return 'Password cannot be empty';
    return 'Weak password';
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
