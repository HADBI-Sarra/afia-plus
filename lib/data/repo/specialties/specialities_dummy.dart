import 'specialties_abstract.dart';

class SpecialtiesDummy implements SpecialtiesRepo {
  List<Map<String, dynamic>> specialties = [
    {'id': 1, 'name': 'Cardiology'},
    {'id': 2, 'name': 'Pediatrics'},
    {'id': 3, 'name': 'Dermatology'},
  ];

  @override
  Future<List<Map<String, dynamic>>> getSpecialties() async {
    return specialties;
  }

  @override
  Future<int> addSpecialty(Map<String, dynamic> data) async {
    data['id'] = specialties.length + 1;
    specialties.add(data);
    return 1;
  }

  @override
  Future<int> updateSpecialty(int id, Map<String, dynamic> data) async {
    final index = specialties.indexWhere((e) => e['id'] == id);
    if (index != -1) {
      specialties[index] = {...specialties[index], ...data};
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteSpecialty(int id) async {
    specialties.removeWhere((e) => e['id'] == id);
    return 1;
  }
}
