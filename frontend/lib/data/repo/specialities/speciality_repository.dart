import '../../models/speciality.dart';

abstract class SpecialityRepository {
  Future<List<Speciality>> getAllSpecialities();
  Future<Speciality?> getSpecialityById(int id);
}
