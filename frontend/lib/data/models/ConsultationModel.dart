class ConsultationModel {
  final int? consultationId;
  final int patientId;
  final int doctorId;
  final int availabilityId;
  final String consultationDate;
  final String startTime;
  final String status;
  final String prescription;

  ConsultationModel({
    this.consultationId,
    required this.patientId,
    required this.doctorId,
    required this.availabilityId,
    required this.consultationDate,
    required this.startTime,
    required this.status,
    required this.prescription,
  });

  factory ConsultationModel.fromMap(Map<String, dynamic> map) =>
      ConsultationModel(
        consultationId: map['consultation_id'],
        patientId: map['patient_id'],
        doctorId: map['doctor_id'],
        availabilityId: map['availability_id'],
        consultationDate: map['consultation_date'],
        startTime: map['start_time'],
        status: map['status'],
        prescription: map['prescription'],
      );

  Map<String, dynamic> toMap() => {
        'consultation_id': consultationId,
        'patient_id': patientId,
        'doctor_id': doctorId,
        'availability_id': availabilityId,
        'consultation_date': consultationDate,
        'start_time': startTime,
        'status': status,
        'prescription': prescription,
      };
}
