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
  String get downloadingPdf => 'Downloading prescription...';

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
  String get french => 'French';

  @override
  String get whatsappError =>
      'Could not open WhatsApp. Please make sure WhatsApp is installed.';

  @override
  String whatsappMessageDoctor(String doctorName, String date) {
    return 'Hello Dr. $doctorName, I have a question about my appointment on $date.';
  }

  @override
  String get doctorProfile => 'Doctor Profile';

  @override
  String get book => 'Book';

  @override
  String get about => 'About';

  @override
  String get reviews => 'Reviews';

  @override
  String get bookAppointment => 'Book appointment';

  @override
  String get doctorNotFound => 'Doctor not found';

  @override
  String get bookingSuccessMessage =>
      'Booking was successful and must be confirmed by the doctor.';

  @override
  String get pleaseSelectTime => 'Please select a time for your consultation.';

  @override
  String get cannotBookPastDate =>
      'You cannot book appointments for past dates. Please select a current or future date.';

  @override
  String get cannotBookPastTime =>
      'You cannot book appointments for past times. Please select a future time slot.';

  @override
  String get noAvailableSlot =>
      'No available slot found for the selected date/time.';

  @override
  String get mustBeLoggedInAsPatient => 'You must be logged in as a patient.';

  @override
  String get profile => 'Profile';

  @override
  String get bookedAppointments => 'Booked appointments';

  @override
  String get myPatients => 'My patients';

  @override
  String get availability => 'Availability';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get policies => 'Policies';

  @override
  String get changeEmail => 'Change email';

  @override
  String get securitySettings => 'Security settings';

  @override
  String get aboutMe => 'About me';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get specialtyNotSet => 'Specialty not set';

  @override
  String get loadingSpecialty => 'Loading specialty...';

  @override
  String get favoriteDoctors => 'Favorite doctors';

  @override
  String get dobNotSet => 'DOB not set';

  @override
  String get patientProfile => 'Patient Profile';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get healthInfo => 'Health Info';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get generalInformation => 'General Information';

  @override
  String get currentWorkingPlace => 'Current Working Place';

  @override
  String get education => 'Education';

  @override
  String get certification => 'Certification';

  @override
  String get training => 'Training';

  @override
  String get licensure => 'Licensure';

  @override
  String get experience => 'Experience';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get licenseNumber => 'License number:';

  @override
  String get over => 'Over';

  @override
  String get year => 'year';

  @override
  String get years => 'years';

  @override
  String get ofExperience => 'of experience';

  @override
  String get specializingIn => 'specializing in';

  @override
  String get price => 'Price';

  @override
  String get oneHourConsultation => '1 hour consultation';

  @override
  String get selectTime => 'Select time';

  @override
  String get noAvailableTimesForDay => 'No available times for this day';

  @override
  String get noUpcomingAvailability =>
      'No upcoming availability. This doctor has no available time slots for booking.';

  @override
  String get noAvailability => 'No availability';

  @override
  String get review => 'review';

  @override
  String get reviewsPlural => 'reviews';

  @override
  String get leaveReview => 'Leave a review';

  @override
  String get noReviewsYet => 'No reviews yet. Be the first to review!';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get selectAvailableHours => 'Select available hours';

  @override
  String get addTimes => 'Add times';

  @override
  String get deleteSlot => 'Delete slot?';

  @override
  String get deleteSlotMessage =>
      'Are you sure you want to delete this time slot?';

  @override
  String availableSlotsFor(String date) {
    return 'Available slots for $date';
  }

  @override
  String get noTimesForDay => 'No times for this day. Add some with + .';

  @override
  String get cannotSetPastAvailability =>
      'You cannot set availability in the past.';

  @override
  String get selectFutureDateAvailability =>
      'Select today or a future date to add availability.';
}
