// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => '3afiaPlus';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get pastAppointments => 'Past Appointments';

  @override
  String get pendingConsultations => 'Pending Consultations';

  @override
  String get comingConsultations => 'Coming Consultations';

  @override
  String get prescriptions => 'Prescriptions';

  @override
  String get seeAll => 'See all';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get uploadPdf => 'Upload PDF';

  @override
  String get pdfUploaded => 'PDF Uploaded';

  @override
  String get viewPrescription => 'View Prescription';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get noAppointmentsFound => 'No appointments found';

  @override
  String get noConsultationsFound => 'No consultations found';

  @override
  String get noPrescriptionsFound => 'No prescriptions found';

  @override
  String get confirmAccept => 'Accept Appointment';

  @override
  String get confirmAcceptMessage =>
      'Are you sure you want to accept this appointment?';

  @override
  String get confirmReject => 'Reject Appointment';

  @override
  String get confirmRejectMessage =>
      'Are you sure you want to reject this appointment? This action cannot be undone.';

  @override
  String get confirmDelete => 'Delete Appointment';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this appointment? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get appointmentAccepted => 'Appointment accepted successfully';

  @override
  String get appointmentRejected => 'Appointment rejected successfully';

  @override
  String get appointmentDeleted => 'Appointment deleted successfully';

  @override
  String get pdfUploadedSuccess => 'Prescription PDF uploaded successfully';

  @override
  String pdfUploadFailed(String error) {
    return 'Failed to upload PDF: $error';
  }

  @override
  String pdfOpenFailed(String error) {
    return 'Failed to open PDF: $error';
  }

  @override
  String get whatsappNotInstalled =>
      'Could not open WhatsApp. Please make sure WhatsApp is installed.';

  @override
  String get phoneNumberNotAvailable => 'Phone number not available';

  @override
  String get doctorPhoneNumberNotAvailable =>
      'Doctor phone number not available';

  @override
  String get errorLoadingConsultations => 'Error Loading consultations';

  @override
  String get errorLoadingAppointments => 'Error Loading appointments';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusScheduled => 'Scheduled';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get logIn => 'Log in';

  @override
  String get niceToHaveYouBack => 'Nice to have you back!';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get personalData => 'Personal data';

  @override
  String get providePersonalData =>
      'Provide your personal data to book visits in just a few clicks.';

  @override
  String get firstName => 'First name';

  @override
  String get enterYourFirstName => 'Enter your first name';

  @override
  String get lastName => 'Last name';

  @override
  String get enterYourLastName => 'Enter your last name';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get myPrescriptions => 'My Prescriptions';

  @override
  String get myAppointments => 'My Appointments';

  @override
  String get confirmedAppointments => 'Confirmed Appointments';

  @override
  String get notConfirmedAppointments => 'Not Confirmed Appointments';

  @override
  String get noPrescriptionAvailable => 'No prescription available';

  @override
  String get pdfFileNotFound => 'PDF file not found';

  @override
  String get cancelAppointment => 'Cancel Appointment';

  @override
  String get keepAppointment => 'Keep Appointment';

  @override
  String get appointmentCancelled => 'Appointment cancelled successfully';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get areYouSureCancelAppointment =>
      'Are you sure you want to cancel this appointment?';

  @override
  String get specialist => 'Specialist';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get whatsappError =>
      'Could not open WhatsApp. Please make sure WhatsApp is installed.';

  @override
  String whatsappMessageDoctor(String doctorName, String date) {
    return 'Hello Dr. $doctorName, I have a question about my appointment on $date.';
  }

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get areYouNewHere => 'Are you new here? ';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get excitedToHaveYouOnBoard => 'Excited to have you on board!';

  @override
  String get registerAs => 'Register as';

  @override
  String get doctor => 'Doctor';

  @override
  String get patient => 'Patient';

  @override
  String get createPassword => 'Create password';

  @override
  String get strongPassword => 'Strong password';

  @override
  String get min8CharactersLength => 'Min 8 characters length';

  @override
  String get min1LowercaseLetter => 'Min 1 lowercase letter';

  @override
  String get min1UppercaseLetter => 'Min 1 uppercase letter';

  @override
  String get min1Digit => 'Min 1 digit';

  @override
  String get min1SpecialCharacter => 'Min 1 special character';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get repeatPassword => 'Repeat password';

  @override
  String get next => 'Next';

  @override
  String get alreadyHaveAnAccount => 'Already have an account? ';

  @override
  String get french => 'French';

  @override
  String get dateFormatHint => 'DD/MM/YYYY';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneNumberExample => 'e.g. 05123 45 67 89';

  @override
  String get nationalIdentificationNumber =>
      'National Identification Number (NIN)';

  @override
  String get ninExample => 'e.g. 198012345678901234';

  @override
  String get iAgreeToTermsAndConditions =>
      'I agree to the Terms and Conditions';

  @override
  String get providePersonalDataDoctor =>
      'Provide your personal data to offer online consultations quickly and securely.';

  @override
  String get professionalInfo => 'Professional info';

  @override
  String get provideProfessionalDetails =>
      'Provide your professional details to help patients learn about your qualifications and expertise.';

  @override
  String get mainSpeciality => 'Main speciality';

  @override
  String get speciality => 'Speciality';

  @override
  String get selectYourSpeciality => 'Select your speciality';

  @override
  String get noSpecialitiesFound => 'No specialities found';

  @override
  String get failedToLoadSpecialities => 'Failed to load specialities';

  @override
  String get generalInformation => 'General information';

  @override
  String get bioSpecialization => 'Bio / Specialization';

  @override
  String get describeMedicalBackground =>
      'Describe your medical background, specialties, and philosophy of care';

  @override
  String get currentWorkingPlace => 'Current working place';

  @override
  String get nameAddress => 'Name / Address';

  @override
  String get workingPlaceExample => 'e.g. Nour Clinic, Hydra, Algiers';

  @override
  String get education => 'Education';

  @override
  String get degree => 'Degree';

  @override
  String get degreeExample => 'e.g. Doctor of Medicine (MD)';

  @override
  String get university => 'University';

  @override
  String get universityExample => 'e.g. University of Algiers 1';

  @override
  String get certification => 'Certification';

  @override
  String get certificationOptional => 'Certification (Optional)';

  @override
  String get certificationExample => 'e.g. Specialist in Cardiology';

  @override
  String get institutionOptional => 'Institution (Optional)';

  @override
  String get institutionExample => 'e.g. University of Oran 1';

  @override
  String get training => 'Training';

  @override
  String get residencyFellowshipOptional =>
      'Residency / Fellowship details (Optional)';

  @override
  String get trainingExample =>
      'e.g. Residency in internal Medicine, Fellowship in Cardiology';

  @override
  String get licensure => 'Licensure';

  @override
  String get licenseNumber => 'License number';

  @override
  String get licenseNumberExample => 'e.g. 12345';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get licenseDescriptionExample =>
      'e.g. Authorized to practice medicine in Algeria';

  @override
  String get experience => 'Experience';

  @override
  String get yearsOfPractice => 'Years of practice';

  @override
  String get yearsOfPracticeExample => 'e.g. 16';

  @override
  String get specificAreasOfExpertise => 'Specific areas of expertise';

  @override
  String get areasOfExpertiseExample =>
      'e.g. Cardiac imaging, hypertension, heart failure management';

  @override
  String get consultationFees => 'Consultation fees';

  @override
  String get priceForOneHourConsultation => 'Price for 1-hour consultation';

  @override
  String get consultationPriceExample => 'e.g. 1000 DA';

  @override
  String get profilePicture => 'Profile picture';

  @override
  String get helpPeopleRecognizeYou =>
      'Help people recognize you with a professional headshot.';

  @override
  String get helpPatientsRecognizeYou =>
      'Help patients recognize you with a professional headshot.';

  @override
  String get moreOptions => 'More options';

  @override
  String get uploadFromGallery => 'Upload from Gallery';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get skip => 'Skip';

  @override
  String get addAProfilePicture => 'Add a profile picture';

  @override
  String get continueButton => 'Continue';

  @override
  String get changePhoto => 'Change photo';

  @override
  String errorPickingImage(String error) {
    return 'Error picking image: $error';
  }

  @override
  String errorUploadingProfilePicture(String error) {
    return 'Error uploading profile picture: $error';
  }

  @override
  String get errorEmailEmpty => 'Email cannot be empty';

  @override
  String get errorEmailInvalid => 'Enter a valid email';

  @override
  String get errorPasswordEmpty => 'Password cannot be empty';

  @override
  String get errorPasswordShort => 'Password must be at least 8 characters';

  @override
  String get errorPasswordWeak => 'Weak password';

  @override
  String get errorPasswordConfirmationEmpty =>
      'Password confirmation cannot be empty';

  @override
  String get errorPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get errorEmailTaken => 'Email already in use';

  @override
  String get errorFirstNameEmpty => 'First name cannot be empty';

  @override
  String get errorFirstNameInvalid => 'Enter a valid first name';

  @override
  String get errorLastNameEmpty => 'Last name cannot be empty';

  @override
  String get errorLastNameInvalid => 'Enter a valid last name';

  @override
  String get errorDobEmpty => 'Date of birth cannot be empty';

  @override
  String get errorDobMinor =>
      'You must be at least 16 years old to create an account';

  @override
  String get errorDobFormat => 'Invalid date format (use DD/MM/YYYY)';

  @override
  String get errorPhoneEmpty => 'Phone number cannot be empty';

  @override
  String get errorPhoneInvalid =>
      'Enter a valid phone number in the format +213XXXXXXXXX';

  @override
  String get errorNinEmpty => 'NIN cannot be empty';

  @override
  String get errorNinInvalid => 'Enter a valid NIN';

  @override
  String get errorFieldEmpty => 'Field cannot be empty';

  @override
  String errorMinCharacters(int num) {
    return 'Enter at least $num characters';
  }

  @override
  String get errorSpecialityNotSelected => 'Please select your speciality';

  @override
  String get errorLicenceInvalid => 'Enter a valid licence number';

  @override
  String get errorYearsInvalid => 'Enter a valid number of years';

  @override
  String get errorPriceInvalid => 'Enter a valid price in DA';

  @override
  String get errorTimeout =>
      'Request timeout. Please check your connection and try again.';

  @override
  String get errorEmailCheckFailed =>
      'Failed to check email. Please try again.';

  @override
  String get errorSignupFailed => 'Signup failed';

  @override
  String errorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get doctorNotFound => 'Doctor not found';

  @override
  String helloPatient(String name) {
    return 'Hello $name!';
  }

  @override
  String helloDoctor(String name) {
    return 'Hello Dr. $name!';
  }

  @override
  String doctorsCount(int count) {
    return '$count doctors';
  }

  @override
  String doctorsForSpeciality(String speciality) {
    return 'Doctors - $speciality';
  }

  @override
  String get userNotLoggedIn => 'User not logged in';

  @override
  String get pleaseLogInAsDoctor =>
      'Please log in as a doctor to view your home screen.';

  @override
  String get noUpcomingConsultations => 'No upcoming consultations';

  @override
  String get noPendingConsultations => 'No pending consultations';

  @override
  String get popularSpecializations => 'Popular specializations';

  @override
  String get allSpecialities => 'All specialities';

  @override
  String get popularDoctors => 'Popular doctors';

  @override
  String get services => 'Services';

  @override
  String get appointments => 'Appointments';

  @override
  String get availability => 'Availability';

  @override
  String get faq => 'FAQ';

  @override
  String get today => 'Today';

  @override
  String get pendingRequests => 'Pending Requests';

  @override
  String get totalPatients => 'Total patients';

  @override
  String appointmentsCount(int count) {
    return '$count appointments';
  }

  @override
  String requestsCount(int count) {
    return '$count request';
  }

  @override
  String requestsCountPlural(int count) {
    return '$count requests';
  }

  @override
  String patientsCount(int count) {
    return '$count patients';
  }

  @override
  String get addressNotAvailable => 'Address not available';

  @override
  String get whatsappErrorDoctor =>
      'Could not open WhatsApp. Please make sure WhatsApp is installed.';

  @override
  String get phoneNumberNotAvailableDoctor => 'Phone number not available';

  @override
  String get appointmentAcceptedSuccessfully =>
      'Appointment accepted successfully';

  @override
  String get appointmentRejectedSuccessfully =>
      'Appointment rejected successfully';

  @override
  String get areYouSureRejectAppointment =>
      'Are you sure you want to reject this appointment?';

  @override
  String get patientWillBeNotified =>
      'The patient will be notified of the rejection.';

  @override
  String get quickOverview => 'Quick overview';

  @override
  String atTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String whatsappMessageDoctorToPatient(String dateTime) {
    return 'Hello, I would like to discuss our appointment on $dateTime.';
  }
}
