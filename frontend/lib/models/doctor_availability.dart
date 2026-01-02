/// Doctor Availability Model
/// Represents an availability slot for a doctor on Supabase
class DoctorAvailability {
  final int? availabilityId;
  final int doctorId;
  final String availableDate; // YYYY-MM-DD format
  final String startTime; // HH:MM format
  final String status; // 'free' or 'booked'

  DoctorAvailability({
    this.availabilityId,
    required this.doctorId,
    required this.availableDate,
    required this.startTime,
    required this.status,
  });

  /// Create from JSON (Supabase response)
  factory DoctorAvailability.fromJson(Map<String, dynamic> json) {
    return DoctorAvailability(
      availabilityId: json['availability_id'] as int?,
      doctorId: json['doctor_id'] as int,
      availableDate: json['available_date'] as String,
      startTime: json['start_time'] as String,
      status: json['status'] as String? ?? 'free',
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      if (availabilityId != null) 'availability_id': availabilityId,
      'doctor_id': doctorId,
      'available_date': availableDate,
      'start_time': startTime,
      'status': status,
    };
  }

  /// Create a copy with some fields replaced
  DoctorAvailability copyWith({
    int? availabilityId,
    int? doctorId,
    String? availableDate,
    String? startTime,
    String? status,
  }) {
    return DoctorAvailability(
      availabilityId: availabilityId ?? this.availabilityId,
      doctorId: doctorId ?? this.doctorId,
      availableDate: availableDate ?? this.availableDate,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'DoctorAvailability(id: $availabilityId, doctorId: $doctorId, date: $availableDate, time: $startTime, status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorAvailability &&
          runtimeType == other.runtimeType &&
          availabilityId == other.availabilityId &&
          doctorId == other.doctorId &&
          availableDate == other.availableDate &&
          startTime == other.startTime &&
          status == other.status;

  @override
  int get hashCode =>
      availabilityId.hashCode ^
      doctorId.hashCode ^
      availableDate.hashCode ^
      startTime.hashCode ^
      status.hashCode;
}
