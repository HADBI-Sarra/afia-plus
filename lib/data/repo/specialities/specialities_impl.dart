import 'package:afia_plus_app/data/db_helper.dart';
import 'specialities_abstract.dart';

class SpecialitiesImpl implements SpecialitiesRepo {
  @override
  Future<List<Map<String, dynamic>>> getSpecialities() async {
    final db = await DBHelper.getDatabase();
    return await db.query('specialities');
  }

  @override
  Future<int> addSpeciality(Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('specialities', data);
  }

  @override
  Future<int> updateSpeciality(int id, Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.update(
      'specialities',
      data,
      where: 'speciality_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteSpeciality(int id) async {
    final db = await DBHelper.getDatabase();
    return await db.delete(
      'specialities',
      where: 'speciality_id = ?',
      whereArgs: [id],
    );
  }
}
