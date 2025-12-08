import 'patients_abstract.dart';

class PatientsDummy implements PatientsRepo {
  List<Map<String, dynamic>> patients = [
    {'patient_id': 1, 'date_of_birth': '1992-03-15'},
    {'patient_id': 2, 'date_of_birth': '1988-10-22'},
  ];

  @override
  Future<List<Map<String, dynamic>>> getPatients() async {
    return patients;
  }

  @override
  Future<int> addPatient(Map<String, dynamic> data) async {
    data['patient_id'] = patients.length + 1;
    patients.add(data);
    return 1;
  }

  @override
  Future<int> updatePatient(int id, Map<String, dynamic> data) async {
    final index = patients.indexWhere((e) => e['patient_id'] == id);
    if (index != -1) {
      patients[index] = {...patients[index], ...data};
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deletePatient(int id) async {
    patients.removeWhere((e) => e['patient_id'] == id);
    return 1;
  }
}
