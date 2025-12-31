class Consultation {
  final int? consultationId;
  final int patientId;
  final int doctorId;
  final int? availabilityId;
  final String consultationDate;
  final String startTime;
  final String status; // 'pending', 'scheduled', 'completed', 'cancelled'
  final String? prescription;

  Consultation({
    this.consultationId,
    required this.patientId,
    required this.doctorId,
    this.availabilityId,
    required this.consultationDate,
    required this.startTime,
    required this.status,
    this.prescription,
  });

  // Convert from Map (database row)
  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      consultationId: map['consultation_id'] as int?,
      patientId: map['patient_id'] as int,
      doctorId: map['doctor_id'] as int,
      availabilityId: map['availability_id'] as int?,
      consultationDate: map['consultation_date'] as String,
      startTime: map['start_time'] as String,
      status: map['status'] as String,
      prescription: map['prescription'] as String?,
    );
  }

  // Convert to Map (for database insertion/update)
  Map<String, dynamic> toMap() {
    return {
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

  // Copy with method for updates
  Consultation copyWith({
    int? consultationId,
    int? patientId,
    int? doctorId,
    int? availabilityId,
    String? consultationDate,
    String? startTime,
    String? status,
    String? prescription,
  }) {
    return Consultation(
      consultationId: consultationId ?? this.consultationId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      availabilityId: availabilityId ?? this.availabilityId,
      consultationDate: consultationDate ?? this.consultationDate,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
      prescription: prescription ?? this.prescription,
    );
  }

  // Helper methods
  bool get isConfirmed => status == 'scheduled' || status == 'completed';
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get hasPrescription => prescription != null && prescription!.isNotEmpty;
}

