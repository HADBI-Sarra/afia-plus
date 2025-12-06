import 'package:afia_plus_app/data/db_helper.dart';
import 'specialties_abstract.dart';

class SpecialtiesImpl implements SpecialtiesRepo {
  @override
  Future<List<Map<String, dynamic>>> getSpecialties() async {
    final db = await DBHelper.getDatabase();
    return await db.query('specialities');
  }

  @override
  Future<int> addSpecialty(Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('specialities', data);
  }

  @override
  Future<int> updateSpecialty(int id, Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.update(
      'specialities',
      data,
      where: 'speciality_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteSpecialty(int id) async {
    final db = await DBHelper.getDatabase();
    return await db.delete(
      'specialities',
      where: 'speciality_id = ?',
      whereArgs: [id],
    );
  }
}
