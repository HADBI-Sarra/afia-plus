import 'package:afia_plus_app/data/db_helper.dart';

/// Helper class to verify database usage and insert test data
class DBTestHelper {
  /// Insert test data into the database matching the original static data
  static Future<void> insertTestData() async {
    final db = await DBHelper.getDatabase();

    try {
      // Check if data already exists
      final existingUsers = await db.query('users');
      if (existingUsers.isNotEmpty) {
        print(
          '⚠️ Database already has data. Use clearTestData() first to reset.',
        );
        return;
      }

      // Insert patient user (ID = 1)
      await db.insert('users', {
        'user_id': 1,
        'role': 'patient',
        'firstname': 'Besmala',
        'lastname': 'Boukenouche',
        'email': 'besmala@test.com',
        'password': 'test123',
        'phone_number': '0555123456',
        'nin': '1234567890123456',
        'profile_picture': 'assets/images/besmala.jpg',
      });

      // Insert doctor users with UNIQUE IDs (2-7)
      await db.insert('users', {
        'user_id': 2, // Dr. Mohamed Brahimi
        'role': 'doctor',
        'firstname': 'Mohamed',
        'lastname': 'Brahimi',
        'email': 'mohamed.brahimi@test.com',
        'password': 'test123',
        'phone_number': '0555123457',
        'nin': '1234567890123457',
        'profile_picture': 'assets/images/doctorBrahimi.png',
      });

      await db.insert('users', {
        'user_id': 3, // Dr. Righi Sirine
        'role': 'doctor',
        'firstname': 'Righi',
        'lastname': 'Sirine',
        'email': 'righi.sirine@test.com',
        'password': 'test123',
        'phone_number': '0555123458',
        'nin': '1234567890123458',
        'profile_picture': 'assets/images/doctorSirine.png',
      });

      await db.insert('users', {
        'user_id': 4, // Dr. Boukenouche Lamis
        'role': 'doctor',
        'firstname': 'Boukenouche',
        'lastname': 'Lamis',
        'email': 'boukenouche.lamis@test.com',
        'password': 'test123',
        'phone_number': '0555123459',
        'nin': '1234567890123459',
        'profile_picture': 'assets/images/doctorLamis.png',
      });

      await db.insert('users', {
        'user_id': 5, // Dr. Medouar Abdelilah
        'role': 'doctor',
        'firstname': 'Medouar',
        'lastname': 'Abdelilah',
        'email': 'medouar.abdelilah@test.com',
        'password': 'test123',
        'phone_number': '0555123460',
        'nin': '1234567890123460',
        'profile_picture': 'assets/images/doctorAbdelillah.png',
      });

      await db.insert('users', {
        'user_id': 6, // Dr. Lakhal Amine (for prescriptions)
        'role': 'doctor',
        'firstname': 'Lakhal',
        'lastname': 'Amine',
        'email': 'lakhal.amine@test.com',
        'password': 'test123',
        'phone_number': '0555123461',
        'nin': '1234567890123461',
        'profile_picture': 'assets/images/doctorBrahimi.png', // Default fallback
      });

      await db.insert('users', {
        'user_id': 7, // Dr. Moussaoui Samia (for prescriptions)
        'role': 'doctor',
        'firstname': 'Moussaoui',
        'lastname': 'Samia',
        'email': 'moussaoui.samia@test.com',
        'password': 'test123',
        'phone_number': '0555123462',
        'nin': '1234567890123462',
        'profile_picture': 'assets/images/doctorBrahimi.png', // Default fallback
      });

      const patientId = 1;

      // Insert patient
      await db.insert('patients', {
        'patient_id': patientId,
        'date_of_birth': '2000-01-01',
      });

      // Insert specialties
      await db.insert('specialities', {
        'speciality_id': 1,
        'speciality_name': 'Cardiologist',
      });
      await db.insert('specialities', {
        'speciality_id': 2,
        'speciality_name': 'Dentist',
      });
      await db.insert('specialities', {
        'speciality_id': 3,
        'speciality_name': 'Radiologist',
      });
      await db.insert('specialities', {
        'speciality_id': 4,
        'speciality_name': 'Neurologist',
      });

      // Insert doctors (doctor_id matches user_id)
      await db.insert('doctors', {
        'doctor_id': 2, // Dr. Brahimi
        'speciality_id': 1, // Cardiologist
        'bio': 'Experienced cardiologist',
        'location_of_work': 'Algiers',
        'degree': 'MD',
        'university': 'University of Algiers',
        'years_experience': 10,
      });

      await db.insert('doctors', {
        'doctor_id': 3, // Dr. Sirine
        'speciality_id': 2, // Dentist
        'bio': 'Professional dentist',
        'location_of_work': 'Algiers',
        'degree': 'DDS',
        'university': 'University of Algiers',
        'years_experience': 8,
      });

      await db.insert('doctors', {
        'doctor_id': 4, // Dr. Lamis
        'speciality_id': 3, // Radiologist
        'bio': 'Expert radiologist',
        'location_of_work': 'Algiers',
        'degree': 'MD',
        'university': 'University of Algiers',
        'years_experience': 12,
      });

      await db.insert('doctors', {
        'doctor_id': 5, // Dr. Abdelilah
        'speciality_id': 4, // Neurologist
        'bio': 'Specialized neurologist',
        'location_of_work': 'Algiers',
        'degree': 'MD',
        'university': 'University of Algiers',
        'years_experience': 15,
      });

      await db.insert('doctors', {
        'doctor_id': 6, // Dr. Amine
        'speciality_id': 1, // Cardiologist
        'bio': 'Cardiologist',
        'location_of_work': 'Algiers',
        'degree': 'MD',
        'university': 'University of Algiers',
        'years_experience': 9,
      });

      await db.insert('doctors', {
        'doctor_id': 7, // Dr. Samia
        'speciality_id': 1, // Cardiologist
        'bio': 'General Practitioner',
        'location_of_work': 'Algiers',
        'degree': 'MD',
        'university': 'University of Algiers',
        'years_experience': 7,
      });

      // Insert doctor availability slots
      // Use dates relative to today to ensure they show up
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));
      final dayAfterTomorrow = today.add(const Duration(days: 2));
      final nextWeek = today.add(const Duration(days: 7));
      
