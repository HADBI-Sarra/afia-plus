/// Application-wide constants
class AppConstants {
  // User IDs (TODO: Replace with actual authentication)
  static const int defaultPatientId = 1;
  static const int defaultDoctorId = 2;

  // Consultation Status
  static const String statusPending = 'pending';
  static const String statusScheduled = 'scheduled';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // Availability Status
  static const String availabilityFree = 'free';
  static const String availabilityBooked = 'booked';

  // User Roles
  static const String roleDoctor = 'doctor';
  static const String rolePatient = 'patient';

  // Date Formats
  static const String dateFormatDisplay = 'dd MMM, HH:mm';
  static const String dateFormatDatabase = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';

  // File Limits
  static const int maxPdfSizeMB = 10;
  static const int maxPdfSizeBytes = 10 * 1024 * 1024; // 10MB

  // Asset Paths
  static const String defaultDoctorImage = 'assets/images/doctorBrahimi.png';
  static const String defaultPatientImage = 'assets/images/besmala.jpg';
  static const String prescriptionPdfsPath = 'assets/prescription pdfs/';

  // UI Constants
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 20.0;
  static const Duration snackBarDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Pagination
  static const int itemsPerPage = 20;
  static const int homeScreenItemLimit = 2;
}

