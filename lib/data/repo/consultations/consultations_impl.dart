import 'package:afia_plus_app/data/db_helper.dart';
import 'consultations_abstract.dart';

class ConsultationsImpl implements ConsultationsRepo {
  @override
  Future<List<Map<String, dynamic>>> getConsultations() async {
    final db = await DBHelper.getDatabase();
    return await db.query('consultations');
  }

  @override
  Future<int> addConsultation(Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('consultations', data);
  }

  @override
  Future<int> updateConsultation(int id, Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.update(
      'consultations',
      data,
      where: 'consultation_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteConsultation(int id) async {
    final db = await DBHelper.getDatabase();
    return await db.delete(
      'consultations',
      where: 'consultation_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getConsultationsByDoctor(int doctorId) async {
    final db = await DBHelper.getDatabase();
    return await db.query(
      'consultations',
      where: 'doctor_id = ?',
      whereArgs: [doctorId],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getConsultationsByPatient(int patientId) async {
    final db = await DBHelper.getDatabase();
    return await db.query(
      'consultations',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
  }
}
