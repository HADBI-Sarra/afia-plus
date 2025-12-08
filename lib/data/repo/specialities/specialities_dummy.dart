import 'specialities_abstract.dart';

class SpecialitiesDummy implements SpecialitiesRepo {
  List<Map<String, dynamic>> specialities = [
    {'speciality_id': 1, 'speciality_name': 'General Medicine'},
    {'speciality_id': 2, 'speciality_name': 'Cardiology'},
    {'speciality_id': 3, 'speciality_name': 'Dermatology'},
  ];

  @override
  Future<List<Map<String, dynamic>>> getSpecialities() async {
    return specialities;
  }

  @override
  Future<int> addSpeciality(Map<String, dynamic> data) async {
    data['speciality_id'] = specialities.length + 1;
    specialities.add(data);
    return 1;
  }

  @override
  Future<int> updateSpeciality(int id, Map<String, dynamic> data) async {
    final index = specialities.indexWhere((e) => e['speciality_id'] == id);
    if (index != -1) {
      specialities[index] = {...specialities[index], ...data};
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteSpeciality(int id) async {
    specialities.removeWhere((e) => e['speciality_id'] == id);
    return 1;
  }
}