      // For Dr. Brahimi - scheduled consultation (tomorrow)
      final avail1 = await db.insert('doctor_availability', {
        'doctor_id': 2,
        'available_date': tomorrow.toIso8601String().split('T')[0],
        'start_time': '12:00',
        'status': 'booked',
      });

      // For Dr. Sirine - scheduled consultation (day after tomorrow)
      final avail2 = await db.insert('doctor_availability', {
        'doctor_id': 3,
        'available_date': dayAfterTomorrow.toIso8601String().split('T')[0],
        'start_time': '10:00',
        'status': 'booked',
      });

      // For Dr. Lamis - pending consultation (next week)
      final avail3 = await db.insert('doctor_availability', {
        'doctor_id': 4,
        'available_date': nextWeek.toIso8601String().split('T')[0],
        'start_time': '12:00',
        'status': 'booked',
      });

      // For Dr. Abdelilah - pending consultation (next week + 1 day)
      final avail4 = await db.insert('doctor_availability', {
        'doctor_id': 5,
        'available_date': nextWeek.add(const Duration(days: 1)).toIso8601String().split('T')[0],
        'start_time': '12:00',
        'status': 'booked',
      });

      // For Dr. Brahimi (doctor 2) - pending consultation (for testing Accept/Reject buttons)
      final avail4b = await db.insert('doctor_availability', {
        'doctor_id': 2,
        'available_date': nextWeek.add(const Duration(days: 2)).toIso8601String().split('T')[0],
        'start_time': '15:00',
        'status': 'booked',
      });

      // For prescriptions - past consultations (30 days ago, 60 days ago, 90 days ago, 45 days ago)
      final pastDate1 = today.subtract(const Duration(days: 30));
      final pastDate2 = today.subtract(const Duration(days: 45)); // For doctor 2 without prescription (for testing upload)
      final pastDate3 = today.subtract(const Duration(days: 60));
      final pastDate4 = today.subtract(const Duration(days: 90));
      
