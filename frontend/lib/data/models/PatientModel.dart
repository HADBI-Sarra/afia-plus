class PatientModel {
  final int patientId;
  final String dateOfBirth;

  PatientModel({
    required this.patientId,
    required this.dateOfBirth,
  });

  factory PatientModel.fromMap(Map<String, dynamic> map) => PatientModel(
        patientId: map['patient_id'],
        dateOfBirth: map['date_of_birth'],
      );

  Map<String, dynamic> toMap() => {
        'patient_id': patientId,
        'date_of_birth': dateOfBirth,
      };
}
