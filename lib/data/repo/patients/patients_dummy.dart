import 'patients_abstract.dart';

class PatientsDummy implements PatientsRepo {
  List<Map<String, dynamic>> patients = [
    {'id': 1, 'name': 'Patient A', 'age': 32, 'gender': 'Male'},
    {'id': 2, 'name': 'Patient B', 'age': 27, 'gender': 'Female'},
  ];

  @override
  Future<List<Map<String, dynamic>>> getPatients() async {
    return patients;
  }

  @override
  Future<int> addPatient(Map<String, dynamic> data) async {
    data['id'] = patients.length + 1;
    patients.add(data);
    return 1;
  }

  @override
  Future<int> updatePatient(int id, Map<String, dynamic> data) async {
    final index = patients.indexWhere((e) => e['id'] == id);
    if (index != -1) {
      patients[index] = {...patients[index], ...data};
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deletePatient(int id) async {
    patients.removeWhere((e) => e['id'] == id);
    return 1;
  }
}
