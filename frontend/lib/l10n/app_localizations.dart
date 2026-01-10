import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'3afiaPlus'**
  String get appName;

  /// Title for upcoming appointments section
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// Title for past appointments section
  ///
  /// In en, this message translates to:
  /// **'Past Appointments'**
  String get pastAppointments;

  /// Title for pending consultations section
  ///
  /// In en, this message translates to:
  /// **'Pending Consultations'**
  String get pendingConsultations;

  /// Title for coming consultations section
  ///
  /// In en, this message translates to:
  /// **'Coming Consultations'**
  String get comingConsultations;

  /// Title for prescriptions section
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get prescriptions;

  /// Link text to see all items
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// Accept button text
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Reject button text
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Upload PDF button text
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get uploadPdf;

  /// Indicator that PDF is uploaded
  ///
  /// In en, this message translates to:
  /// **'PDF Uploaded'**
  String get pdfUploaded;

  /// View prescription button text
  ///
  /// In en, this message translates to:
  /// **'View Prescription'**
  String get viewPrescription;

  /// WhatsApp button text
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Message when no appointments are available
  ///
  /// In en, this message translates to:
  /// **'No appointments found'**
  String get noAppointmentsFound;

  /// Message when no consultations are available
  ///
  /// In en, this message translates to:
  /// **'No consultations found'**
  String get noConsultationsFound;

  /// Message when no prescriptions are available
  ///
  /// In en, this message translates to:
  /// **'No prescriptions found'**
  String get noPrescriptionsFound;

  /// Confirmation dialog title for accepting appointment
  ///
  /// In en, this message translates to:
  /// **'Accept Appointment'**
  String get confirmAccept;

  /// Confirmation message for accepting appointment
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this appointment?'**
  String get confirmAcceptMessage;

  /// Confirmation dialog title for rejecting appointment
  ///
  /// In en, this message translates to:
  /// **'Reject Appointment'**
  String get confirmReject;

  /// Confirmation message for rejecting appointment
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this appointment? This action cannot be undone.'**
  String get confirmRejectMessage;

  /// Confirmation dialog title for deleting appointment
  ///
  /// In en, this message translates to:
  /// **'Delete Appointment'**
  String get confirmDelete;

  /// Confirmation message for deleting appointment
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this appointment? This action cannot be undone.'**
  String get confirmDeleteMessage;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Success message when appointment is accepted
  ///
  /// In en, this message translates to:
  /// **'Appointment accepted successfully'**
  String get appointmentAccepted;

  /// Success message when appointment is rejected
  ///
  /// In en, this message translates to:
  /// **'Appointment rejected successfully'**
  String get appointmentRejected;

  /// Success message when appointment is deleted
  ///
  /// In en, this message translates to:
  /// **'Appointment deleted successfully'**
  String get appointmentDeleted;

  /// Success message when PDF is uploaded
  ///
  /// In en, this message translates to:
  /// **'Prescription PDF uploaded successfully'**
  String get pdfUploadedSuccess;

  /// Error message when PDF upload fails
  ///
  /// In en, this message translates to:
  /// **'Failed to upload PDF: {error}'**
  String pdfUploadFailed(String error);

  /// Error message when PDF cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Failed to open PDF: {error}'**
  String pdfOpenFailed(String error);

  /// Error message when WhatsApp is not installed
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp. Please make sure WhatsApp is installed.'**
  String get whatsappNotInstalled;

  /// Error message when phone number is missing
  ///
  /// In en, this message translates to:
  /// **'Phone number not available'**
  String get phoneNumberNotAvailable;

  /// Error message when doctor phone number is missing
  ///
  /// In en, this message translates to:
  /// **'Doctor phone number not available'**
  String get doctorPhoneNumberNotAvailable;

  /// Error message when consultations fail to load
  ///
  /// In en, this message translates to:
  /// **'Error Loading consultations'**
  String get errorLoadingConsultations;

  /// Error message when appointments fail to load
  ///
  /// In en, this message translates to:
  /// **'Error Loading appointments'**
  String get errorLoadingAppointments;

  /// Status label for pending appointments
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// Status label for scheduled appointments
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get statusScheduled;

  /// Status label for completed appointments
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// Status label for cancelled appointments
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// Welcome message on login screen
  ///
  /// In en, this message translates to:
  /// **'Nice to have you back!'**
  String get niceToHaveYouBack;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Personal data form title
  ///
  /// In en, this message translates to:
  /// **'Personal data'**
  String get personalData;

  /// Personal data form description
  ///
  /// In en, this message translates to:
  /// **'Provide your personal data to book visits in just a few clicks.'**
  String get providePersonalData;

  /// First name label
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// First name input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterYourFirstName;

  /// Last name label
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// Last name input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterYourLastName;

  /// Date of birth label
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// Pull to refresh hint
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// Title for prescriptions page
  ///
  /// In en, this message translates to:
  /// **'My Prescriptions'**
  String get myPrescriptions;

  /// Title for appointments page
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointments;

  /// Section title for confirmed appointments
  ///
  /// In en, this message translates to:
  /// **'Confirmed Appointments'**
  String get confirmedAppointments;

  /// Section title for not confirmed appointments
  ///
  /// In en, this message translates to:
  /// **'Not Confirmed Appointments'**
  String get notConfirmedAppointments;

  /// Message when prescription is not available
  ///
  /// In en, this message translates to:
  /// **'No prescription available'**
  String get noPrescriptionAvailable;

  /// Error message when PDF file cannot be found
  ///
  /// In en, this message translates to:
  /// **'PDF file not found'**
  String get pdfFileNotFound;

  /// Cancel appointment button and dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get cancelAppointment;

  /// Button to keep/not cancel appointment
  ///
  /// In en, this message translates to:
  /// **'Keep Appointment'**
  String get keepAppointment;

  /// Success message when appointment is cancelled
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled successfully'**
  String get appointmentCancelled;

  /// Warning message that action cannot be undone
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// Confirmation message for cancelling appointment
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get areYouSureCancelAppointment;

  /// Default specialty label when specialty is not available
  ///
  /// In en, this message translates to:
  /// **'Specialist'**
  String get specialist;

  /// English language label
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language label
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// Error message when WhatsApp cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp. Please make sure WhatsApp is installed.'**
  String get whatsappError;

  /// WhatsApp message template for contacting doctor
  ///
  /// In en, this message translates to:
  /// **'Hello Dr. {doctorName}, I have a question about my appointment on {date}.'**
  String whatsappMessageDoctor(String doctorName, String date);

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Text asking if user is new, shown before create account link
  ///
  /// In en, this message translates to:
  /// **'Are you new here? '**
  String get areYouNewHere;

  /// Create account link text
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// Create account screen title
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// Welcome message on signup screen
  ///
  /// In en, this message translates to:
  /// **'Excited to have you on board!'**
  String get excitedToHaveYouOnBoard;

  /// Label for role selection on signup
  ///
  /// In en, this message translates to:
  /// **'Register as'**
  String get registerAs;

  /// Doctor role label
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// Patient role label
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// Password creation hint text
  ///
  /// In en, this message translates to:
  /// **'Create password'**
  String get createPassword;

  /// Message shown when password meets all criteria
  ///
  /// In en, this message translates to:
  /// **'Strong password'**
  String get strongPassword;

  /// Password requirement: minimum 8 characters
  ///
  /// In en, this message translates to:
  /// **'Min 8 characters length'**
  String get min8CharactersLength;

  /// Password requirement: minimum 1 lowercase letter
  ///
  /// In en, this message translates to:
  /// **'Min 1 lowercase letter'**
  String get min1LowercaseLetter;

  /// Password requirement: minimum 1 uppercase letter
  ///
  /// In en, this message translates to:
  /// **'Min 1 uppercase letter'**
  String get min1UppercaseLetter;

  /// Password requirement: minimum 1 digit
  ///
  /// In en, this message translates to:
  /// **'Min 1 digit'**
  String get min1Digit;

  /// Password requirement: minimum 1 special character
  ///
  /// In en, this message translates to:
  /// **'Min 1 special character'**
  String get min1SpecialCharacter;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Confirm password field hint
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPassword;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Text asking if user already has account, shown before login link
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// French language label
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// Date format hint for date of birth
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get dateFormatHint;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// Phone number input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. 05123 45 67 89'**
  String get phoneNumberExample;

  /// NIN field label
  ///
  /// In en, this message translates to:
  /// **'National Identification Number (NIN)'**
  String get nationalIdentificationNumber;

  /// NIN input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. 198012345678901234'**
  String get ninExample;

  /// Terms and conditions agreement checkbox text
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions'**
  String get iAgreeToTermsAndConditions;

  /// Description for doctor personal data form
  ///
  /// In en, this message translates to:
  /// **'Provide your personal data to offer online consultations quickly and securely.'**
  String get providePersonalDataDoctor;

  /// Professional info screen title
  ///
  /// In en, this message translates to:
  /// **'Professional info'**
  String get professionalInfo;

  /// Description for professional info form
  ///
  /// In en, this message translates to:
  /// **'Provide your professional details to help patients learn about your qualifications and expertise.'**
  String get provideProfessionalDetails;

  /// Main speciality section label
  ///
  /// In en, this message translates to:
  /// **'Main speciality'**
  String get mainSpeciality;

  /// Speciality dropdown label
  ///
  /// In en, this message translates to:
  /// **'Speciality'**
  String get speciality;

  /// Speciality dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select your speciality'**
  String get selectYourSpeciality;

  /// Message when no specialities are available
  ///
  /// In en, this message translates to:
  /// **'No specialities found'**
  String get noSpecialitiesFound;

  /// Error message when specialities fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load specialities'**
  String get failedToLoadSpecialities;

  /// General information section label
  ///
  /// In en, this message translates to:
  /// **'General information'**
  String get generalInformation;

  /// Bio field label
  ///
  /// In en, this message translates to:
  /// **'Bio / Specialization'**
  String get bioSpecialization;

  /// Bio field hint text
  ///
  /// In en, this message translates to:
  /// **'Describe your medical background, specialties, and philosophy of care'**
  String get describeMedicalBackground;

  /// Current working place section label
  ///
  /// In en, this message translates to:
  /// **'Current working place'**
  String get currentWorkingPlace;

  /// Working place field label
  ///
  /// In en, this message translates to:
  /// **'Name / Address'**
  String get nameAddress;

  /// Working place input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. Nour Clinic, Hydra, Algiers'**
  String get workingPlaceExample;

  /// Education section label
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// Degree field label
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get degree;

  /// Degree input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. Doctor of Medicine (MD)'**
  String get degreeExample;

  /// University field label
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get university;

  /// University input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. University of Algiers 1'**
  String get universityExample;

  /// Certification section label
  ///
  /// In en, this message translates to:
  /// **'Certification'**
  String get certification;

  /// Certification field label
  ///
  /// In en, this message translates to:
  /// **'Certification (Optional)'**
  String get certificationOptional;

  /// Certification input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. Specialist in Cardiology'**
  String get certificationExample;

  /// Certification institution field label
  ///
  /// In en, this message translates to:
  /// **'Institution (Optional)'**
  String get institutionOptional;

  /// Institution input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. University of Oran 1'**
  String get institutionExample;

  /// Training section label
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// Training field label
  ///
  /// In en, this message translates to:
  /// **'Residency / Fellowship details (Optional)'**
  String get residencyFellowshipOptional;

  /// Training input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. Residency in internal Medicine, Fellowship in Cardiology'**
  String get trainingExample;

  /// Licensure section label
  ///
  /// In en, this message translates to:
  /// **'Licensure'**
  String get licensure;

  /// License number field label
  ///
  /// In en, this message translates to:
  /// **'License number'**
  String get licenseNumber;

  /// License number input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. 12345'**
  String get licenseNumberExample;

  /// License description field label
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// License description input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. Authorized to practice medicine in Algeria'**
  String get licenseDescriptionExample;

  /// Experience section label
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// Years of experience field label
  ///
  /// In en, this message translates to:
  /// **'Years of practice'**
  String get yearsOfPractice;

  /// Years of practice input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. 16'**
  String get yearsOfPracticeExample;

  /// Areas of experience field label
  ///
  /// In en, this message translates to:
  /// **'Specific areas of expertise'**
  String get specificAreasOfExpertise;

  /// Areas of expertise input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. Cardiac imaging, hypertension, heart failure management'**
  String get areasOfExpertiseExample;

  /// Consultation fees section label
  ///
  /// In en, this message translates to:
  /// **'Consultation fees'**
  String get consultationFees;

  /// Consultation price field label
  ///
  /// In en, this message translates to:
  /// **'Price for 1-hour consultation'**
  String get priceForOneHourConsultation;

  /// Consultation price input hint example
  ///
  /// In en, this message translates to:
  /// **'e.g. 1000 DA'**
  String get consultationPriceExample;

  /// Profile picture screen title
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get profilePicture;

  /// Profile picture subtitle for patients
  ///
  /// In en, this message translates to:
  /// **'Help people recognize you with a professional headshot.'**
  String get helpPeopleRecognizeYou;

  /// Profile picture subtitle for doctors
  ///
  /// In en, this message translates to:
  /// **'Help patients recognize you with a professional headshot.'**
  String get helpPatientsRecognizeYou;

  /// Image source modal title
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// Upload from gallery option
  ///
  /// In en, this message translates to:
  /// **'Upload from Gallery'**
  String get uploadFromGallery;

  /// Take photo option
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Add profile picture button text
  ///
  /// In en, this message translates to:
  /// **'Add a profile picture'**
  String get addAProfilePicture;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Change photo button text
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// Error message when image picking fails
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(String error);

  /// Error message when profile picture upload fails
  ///
  /// In en, this message translates to:
  /// **'Error uploading profile picture: {error}'**
  String errorUploadingProfilePicture(String error);

  /// Title for camera permission dialog
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Required'**
  String get cameraPermissionRequired;

  /// Message when camera permission is denied
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get cameraPermissionDenied;

  /// Message explaining why camera permission is needed
  ///
  /// In en, this message translates to:
  /// **'This app needs access to your camera to take profile pictures. Please enable camera permission in settings.'**
  String get cameraPermissionDeniedMessage;

  /// Title for storage permission dialog
  ///
  /// In en, this message translates to:
  /// **'Storage Permission Required'**
  String get storagePermissionRequired;

  /// Message when storage permission is denied
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied'**
  String get storagePermissionDenied;

  /// Message explaining why storage permission is needed
  ///
  /// In en, this message translates to:
  /// **'This app needs access to your photo library to select profile pictures. Please enable photo library permission in settings.'**
  String get storagePermissionDeniedMessage;

  /// Button text to open app settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Shown when email field is empty
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get errorEmailEmpty;

  /// Shown when email field has invalid format
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get errorEmailInvalid;

  /// Shown when password field is empty
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get errorPasswordEmpty;

  /// Shown when password length is less than 8
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get errorPasswordShort;

  /// Shown when password doesn't pass strength requirements
  ///
  /// In en, this message translates to:
  /// **'Weak password'**
  String get errorPasswordWeak;

  /// Shown when password confirmation field is empty
  ///
  /// In en, this message translates to:
  /// **'Password confirmation cannot be empty'**
  String get errorPasswordConfirmationEmpty;

  /// Shown when password and confirmation do not match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordsDoNotMatch;

  /// Shown when an email is already registered
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get errorEmailTaken;

  /// First name field is empty
  ///
  /// In en, this message translates to:
  /// **'First name cannot be empty'**
  String get errorFirstNameEmpty;

  /// First name field is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid first name'**
  String get errorFirstNameInvalid;

  /// Last name field is empty
  ///
  /// In en, this message translates to:
  /// **'Last name cannot be empty'**
  String get errorLastNameEmpty;

  /// Last name field is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid last name'**
  String get errorLastNameInvalid;

  /// DOB field empty
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be empty'**
  String get errorDobEmpty;

  /// User under 16
  ///
  /// In en, this message translates to:
  /// **'You must be at least 16 years old to create an account'**
  String get errorDobMinor;

  /// Date is in wrong format
  ///
  /// In en, this message translates to:
  /// **'Invalid date format (use DD/MM/YYYY)'**
  String get errorDobFormat;

  /// Phone field empty
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty'**
  String get errorPhoneEmpty;

  /// Phone field invalid format/message
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number in the format +213XXXXXXXXX'**
  String get errorPhoneInvalid;

  /// NIN field empty
  ///
  /// In en, this message translates to:
  /// **'NIN cannot be empty'**
  String get errorNinEmpty;

  /// NIN validation failed
  ///
  /// In en, this message translates to:
  /// **'Enter a valid NIN'**
  String get errorNinInvalid;

  /// General empty field error
  ///
  /// In en, this message translates to:
  /// **'Field cannot be empty'**
  String get errorFieldEmpty;

  /// Require N min chars
  ///
  /// In en, this message translates to:
  /// **'Enter at least {num} characters'**
  String errorMinCharacters(int num);

  /// When speciality is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select your speciality'**
  String get errorSpecialityNotSelected;

  /// Licence number is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid licence number'**
  String get errorLicenceInvalid;

  /// Years field is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number of years'**
  String get errorYearsInvalid;

  /// Consultation price field is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price in DA'**
  String get errorPriceInvalid;

  /// General timeout error
  ///
  /// In en, this message translates to:
  /// **'Request timeout. Please check your connection and try again.'**
  String get errorTimeout;

  /// Email async check failed
  ///
  /// In en, this message translates to:
  /// **'Failed to check email. Please try again.'**
  String get errorEmailCheckFailed;

  /// General signup failure
  ///
  /// In en, this message translates to:
  /// **'Signup failed'**
  String get errorSignupFailed;

  /// General error with details
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(String error);

  /// Error message when doctor profile cannot be found
  ///
  /// In en, this message translates to:
  /// **'Doctor not found'**
  String get doctorNotFound;

  /// Greeting message for patient
  ///
  /// In en, this message translates to:
  /// **'Hello {name}!'**
  String helloPatient(String name);

  /// Greeting message for doctor
  ///
  /// In en, this message translates to:
  /// **'Hello Dr. {name}!'**
  String helloDoctor(String name);

  /// Number of doctors
  ///
  /// In en, this message translates to:
  /// **'{count} doctors'**
  String doctorsCount(int count);

  /// Title for doctors by speciality overlay
  ///
  /// In en, this message translates to:
  /// **'Doctors - {speciality}'**
  String doctorsForSpeciality(String speciality);

  /// Message when user is not authenticated
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get userNotLoggedIn;

  /// Message when doctor authentication is required
  ///
  /// In en, this message translates to:
  /// **'Please log in as a doctor to view your home screen.'**
  String get pleaseLogInAsDoctor;

  /// Message when there are no upcoming consultations
  ///
  /// In en, this message translates to:
  /// **'No upcoming consultations'**
  String get noUpcomingConsultations;

  /// Message when there are no pending consultations
  ///
  /// In en, this message translates to:
  /// **'No pending consultations'**
  String get noPendingConsultations;

  /// Title for popular specializations section
  ///
  /// In en, this message translates to:
  /// **'Popular specializations'**
  String get popularSpecializations;

  /// Header for list of all specialities overlay
  ///
  /// In en, this message translates to:
  /// **'All specialities'**
  String get allSpecialities;

  /// Title for popular doctors section
  ///
  /// In en, this message translates to:
  /// **'Popular doctors'**
  String get popularDoctors;

  /// Title for services section
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// Appointments service link
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// Availability service link
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// FAQ service link
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Pending requests label
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequests;

  /// Total patients label
  ///
  /// In en, this message translates to:
  /// **'Total patients'**
  String get totalPatients;

  /// Number of appointments
  ///
  /// In en, this message translates to:
  /// **'{count} appointments'**
  String appointmentsCount(int count);

  /// Number of requests (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} request'**
  String requestsCount(int count);

  /// Number of requests (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} requests'**
  String requestsCountPlural(int count);

  /// Number of patients
  ///
  /// In en, this message translates to:
  /// **'{count} patients'**
  String patientsCount(int count);

  /// Message when address is not available
  ///
  /// In en, this message translates to:
  /// **'Address not available'**
  String get addressNotAvailable;

  /// Error message when WhatsApp cannot be opened for doctor
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp. Please make sure WhatsApp is installed.'**
  String get whatsappErrorDoctor;

  /// Message when phone number is not available for doctor
  ///
  /// In en, this message translates to:
  /// **'Phone number not available'**
  String get phoneNumberNotAvailableDoctor;

  /// Success message when appointment is accepted
  ///
  /// In en, this message translates to:
  /// **'Appointment accepted successfully'**
  String get appointmentAcceptedSuccessfully;

  /// Success message when appointment is rejected
  ///
  /// In en, this message translates to:
  /// **'Appointment rejected successfully'**
  String get appointmentRejectedSuccessfully;

  /// Confirmation message for rejecting appointment
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this appointment?'**
  String get areYouSureRejectAppointment;

  /// Message that patient will be notified of rejection
  ///
  /// In en, this message translates to:
  /// **'The patient will be notified of the rejection.'**
  String get patientWillBeNotified;

  /// Quick overview section title
  ///
  /// In en, this message translates to:
  /// **'Quick overview'**
  String get quickOverview;

  /// Date and time format
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String atTime(String date, String time);

  /// WhatsApp message from doctor to patient
  ///
  /// In en, this message translates to:
  /// **'Hello, I would like to discuss our appointment on {dateTime}.'**
  String whatsappMessageDoctorToPatient(String dateTime);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
