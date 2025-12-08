import 'package:flutter/material.dart';
import 'package:afia_plus_app/utils/db_seeder.dart';
import 'package:afia_plus_app/data/db_helper.dart';

/// Screen to verify database usage and test data
class DBVerificationScreen extends StatefulWidget {
  const DBVerificationScreen({super.key});

  @override
  State<DBVerificationScreen> createState() => _DBVerificationScreenState();
}

class _DBVerificationScreenState extends State<DBVerificationScreen> {
  String _verificationResult = 'Click "Verify Database" to check';
  bool _isLoading = false;

  Future<void> _verifyDatabase() async {
    setState(() {
      _isLoading = true;
      _verificationResult = 'Verifying database...';
    });

    final result = StringBuffer();
    result.writeln('📊 Database Verification Report:\n');
    result.writeln('=' * 50);

    try {
      final db = await DBHelper.getDatabase();

      // Check users table
      final users = await db.query('users');
      result.writeln('\n👥 Users table: ${users.length} records');
      for (var user in users) {
        result.writeln('   - ${user['firstname']} ${user['lastname']} (${user['role']})');
      }

      // Check consultations table
      final consultations = await db.query('consultations');
      result.writeln('\n📅 Consultations table: ${consultations.length} records');
      for (var consultation in consultations) {
        result.writeln('   - Consultation ID: ${consultation['consultation_id']}');
        result.writeln('     Patient ID: ${consultation['patient_id']}');
        result.writeln('     Doctor ID: ${consultation['doctor_id']}');
        result.writeln('     Date: ${consultation['consultation_date']}');
        result.writeln('     Status: ${consultation['status']}');
        result.writeln('     Has Prescription: ${consultation['prescription'] != null}');
        result.writeln('');
      }

      // Check doctors table
      final doctors = await db.query('doctors');
      result.writeln('👨‍⚕️ Doctors table: ${doctors.length} records');

      // Check patients table
      final patients = await db.query('patients');
      result.writeln('🏥 Patients table: ${patients.length} records');

      result.writeln('\n✅ Database is working correctly!');
      result.writeln('\n💡 Tip: If tables are empty, click "Insert Test Data" first.');
    } catch (e) {
      result.writeln('\n❌ Error: $e');
    }

    setState(() {
      _isLoading = false;
      _verificationResult = result.toString();
    });
  }

  Future<void> _insertTestData() async {
    setState(() {
      _isLoading = true;
      _verificationResult = 'Clearing old data and inserting fresh test data...';
    });

    try {
      // Force reseed (clears and inserts fresh data)
      await DBSeeder.forceReseed();
      final patientId = await DBSeeder.getPatientId();
      
      setState(() {
        if (patientId != null) {
          _verificationResult = '✅ Test data inserted successfully!\n\nPatient ID: $patientId\n\nClick "Verify Database" to see the data.\n\n⚠️ If patient ID is not 1, update the hardcoded patientId in cubits.';
        } else {
          _verificationResult = '✅ Test data inserted successfully!\n\n⚠️ Could not determine patient ID.\n\nClick "Verify Database" to see the data.';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _verificationResult = '❌ Error inserting test data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Verification'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _insertTestData,
                    icon: const Icon(Icons.add_circle),
                    label: const Text('Insert Test Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _verifyDatabase,
                    icon: const Icon(Icons.verified),
                    label: const Text('Verify Database'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _verificationResult,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

