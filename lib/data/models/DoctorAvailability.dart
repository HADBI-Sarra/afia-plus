class DoctorAvailabilityModel {
  final int? availabilityId;
  final int doctorId;
  final String availableDate;
  final String startTime;
  final String status;

  DoctorAvailabilityModel({
    this.availabilityId,
    required this.doctorId,
    required this.availableDate,
    required this.startTime,
    required this.status,
  });

  factory DoctorAvailabilityModel.fromMap(Map<String, dynamic> map) =>
      DoctorAvailabilityModel(
        availabilityId: map['availability_id'],
        doctorId: map['doctor_id'],
        availableDate: map['available_date'],
        startTime: map['start_time'],
        status: map['status'],
      );

  Map<String, dynamic> toMap() => {
        'availability_id': availabilityId,
        'doctor_id': doctorId,
        'available_date': availableDate,
        'start_time': startTime,
        'status': status,
      };
}

class AvailabilityModel {
  final DateTime date;
  final List<String> times;

  AvailabilityModel({required this.date, required this.times});

  /// Converts a list of DoctorAvailabilityModel into grouped AvailabilityModel
  static List<AvailabilityModel> fromDoctorAvailability(
      List<DoctorAvailabilityModel> slots) {
    final Map<String, List<String>> grouped = {};

    for (var slot in slots) {
      if (slot.status.toLowerCase() == 'available') {
        grouped.putIfAbsent(slot.availableDate, () => []);
        grouped[slot.availableDate]!.add(slot.startTime);
      }
    }

    return grouped.entries
        .map((e) => AvailabilityModel(
            date: DateTime.parse(e.key), times: e.value))
        .toList();
  }
}

