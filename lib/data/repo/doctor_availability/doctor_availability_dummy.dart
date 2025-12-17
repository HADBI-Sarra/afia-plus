import 'doctor_availability_abstract.dart';

class DoctorAvailabilityDummy implements DoctorAvailabilityRepo {
  List<Map<String, dynamic>> availability = [
    {
      'availability_id': 1,
      'doctor_id': 1,
      'available_date': '2025-01-10',
      'start_time': '09:00',
      'status': 'free'
    },
    {
      'availability_id': 2,
      'doctor_id': 1,
      'available_date': '2025-01-10',
      'start_time': '10:00',
      'status': 'booked'
    },
    {
      'availability_id': 3,
      'doctor_id': 2,
      'available_date': '2025-01-12',
      'start_time': '14:00',
      'status': 'free'
    }
  ];

  @override
  Future<List<Map<String, dynamic>>> getAvailability() async {
    return availability;
  }

  @override
  Future<int> addAvailability(Map<String, dynamic> data) async {
    data['availability_id'] = availability.length + 1;
    availability.add(data);
    return 1;
  }

  @override
  Future<int> updateAvailability(int id, Map<String, dynamic> data) async {
    final index = availability.indexWhere((e) => e['availability_id'] == id);
    if (index != -1) {
      availability[index] = {...availability[index], ...data};
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteAvailability(int id) async {
    availability.removeWhere((e) => e['availability_id'] == id);
    return 1;
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailabilityByDoctor(int doctorId) async {
    return availability.where((e) => e['doctor_id'] == doctorId).toList();
  }
}
