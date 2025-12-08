abstract class ConsultationsRepo {
  Future<List<Map<String, dynamic>>> getConsultations();
  Future<int> addConsultation(Map<String, dynamic> data);
  Future<int> updateConsultation(int id, Map<String, dynamic> data);
  Future<int> deleteConsultation(int id);
  Future<List<Map<String, dynamic>>> getConsultationsByDoctor(int doctorId);
  Future<List<Map<String, dynamic>>> getConsultationsByPatient(int patientId);
}
