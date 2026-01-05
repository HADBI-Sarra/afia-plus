enum SignupStep { account, personal, professional, profilePicture }

class SignupState {
  final SignupStep currentStep; // NEW: track current step

  // ---------------- Account step ----------------
  final String email;
  final String? emailError;
  final String password;
  final String? passwordError;
  final String confirmPassword;
  final String? confirmPasswordError;
  final bool firstTry;
  final bool strongPassword;
  final bool long;
  final bool hasLowercase;
  final bool hasUppercase;
  final bool hasNumber;
  final bool hasSpecial;
  final bool isPatient;

  // ---------------- Personal data step ----------------
  final String firstName;
  final String? firstNameError;
  final String lastName;
  final String? lastNameError;
  final String dob;
  final String? dobError;
  final String phoneNumber;
  final String? phoneError;
  final String nin;
  final String? ninError;
  final bool agreeBoxChecked;
  final bool redCheckBox;

  // ---------------- Professional info step ----------------
  final String bio;
  final String? bioError;
  final String speciality;
  final String? specialityError;
  final String workingPlace;
  final String? workingPlaceError;
  final String degree;
  final String? degreeError;
  final String university;
  final String? universityError;
  final String certification;
  final String? certificationError;
  final String certificationInstitution;
  final String? certificationInstitutionError;
  final String training;
  final String? trainingError;
  final String licenceNumber;
  final String? licenceNumberError;
  final String licenceDesc;
  final String? licenceDescError;
  final String yearsOfExperience;
  final String? yearsOfExperienceError;
  final String areasOfExperience;
  final String? areasOfExperienceError;
  final String consultationPrice;
  final String? consultationPriceError;
  final bool professionalAgreeBoxChecked;
  final bool professionalRedCheckBox;
  final int specialityId;
  final String specialityName;

  // ---------------- Profile Picture step ----------------
  final String? profilePicturePath;

  // ---------------- General ----------------
  final bool isLoading;
  final String message;

  SignupState({
    this.currentStep = SignupStep.account, // default to first step

    // Account
    this.email = '',
    this.emailError,
    this.password = '',
    this.passwordError,
    this.confirmPassword = '',
    this.confirmPasswordError,
    this.firstTry = true,
    this.strongPassword = false,
    this.long = true,
    this.hasLowercase = true,
    this.hasUppercase = true,
    this.hasNumber = true,
    this.hasSpecial = true,
    this.isPatient = true,

    // Personal
    this.firstName = '',
    this.firstNameError,
    this.lastName = '',
    this.lastNameError,
    this.dob = '',
    this.dobError,
    this.phoneNumber = '',
    this.phoneError,
    this.nin = '',
    this.ninError,
    this.agreeBoxChecked = false,
    this.redCheckBox = false,

    // Professional
    this.bio = '',
    this.bioError,
    this.speciality = '',
    this.specialityError,
    this.workingPlace = '',
    this.workingPlaceError,
    this.degree = '',
    this.degreeError,
    this.university = '',
    this.universityError,
    this.certification = '',
    this.certificationError,
    this.certificationInstitution = '',
    this.certificationInstitutionError,
    this.training = '',
    this.trainingError,
    this.licenceNumber = '',
    this.licenceNumberError,
    this.licenceDesc = '',
    this.licenceDescError,
    this.yearsOfExperience = '',
    this.yearsOfExperienceError,
    this.areasOfExperience = '',
    this.areasOfExperienceError,
    this.consultationPrice = '',
    this.consultationPriceError,
    this.professionalAgreeBoxChecked = false,
    this.professionalRedCheckBox = false,
    this.specialityId = 0,
    this.specialityName = '',

    // Profile Picture
    this.profilePicturePath,

    // General
    this.isLoading = false,
    this.message = '',
  });

