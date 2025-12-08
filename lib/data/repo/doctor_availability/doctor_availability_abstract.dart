abstract class DoctorAvailabilityRepo {
  Future<List<Map<String, dynamic>>> getAvailability();
  Future<int> addAvailability(Map<String, dynamic> data);
  Future<int> updateAvailability(int id, Map<String, dynamic> data);
  Future<int> deleteAvailability(int id);
  Future<List<Map<String, dynamic>>> getAvailabilityByDoctor(int doctorId);
}
