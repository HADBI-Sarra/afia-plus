import 'package:afia_plus_app/data/db_helper.dart';
import 'package:afia_plus_app/utils/db_test_helper.dart';

/// Automatically seeds the database with initial data on first launch
class DBSeeder {
  static const String _seedKey = 'database_seeded';

  /// Check if database has been seeded and seed if needed
  static Future<int?> ensureDatabaseSeeded() async {
    final db = await DBHelper.getDatabase();

    try {
      // Check if already seeded
      final prefs = await db.query(
        'sqlite_master',
        where: 'type = ? AND name = ?',
        whereArgs: ['table', 'app_preferences'],
      );

      // Simple check: if users table has data, assume seeded
      final users = await db.query('users');
      if (users.isNotEmpty) {
        // Find patient user
        final patient = await db.query(
          'users',
          where: 'role = ?',
          whereArgs: ['patient'],
          limit: 1,
        );
        if (patient.isNotEmpty) {
          return patient.first['user_id'] as int;
        }
        return null;
      }

      // Database is empty, seed it
      await DBTestHelper.insertTestData();

      // Get the patient ID that was inserted
      final patient = await db.query(
        'users',
        where: 'role = ?',
        whereArgs: ['patient'],
        limit: 1,
      );

      if (patient.isNotEmpty) {
        final patientId = patient.first['user_id'] as int;
        print('✅ Database seeded! Patient ID: $patientId');
        return patientId;
      }

      return null;
    } catch (e) {
      print('❌ Error seeding database: $e');
      return null;
    }
  }

  /// Get the patient ID from database (useful for updating hardcoded values)
  static Future<int?> getPatientId() async {
    final db = await DBHelper.getDatabase();
    try {
      final patient = await db.query(
        'users',
        where: 'role = ?',
        whereArgs: ['patient'],
        limit: 1,
      );
      if (patient.isNotEmpty) {
        return patient.first['user_id'] as int;
      }
    } catch (e) {
      print('Error getting patient ID: $e');
    }
    return null;
  }

  /// Force reseed database (useful when dates are outdated)
  static Future<void> forceReseed() async {
    await DBTestHelper.forceReseedDatabase();
  }

  /// Check if database has upcoming consultations
  static Future<bool> hasUpcomingConsultations(int doctorId) async {
    final db = await DBHelper.getDatabase();
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count
        FROM consultations
        WHERE doctor_id = ? AND status IN ('pending', 'scheduled') AND consultation_date >= ?
      ''', [doctorId, today]);
      
      final count = result.first['count'] as int;
      return count > 0;
    } catch (e) {
      print('Error checking consultations: $e');
      return false;
    }
  }
}
