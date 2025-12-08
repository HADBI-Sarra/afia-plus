import 'package:afia_plus_app/data/db_helper.dart';
import 'doctors_abstract.dart';

class DoctorsImpl implements DoctorsRepo {
  @override
  Future<List<Map<String, dynamic>>> getDoctors() async {
    final db = await DBHelper.getDatabase();
    return await db.query('doctors');
  }

  @override
  Future<int> addDoctor(Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('doctors', data);
  }

  @override
  Future<int> updateDoctor(int id, Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.update(
      'doctors',
      data,
      where: 'doctor_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteDoctor(int id) async {
    final db = await DBHelper.getDatabase();
    return await db.delete(
      'doctors',
      where: 'doctor_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Map<String, dynamic>?> getDoctorById(int id) async {
    final db = await DBHelper.getDatabase();
    final result = await db.query(
      'doctors',
      where: 'doctor_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
