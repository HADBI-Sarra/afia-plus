import '../../models/speciality.dart';
import 'speciality_repository.dart';

class DummySpecialityRepository implements SpecialityRepository {
  final List<Speciality> _specialities = [
    Speciality(id: 1, name: "Cardiology"),
    Speciality(id: 2, name: "Dermatology"),
    Speciality(id: 3, name: "Neurology"),
    Speciality(id: 4, name: "General Medicine"),
  ];

  @override
  Future<List<Speciality>> getAllSpecialities() async {
    return Future.value(_specialities);
  }

  @override
  Future<Speciality?> getSpecialityById(int id) async {
    try {
      return _specialities.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
