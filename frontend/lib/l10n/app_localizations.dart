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

  /// Message shown while downloading PDF from cloud
  ///
  /// In en, this message translates to:
  /// **'Downloading prescription...'**
  String get downloadingPdf;

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

  /// Button to keep/cancel deletion of appointment
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