      final avail5 = await db.insert('doctor_availability', {
        'doctor_id': 2,
        'available_date': pastDate1.toIso8601String().split('T')[0],
        'start_time': '10:00',
        'status': 'booked',
      });

      final avail5b = await db.insert('doctor_availability', {
        'doctor_id': 2,
        'available_date': pastDate2.toIso8601String().split('T')[0],
        'start_time': '14:00',
        'status': 'booked',
      });

      final avail6 = await db.insert('doctor_availability', {
        'doctor_id': 6,
        'available_date': pastDate3.toIso8601String().split('T')[0],
        'start_time': '14:00',
        'status': 'booked',
      });

      final avail7 = await db.insert('doctor_availability', {
        'doctor_id': 7,
        'available_date': pastDate4.toIso8601String().split('T')[0],
        'start_time': '11:00',
        'status': 'booked',
      });

      // Insert CONFIRMED consultations (scheduled status)
      await db.insert('consultations', {
        'patient_id': patientId,
        'doctor_id': 2, // Dr. Mohamed Brahimi
        'availability_id': avail1,
        'consultation_date': tomorrow.toIso8601String().split('T')[0],
        'start_time': '12:00',
        'status': 'scheduled',
        'prescription': null,
      });

      await db.insert('consultations', {
        'patient_id': patientId,
        'doctor_id': 3, // Dr. Righi Sirine
        'availability_id': avail2,
        'consultation_date': dayAfterTomorrow.toIso8601String().split('T')[0],
        'start_time': '10:00',
        'status': 'scheduled',
        'prescription': null,
      });

      // Insert NOT CONFIRMED consultations (pending status)
      await db.insert('consultations', {
        'patient_id': patientId,
        'doctor_id': 4, // Dr. Boukenouche Lamis
        'availability_id': avail3,
        'consultation_date': nextWeek.toIso8601String().split('T')[0],
        'start_time': '12:00',
        'status': 'pending',
        'prescription': null,
      });

      await db.insert('consultations', {
        'patient_id': patientId,
        'doctor_id': 5, // Dr. Medouar Abdelilah
        'availability_id': avail4,
        'consultation_date': nextWeek.add(const Duration(days: 1)).toIso8601String().split('T')[0],
        'start_time': '12:00',
        'status': 'pending',
        'prescription': null,
      });

      // Pending consultation for doctor 2 (to show Accept/Reject buttons)
      await db.insert('consultations', {
        'patient_id': patientId,
        'doctor_id': 2, // Dr. Mohamed Brahimi - PENDING (for testing Accept/Reject)
        'availability_id': avail4b,
        'consultation_date': nextWeek.add(const Duration(days: 2)).toIso8601String().split('T')[0],
        'start_time': '15:00',
        'status': 'pending',
        'prescription': null,
      });

      // Insert COMPLETED consultations for doctor 2
      // First one WITH prescription (to show "PDF Uploaded" state)
      final consultation1 = await db.insert('consultations', {
        'patient_id': patientId,
        'doctor_id': 2, // Dr. Brahimi Mohamed
        'availability_id': avail5,
        'consultation_date': pastDate1.toIso8601String().split('T')[0],
        'start_time': '10:00',
        'status': 'completed',
        'prescription': 'assets/prescription pdfs/pdf1.pdf',
      });

      // Second one WITHOUT prescription (for testing upload functionality)
      // This one should show "Upload PDF" button in Past Appointments
      final consultation2 = await db.insert('consultations', {
        'patient_id': patientId,
        'doctor_id': 2, // Dr. Brahimi Mohamed - NO PRESCRIPTION (for testing)
        'availability_id': avail5b,
        'consultation_date': pastDate2.toIso8601String().split('T')[0],
        'start_time': '14:00',
        'status': 'completed',
        'prescription': null, // No prescription - allows testing upload
      });
      
      print('✅ Created past consultations for doctor 2:');
      print('   - Consultation $consultation1: WITH prescription (${pastDate1.toIso8601String().split('T')[0]})');
      print('   - Consultation $consultation2: WITHOUT prescription (${pastDate2.toIso8601String().split('T')[0]}) - READY FOR UPLOAD TEST');

