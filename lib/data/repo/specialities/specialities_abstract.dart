abstract class SpecialitiesRepo {
  Future<List<Map<String, dynamic>>> getSpecialities();
  Future<int> addSpeciality(Map<String, dynamic> data);
  Future<int> updateSpeciality(int id, Map<String, dynamic> data);
  Future<int> deleteSpeciality(int id);
}
