import 'consultations_abstract.dart';

class ConsultationsDummy implements ConsultationsRepo {
  List<Map<String, dynamic>> consultations = [
    {
      'consultation_id': 1,
      'patient_id': 1,
      'doctor_id': 1,
      'availability_id': 2,
      'consultation_date': '2025-01-10',
      'start_time': '10:00',
      'status': 'scheduled',
      'prescription': ''
    },
    {
      'consultation_id': 2,
      'patient_id': 2,
      'doctor_id': 2,
      'availability_id': 3,
      'consultation_date': '2025-01-12',
      'start_time': '14:00',
      'status': 'pending',
      'prescription': ''
    }
  ];

  @override
  Future<List<Map<String, dynamic>>> getConsultations() async {
    return consultations;
  }

  @override
  Future<int> addConsultation(Map<String, dynamic> data) async {
    data['consultation_id'] = consultations.length + 1;
    consultations.add(data);
    return 1;
  }

  @override
  Future<int> updateConsultation(int id, Map<String, dynamic> data) async {
    final index = consultations.indexWhere((e) => e['consultation_id'] == id);
    if (index != -1) {
      consultations[index] = {...consultations[index], ...data};
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteConsultation(int id) async {
    consultations.removeWhere((e) => e['consultation_id'] == id);
    return 1;
  }

  @override
  Future<List<Map<String, dynamic>>> getConsultationsByDoctor(int doctorId) async {
    return consultations.where((e) => e['doctor_id'] == doctorId).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getConsultationsByPatient(int patientId) async {
    return consultations.where((e) => e['patient_id'] == patientId).toList();
  }
}