      await db.insert('consultations', {
        'patient_id': patientId,
        'doctor_id': 6, // Dr. Lakhal Amine
        'availability_id': avail6,
        'consultation_date': pastDate3.toIso8601String().split('T')[0],
        'start_time': '14:00',
        'status': 'completed',
        'prescription': 'assets/prescription pdfs/pdf2.pdf',
      });

      await db.insert('consultations', {
        'patient_id': patientId,
        'doctor_id': 7, // Dr. Moussaoui Samia
        'availability_id': avail7,
        'consultation_date': pastDate4.toIso8601String().split('T')[0],
        'start_time': '11:00',
        'status': 'completed',
        'prescription': 'assets/prescription pdfs/pdf3.pdf',
      });

      print('✅ Test data inserted successfully!');
      print('   Patient ID: $patientId');
      print('   Doctors: 6 doctors inserted');
      print('   Consultations: 7 consultations inserted');
      print('   - 2 Confirmed (scheduled)');
      print('   - 2 Not Confirmed (pending)');
      print('   - 3 Completed with Prescriptions');
    } catch (e) {
      print('❌ Error inserting test data with explicit IDs: $e');
      print('   Trying without explicit IDs (auto-increment)...');
      // If error is due to duplicate IDs or other issues, try without specifying IDs
      try {
        await _insertTestDataWithoutIds();
      } catch (e2) {
        print('❌ Fallback method also failed: $e2');
        rethrow;
      }
    }
  }

  /// Insert test data without specifying IDs (let database auto-increment)
  static Future<void> _insertTestDataWithoutIds() async {
    final db = await DBHelper.getDatabase();

    // Clear first
    await clearTestData();

    // Insert patient
    final patientUserId = await db.insert('users', {
      'role': 'patient',
      'firstname': 'Besmala',
      'lastname': 'Boukenouche',
      'email': 'besmala@test.com',
      'password': 'test123',
      'phone_number': '0555123456',
      'nin': '1234567890123456',
      'profile_picture': 'assets/images/besmala.jpg',
    });

    await db.insert('patients', {
      'patient_id': patientUserId,
      'date_of_birth': '2000-01-01',
    });

    // Insert specialties
    final cardId = await db.insert('specialities', {
      'speciality_name': 'Cardiologist',
    });
    final dentId = await db.insert('specialities', {
      'speciality_name': 'Dentist',
    });
    final radId = await db.insert('specialities', {
      'speciality_name': 'Radiologist',
    });
    final neuroId = await db.insert('specialities', {
      'speciality_name': 'Neurologist',
    });

    // Insert doctors
    final doc1 = await db.insert('users', {
      'role': 'doctor',
      'firstname': 'Mohamed',
      'lastname': 'Brahimi',
      'email': 'mohamed.brahimi@test.com',
      'password': 'test123',
      'phone_number': '0555123457',
      'nin': '1234567890123457',
      'profile_picture': 'assets/images/doctorBrahimi.png',
    });
    await db.insert('doctors', {
      'doctor_id': doc1,
      'speciality_id': cardId,
      'bio': 'Experienced cardiologist',
      'location_of_work': 'Algiers',
      'degree': 'MD',
      'university': 'University of Algiers',
      'years_experience': 10,
    });

    final doc2 = await db.insert('users', {
      'role': 'doctor',
      'firstname': 'Righi',
      'lastname': 'Sirine',
      'email': 'righi.sirine@test.com',
      'password': 'test123',
      'phone_number': '0555123458',
      'nin': '1234567890123458',
      'profile_picture': 'assets/images/doctorSirine.png',
    });
    await db.insert('doctors', {
      'doctor_id': doc2,
      'speciality_id': dentId,
      'bio': 'Professional dentist',
      'location_of_work': 'Algiers',
      'degree': 'DDS',
      'university': 'University of Algiers',
      'years_experience': 8,
    });

    final doc3 = await db.insert('users', {
      'role': 'doctor',
      'firstname': 'Boukenouche',
      'lastname': 'Lamis',
      'email': 'boukenouche.lamis@test.com',
      'password': 'test123',
      'phone_number': '0555123459',
      'nin': '1234567890123459',
      'profile_picture': 'assets/images/doctorLamis.png',
    });
    await db.insert('doctors', {
      'doctor_id': doc3,
      'speciality_id': radId,
      'bio': 'Expert radiologist',
      'location_of_work': 'Algiers',
      'degree': 'MD',
      'university': 'University of Algiers',
      'years_experience': 12,
    });

    final doc4 = await db.insert('users', {
      'role': 'doctor',
      'firstname': 'Medouar',
      'lastname': 'Abdelilah',
      'email': 'medouar.abdelilah@test.com',
      'password': 'test123',
      'phone_number': '0555123460',
      'nin': '1234567890123460',
      'profile_picture': 'assets/images/doctorAbdelillah.png',
    });
    await db.insert('doctors', {
      'doctor_id': doc4,
      'speciality_id': neuroId,
      'bio': 'Specialized neurologist',
      'location_of_work': 'Algiers',
      'degree': 'MD',
      'university': 'University of Algiers',
      'years_experience': 15,
    });

    final doc5 = await db.insert('users', {
      'role': 'doctor',
      'firstname': 'Lakhal',
      'lastname': 'Amine',
      'email': 'lakhal.amine@test.com',
      'password': 'test123',
      'phone_number': '0555123461',
      'nin': '1234567890123461',
      'profile_picture': 'assets/images/doctorBrahimi.png', // Default fallback
    });
    await db.insert('doctors', {
      'doctor_id': doc5,
      'speciality_id': cardId,
      'bio': 'Cardiologist',
      'location_of_work': 'Algiers',
      'degree': 'MD',
      'university': 'University of Algiers',
      'years_experience': 9,
    });

    final doc6 = await db.insert('users', {
      'role': 'doctor',
      'firstname': 'Moussaoui',
      'lastname': 'Samia',
      'email': 'moussaoui.samia@test.com',
      'password': 'test123',
      'phone_number': '0555123462',
      'nin': '1234567890123462',
      'profile_picture': 'assets/images/doctorBrahimi.png', // Default fallback
    });
    await db.insert('doctors', {
      'doctor_id': doc6,
      'speciality_id': cardId,
      'bio': 'General Practitioner',
      'location_of_work': 'Algiers',
      'degree': 'MD',
      'university': 'University of Algiers',
      'years_experience': 7,
    });

    // Insert availability and consultations
    final avail1 = await db.insert('doctor_availability', {
      'doctor_id': doc1,
      'available_date': '2025-11-12',
      'start_time': '12:00',
      'status': 'booked',
    });
    await db.insert('consultations', {
      'patient_id': patientUserId,
      'doctor_id': doc1,
      'availability_id': avail1,
      'consultation_date': '2025-11-12',
      'start_time': '12:00',
      'status': 'scheduled',
    });

    final avail2 = await db.insert('doctor_availability', {
      'doctor_id': doc2,
      'available_date': '2025-11-13',
      'start_time': '10:00',
      'status': 'booked',
    });
    await db.insert('consultations', {
      'patient_id': patientUserId,
      'doctor_id': doc2,
      'availability_id': avail2,
      'consultation_date': '2025-11-13',
      'start_time': '10:00',
      'status': 'scheduled',
    });

    final avail3 = await db.insert('doctor_availability', {
      'doctor_id': doc3,
      'available_date': '2025-11-15',
      'start_time': '12:00',
      'status': 'booked',
    });
    await db.insert('consultations', {
      'patient_id': patientUserId,
      'doctor_id': doc3,
      'availability_id': avail3,
      'consultation_date': '2025-11-15',
      'start_time': '12:00',
      'status': 'pending',
    });

    final avail4 = await db.insert('doctor_availability', {
      'doctor_id': doc4,
      'available_date': '2025-11-16',
      'start_time': '12:00',
      'status': 'booked',
    });
    await db.insert('consultations', {
      'patient_id': patientUserId,
      'doctor_id': doc4,
      'availability_id': avail4,
      'consultation_date': '2025-11-16',
      'start_time': '12:00',
      'status': 'pending',
    });

    // Prescriptions (completed consultations) - using PDF paths
    final avail5 = await db.insert('doctor_availability', {
      'doctor_id': doc1,
      'available_date': '2025-09-18',
      'start_time': '10:00',
      'status': 'booked',
    });
    await db.insert('consultations', {
      'patient_id': patientUserId,
      'doctor_id': doc1,
      'availability_id': avail5,
      'consultation_date': '2025-09-18',
      'start_time': '10:00',
      'status': 'completed',
      'prescription': 'assets/prescription pdfs/pdf1.pdf',
    });

    final avail6 = await db.insert('doctor_availability', {
      'doctor_id': doc5,
      'available_date': '2025-03-17',
      'start_time': '14:00',
      'status': 'booked',
    });
    await db.insert('consultations', {
      'patient_id': patientUserId,
      'doctor_id': doc5,
      'availability_id': avail6,
      'consultation_date': '2025-03-17',
      'start_time': '14:00',
      'status': 'completed',
      'prescription': 'assets/prescription pdfs/pdf2.pdf',
    });

    final avail7 = await db.insert('doctor_availability', {
      'doctor_id': doc6,
      'available_date': '2025-01-02',
      'start_time': '11:00',
      'status': 'booked',
    });
    await db.insert('consultations', {
      'patient_id': patientUserId,
      'doctor_id': doc6,
      'availability_id': avail7,
      'consultation_date': '2025-01-02',
      'start_time': '11:00',
      'status': 'completed',
      'prescription': 'assets/prescription pdfs/pdf3.pdf',
    });

    print('✅ Test data inserted (auto-increment IDs)!');
    print('   Patient ID: $patientUserId');
    print('   ⚠️ Note: Update patientId in cubits to $patientUserId');
  }

  /// Verify database tables and data
  static Future<void> verifyDatabase() async {
    final db = await DBHelper.getDatabase();

    try {
      print('\n📊 Database Verification Report:');
      print('=' * 50);

      // Check users table
      final users = await db.query('users');
      print('\n👥 Users table: ${users.length} records');
      for (var user in users) {
        print(
          '   - ${user['firstname']} ${user['lastname']} (${user['role']})',
        );
      }

      // Check consultations table
      final consultations = await db.query('consultations');
      print('\n📅 Consultations table: ${consultations.length} records');
      for (var consultation in consultations) {
        print('   - Consultation ID: ${consultation['consultation_id']}');
        print('     Patient ID: ${consultation['patient_id']}');
        print('     Doctor ID: ${consultation['doctor_id']}');
        print('     Date: ${consultation['consultation_date']}');
        print('     Status: ${consultation['status']}');
        print('     Has Prescription: ${consultation['prescription'] != null}');
        print('');
      }

      // Check doctors table
      final doctors = await db.query('doctors');
      print('👨‍⚕️ Doctors table: ${doctors.length} records');

      // Check patients table
      final patients = await db.query('patients');
      print('🏥 Patients table: ${patients.length} records');

      print('\n✅ Database verification complete!');
    } catch (e) {
      print('❌ Error verifying database: $e');
    }
  }

  /// Clear all test data
  static Future<void> clearTestData() async {
    final db = await DBHelper.getDatabase();

    try {
      await db.delete('consultations');
      await db.delete('doctor_availability');
      await db.delete('doctors');
      await db.delete('patients');
      await db.delete('specialities');
      await db.delete('users');
      print('✅ Test data cleared successfully!');
    } catch (e) {
      print('❌ Error clearing test data: $e');
    }
  }

  /// Force reseed database (clears and inserts fresh data)
  static Future<void> forceReseedDatabase() async {
    try {
      print('🔄 Clearing existing data...');
      await clearTestData();
      print('📥 Inserting fresh test data...');
      await insertTestData();
      print('✅ Database reseeded successfully!');
    } catch (e) {
      print('❌ Error reseeding database: $e');
      rethrow;
    }
  }
}
