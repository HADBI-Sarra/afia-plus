abstract class PatientsRepo {
  Future<List<Map<String, dynamic>>> getPatients();
  Future<int> addPatient(Map<String, dynamic> data);
  Future<int> updatePatient(int id, Map<String, dynamic> data);
  Future<int> deletePatient(int id);
}
