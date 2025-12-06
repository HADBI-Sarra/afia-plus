import 'package:afia_plus_app/data/db_helper.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_abstract.dart';
import 'package:afia_plus_app/models/consultation.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';

class ConsultationsRepositoryImpl implements ConsultationsRepository {
  @override
  Future<List<ConsultationWithDetails>> getPatientConsultations(int patientId) async {
    final db = await DBHelper.getDatabase();
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        c.*,
        u1.firstname as doctor_firstname,
        u1.lastname as doctor_lastname,
        u1.profile_picture as doctor_image_path,
        s.speciality_name as doctor_specialty
      FROM consultations c
      LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
      LEFT JOIN users u1 ON d.doctor_id = u1.user_id
      LEFT JOIN specialities s ON d.speciality_id = s.speciality_id
      WHERE c.patient_id = ?
      ORDER BY c.consultation_date DESC, c.start_time DESC
    ''', [patientId]);

    return maps.map((map) => _mapToConsultationWithDetails(map)).toList();
  }

  @override
  Future<List<ConsultationWithDetails>> getDoctorConsultations(int doctorId) async {
    final db = await DBHelper.getDatabase();
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        c.*,
        u1.firstname as doctor_firstname,
        u1.lastname as doctor_lastname,
        u1.profile_picture as doctor_image_path,
        s.speciality_name as doctor_specialty,
        u2.firstname as patient_firstname,
        u2.lastname as patient_lastname
      FROM consultations c
      LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
      LEFT JOIN users u1 ON d.doctor_id = u1.user_id
      LEFT JOIN specialities s ON d.speciality_id = s.speciality_id
      LEFT JOIN patients p ON c.patient_id = p.patient_id
      LEFT JOIN users u2 ON p.patient_id = u2.user_id
      WHERE c.doctor_id = ?
      ORDER BY c.consultation_date DESC, c.start_time DESC
    ''', [doctorId]);

