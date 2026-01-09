import 'consultation.dart';

/// Extended consultation model with related data (doctor/patient names, etc.)
class ConsultationWithDetails {
  final Consultation consultation;
  final String? doctorFirstName;
  final String? doctorLastName;
  final String? doctorSpecialty;
  final String? patientFirstName;
  final String? patientLastName;
  final String? doctorImagePath;
  final String? patientImagePath;
  final String? doctorPhoneNumber;
  final String? patientPhoneNumber;

  ConsultationWithDetails({
    required this.consultation,
    this.doctorFirstName,
    this.doctorLastName,
    this.doctorSpecialty,
    this.patientFirstName,
    this.patientLastName,
    this.doctorImagePath,
    this.patientImagePath,
    this.doctorPhoneNumber,
    this.patientPhoneNumber,
  });

  String get doctorFullName {
    if (doctorFirstName != null && doctorLastName != null) {
      return '$doctorFirstName $doctorLastName';
    }
    return 'Dr. Unknown';
  }

  String get patientFullName {
    if (patientFirstName != null && patientLastName != null) {
      return '$patientFirstName $patientLastName';
    }
    return 'Patient';
  }

  String get formattedDate {
    // Format: "12 Nov, 12:00"
    try {
      final dateParts = consultation.consultationDate.split('-');
      if (dateParts.length == 3) {
        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);

        final monthNames = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];

        return '$day ${monthNames[month - 1]}, ${consultation.startTime}';
      }
    } catch (e) {
      // Fallback to original format
    }
    return '${consultation.consultationDate}, ${consultation.startTime}';
  }
}
