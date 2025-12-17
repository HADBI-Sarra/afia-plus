abstract class DoctorsRepo {
  Future<List<Map<String, dynamic>>> getDoctors();
  Future<int> addDoctor(Map<String, dynamic> data);
  Future<int> updateDoctor(int id, Map<String, dynamic> data);
  Future<int> deleteDoctor(int id);
  Future<Map<String, dynamic>?> getDoctorById(int id);
}
