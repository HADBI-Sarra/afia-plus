import 'package:afia_plus_app/data/db_helper.dart';
import 'doctor_availability_abstract.dart';

class DoctorAvailabilityImpl implements DoctorAvailabilityRepo {
  @override
  Future<List<Map<String, dynamic>>> getAvailability() async {
    final db = await DBHelper.getDatabase();
    return await db.query('doctor_availability');
  }

  @override
  Future<int> addAvailability(Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('doctor_availability', data);
  }

  @override
  Future<int> updateAvailability(int id, Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.update(
      'doctor_availability',
      data,
      where: 'availability_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteAvailability(int id) async {
    final db = await DBHelper.getDatabase();
    return await db.delete(
      'doctor_availability',
      where: 'availability_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailabilityByDoctor(int doctorId) async {
    final db = await DBHelper.getDatabase();
    return await db.query(
      'doctor_availability',
      where: 'doctor_id = ?',
      whereArgs: [doctorId],
    );
  }
}