    return maps.map((map) => _mapToConsultationWithDetails(map)).toList();
  }

  @override
  Future<List<ConsultationWithDetails>> getConfirmedPatientConsultations(int patientId) async {
    final db = await DBHelper.getDatabase();
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        c.*,
        u1.firstname as doctor_firstname,
        u1.lastname as doctor_lastname,
        u1.profile_picture as doctor_image_path,
        s.speciality_name as doctor_specialty
      FROM consultations c
      LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
      LEFT JOIN users u1 ON d.doctor_id = u1.user_id
      LEFT JOIN specialities s ON d.speciality_id = s.speciality_id
      WHERE c.patient_id = ? AND c.status IN ('scheduled', 'completed')
      ORDER BY c.consultation_date DESC, c.start_time DESC
    ''', [patientId]);

    return maps.map((map) => _mapToConsultationWithDetails(map)).toList();
  }

  @override
  Future<List<ConsultationWithDetails>> getNotConfirmedPatientConsultations(int patientId) async {
    final db = await DBHelper.getDatabase();
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        c.*,
        u1.firstname as doctor_firstname,
        u1.lastname as doctor_lastname,
        u1.profile_picture as doctor_image_path,
        s.speciality_name as doctor_specialty
      FROM consultations c
      LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
      LEFT JOIN users u1 ON d.doctor_id = u1.user_id
      LEFT JOIN specialities s ON d.speciality_id = s.speciality_id
      WHERE c.patient_id = ? AND c.status = 'pending'
      ORDER BY c.consultation_date DESC, c.start_time DESC
    ''', [patientId]);

    return maps.map((map) => _mapToConsultationWithDetails(map)).toList();
  }

  @override
  Future<List<ConsultationWithDetails>> getUpcomingDoctorConsultations(int doctorId) async {
    final db = await DBHelper.getDatabase();
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        c.*,
        u1.firstname as doctor_firstname,
        u1.lastname as doctor_lastname,
        u1.profile_picture as doctor_image_path,
        s.speciality_name as doctor_specialty,
        u2.firstname as patient_firstname,
        u2.lastname as patient_lastname
      FROM consultations c
      LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
      LEFT JOIN users u1 ON d.doctor_id = u1.user_id
      LEFT JOIN specialities s ON d.speciality_id = s.speciality_id
      LEFT JOIN patients p ON c.patient_id = p.patient_id
      LEFT JOIN users u2 ON p.patient_id = u2.user_id
      WHERE c.doctor_id = ? AND c.status IN ('pending', 'scheduled') AND c.consultation_date >= ?
      ORDER BY c.consultation_date ASC, c.start_time ASC
    ''', [doctorId, today]);

    return maps.map((map) => _mapToConsultationWithDetails(map)).toList();
  }

  @override
  Future<List<ConsultationWithDetails>> getPastDoctorConsultations(int doctorId) async {
    final db = await DBHelper.getDatabase();
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        c.*,
        u1.firstname as doctor_firstname,
        u1.lastname as doctor_lastname,
        u1.profile_picture as doctor_image_path,
        s.speciality_name as doctor_specialty,
        u2.firstname as patient_firstname,
        u2.lastname as patient_lastname
      FROM consultations c
      LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
      LEFT JOIN users u1 ON d.doctor_id = u1.user_id
      LEFT JOIN specialities s ON d.speciality_id = s.speciality_id
      LEFT JOIN patients p ON c.patient_id = p.patient_id
      LEFT JOIN users u2 ON p.patient_id = u2.user_id
      WHERE c.doctor_id = ? AND c.status = 'completed' AND c.consultation_date < ?
      ORDER BY c.consultation_date DESC, c.start_time DESC
    ''', [doctorId, today]);

    return maps.map((map) => _mapToConsultationWithDetails(map)).toList();
  }

  @override
  Future<List<ConsultationWithDetails>> getPatientPrescriptions(int patientId) async {
    final db = await DBHelper.getDatabase();
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        c.*,
        u1.firstname as doctor_firstname,
        u1.lastname as doctor_lastname,
        u1.profile_picture as doctor_image_path,
        s.speciality_name as doctor_specialty
      FROM consultations c
      LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
      LEFT JOIN users u1 ON d.doctor_id = u1.user_id
      LEFT JOIN specialities s ON d.speciality_id = s.speciality_id
      WHERE c.patient_id = ? AND c.prescription IS NOT NULL AND c.prescription != ''
      ORDER BY c.consultation_date DESC
    ''', [patientId]);

    return maps.map((map) => _mapToConsultationWithDetails(map)).toList();
  }

  @override
  Future<int> createConsultation(Consultation consultation) async {
    final db = await DBHelper.getDatabase();
    final map = consultation.toMap();
    map.remove('consultation_id'); // Remove ID for insertion
    
    return await db.insert('consultations', map);
  }

  @override
  Future<void> updateConsultationStatus(int consultationId, String status) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'consultations',
      {'status': status},
      where: 'consultation_id = ?',
      whereArgs: [consultationId],
    );
  }

  @override
  Future<void> updateConsultationPrescription(int consultationId, String prescription) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'consultations',
      {'prescription': prescription},
      where: 'consultation_id = ?',
      whereArgs: [consultationId],
    );
  }

  @override
  Future<void> deleteConsultation(int consultationId) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      'consultations',
      where: 'consultation_id = ?',
      whereArgs: [consultationId],
    );
  }

  @override
  Future<ConsultationWithDetails?> getConsultationById(int consultationId) async {
    final db = await DBHelper.getDatabase();
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        c.*,
        u1.firstname as doctor_firstname,
        u1.lastname as doctor_lastname,
        u1.profile_picture as doctor_image_path,
        s.speciality_name as doctor_specialty,
        u2.firstname as patient_firstname,
        u2.lastname as patient_lastname
      FROM consultations c
      LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
      LEFT JOIN users u1 ON d.doctor_id = u1.user_id
      LEFT JOIN specialities s ON d.speciality_id = s.speciality_id
      LEFT JOIN patients p ON c.patient_id = p.patient_id
      LEFT JOIN users u2 ON p.patient_id = u2.user_id
      WHERE c.consultation_id = ?
    ''', [consultationId]);

    if (maps.isEmpty) return null;
    return _mapToConsultationWithDetails(maps.first);
  }

  ConsultationWithDetails _mapToConsultationWithDetails(Map<String, dynamic> map) {
    final consultation = Consultation.fromMap(map);
    
    return ConsultationWithDetails(
      consultation: consultation,
      doctorFirstName: map['doctor_firstname'] as String?,
      doctorLastName: map['doctor_lastname'] as String?,
      doctorSpecialty: map['doctor_specialty'] as String?,
      patientFirstName: map['patient_firstname'] as String?,
      patientLastName: map['patient_lastname'] as String?,
      doctorImagePath: map['doctor_image_path'] as String?,
    );
  }
}

