import 'package:afia_plus_app/data/db_helper.dart';
import 'patients_abstract.dart';

class PatientsImpl implements PatientsRepo {
  @override
  Future<List<Map<String, dynamic>>> getPatients() async {
    final db = await DBHelper.getDatabase();
    return await db.query('patients');
  }

  @override
  Future<int> addPatient(Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('patients', data);
  }

  @override
  Future<int> updatePatient(int id, Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.update(
      'patients',
      data,
      where: 'patient_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deletePatient(int id) async {
    final db = await DBHelper.getDatabase();
    return await db.delete(
      'patients',
      where: 'patient_id = ?',
      whereArgs: [id],
    );
  }
}
