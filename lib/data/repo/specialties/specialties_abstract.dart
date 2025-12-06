abstract class SpecialtiesRepo {
  Future<List<Map<String, dynamic>>> getSpecialties();
  Future<int> addSpecialty(Map<String, dynamic> data);
  Future<int> updateSpecialty(int id, Map<String, dynamic> data);
  Future<int> deleteSpecialty(int id);
}