  SignupState copyWith({
    SignupStep? currentStep,

    // Account
    String? email,
    String? emailError,
    String? password,
    String? passwordError,
    String? confirmPassword,
    String? confirmPasswordError,
    bool? firstTry,
    bool? strongPassword,
    bool? long,
    bool? hasLowercase,
    bool? hasUppercase,
    bool? hasNumber,
    bool? hasSpecial,
    bool? isPatient,

    // Personal
    String? firstName,
    String? firstNameError,
    String? lastName,
    String? lastNameError,
    String? dob,
    String? dobError,
    String? phoneNumber,
    String? phoneError,
    String? nin,
    String? ninError,
    bool? agreeBoxChecked,
    bool? redCheckBox,

    // Professional
    String? bio,
    String? bioError,
    String? speciality,
    String? specialityError,
    String? workingPlace,
    String? workingPlaceError,
    String? degree,
    String? degreeError,
    String? university,
    String? universityError,
    String? certification,
    String? certificationError,
    String? certificationInstitution,
    String? certificationInstitutionError,
    String? training,
    String? trainingError,
    String? licenceNumber,
    String? licenceNumberError,
    String? licenceDesc,
    String? licenceDescError,
    String? yearsOfExperience,
    String? yearsOfExperienceError,
    String? areasOfExperience,
    String? areasOfExperienceError,
    String? consultationPrice,
    String? consultationPriceError,
    bool? professionalAgreeBoxChecked,
    bool? professionalRedCheckBox,
    int? specialityId,
    String? specialityName,

    // Profile Picture
    String? profilePicturePath,

    // General
    bool? isLoading,
    String? message,
  }) {
    return SignupState(
      currentStep: currentStep ?? this.currentStep,

      // Account
      email: email ?? this.email,
      emailError: emailError,
      password: password ?? this.password,
      passwordError: passwordError,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      confirmPasswordError: confirmPasswordError,
      firstTry: firstTry ?? this.firstTry,
      strongPassword: strongPassword ?? this.strongPassword,
      long: long ?? this.long,
      hasLowercase: hasLowercase ?? this.hasLowercase,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasNumber: hasNumber ?? this.hasNumber,
      hasSpecial: hasSpecial ?? this.hasSpecial,
      isPatient: isPatient ?? this.isPatient,

      // Personal
      firstName: firstName ?? this.firstName,
      firstNameError: firstNameError,
      lastName: lastName ?? this.lastName,
      lastNameError: lastNameError,
      dob: dob ?? this.dob,
      dobError: dobError,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneError: phoneError,
      nin: nin ?? this.nin,
      ninError: ninError,
      agreeBoxChecked: agreeBoxChecked ?? this.agreeBoxChecked,
      redCheckBox: redCheckBox ?? this.redCheckBox,

      // Professional
      bio: bio ?? this.bio,
      bioError: bioError,
      speciality: speciality ?? this.speciality,
      specialityError: specialityError,
      workingPlace: workingPlace ?? this.workingPlace,
      workingPlaceError: workingPlaceError,
      degree: degree ?? this.degree,
      degreeError: degreeError,
      university: university ?? this.university,
      universityError: universityError,
      certification: certification ?? this.certification,
      certificationError: certificationError,
      certificationInstitution: certificationInstitution ?? this.certificationInstitution,
      certificationInstitutionError: certificationInstitutionError,
      training: training ?? this.training,
      trainingError: trainingError,
      licenceNumber: licenceNumber ?? this.licenceNumber,
      licenceNumberError: licenceNumberError,
      licenceDesc: licenceDesc ?? this.licenceDesc,
      licenceDescError: licenceDescError,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      yearsOfExperienceError: yearsOfExperienceError,
      areasOfExperience: areasOfExperience ?? this.areasOfExperience,
      areasOfExperienceError: areasOfExperienceError,
      consultationPrice: consultationPrice ?? this.consultationPrice,
      consultationPriceError: consultationPriceError,
      professionalAgreeBoxChecked: professionalAgreeBoxChecked ?? this.professionalAgreeBoxChecked,
      professionalRedCheckBox: professionalRedCheckBox ?? this.professionalRedCheckBox,
      specialityId: specialityId ?? this.specialityId,
      specialityName: specialityName ?? this.specialityName,

      // Profile Picture
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,

      // General
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}
