import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _databaseName = "AFIA_PLUS_DB.db";
  static const _databaseVersion = 2; // Incremented to trigger migration
  static Database? _database;

  // Singleton pattern for database
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onCreate: (db, version) async {
        // Users table
        await db.execute('''
        CREATE TABLE users (
          user_id INTEGER PRIMARY KEY AUTOINCREMENT,
          role TEXT CHECK(role IN ('doctor','patient')),
          firstname TEXT,
          lastname TEXT,
          email TEXT UNIQUE,
          password TEXT,
          phone_number TEXT,
          nin TEXT,
          profile_picture TEXT
        )
        ''');

        // Patients table
        await db.execute('''
        CREATE TABLE patients (
          patient_id INTEGER PRIMARY KEY,
          date_of_birth TEXT,
          FOREIGN KEY(patient_id) REFERENCES users(user_id) ON DELETE CASCADE
        )
        ''');

        // Specialities table
        await db.execute('''
        CREATE TABLE IF NOT EXISTS specialities (
          speciality_id INTEGER PRIMARY KEY AUTOINCREMENT,
          speciality_name TEXT UNIQUE
        )
        ''');

        // Insert fixed set of specialities
        final List<String> specialities = [
          'Dentist',
          'Cardiologist',
          'General Practitioner',
          'Pediatrician',
          'Gynecologist',
          'Dermatologist',
          'Orthopedic Surgeon',
          'Urologist',
          'Psychiatrist',
          'Ophthalmologist',
          'ENT Specialist',
          'Gastroenterologist',
          'Endocrinologist',
          'Pulmonologist',
          'Neurologist',
          'Nephrologist',
          'Rheumatologist',
          'Oncologist',
          'Anesthesiologist',
          'Radiologist',
          'Emergency Medicine',
          'Plastic Surgeon',
          'Orthodontist',
          'Maxillofacial Surgeon',
          'Physiotherapist',
          'Allergist',
          'Hematologist',
          'Infectious Disease Specialist',
          'Geriatrician',
          'Family Medicine',
          'Internal Medicine',
          'Intensive Care Specialist',
          'Sports Medicine',
          'Nutritionist/Dietitian',
        ];

        for (var name in specialities) {
          await db.insert('specialities', {'speciality_name': name});
        }

        // Doctors table
        await db.execute('''
        CREATE TABLE doctors (
          doctor_id INTEGER PRIMARY KEY,
          speciality_id INTEGER,
          bio TEXT,
          location_of_work TEXT,
          degree TEXT,
          university TEXT,
          certification TEXT,
          institution TEXT,
          residency TEXT,
          license_number TEXT,
          license_description TEXT,
          years_experience INTEGER,
          areas_of_expertise TEXT,
          price_per_hour INTEGER,
          average_rating REAL DEFAULT 0,
          reviews_count INTEGER DEFAULT 0,
          FOREIGN KEY(doctor_id) REFERENCES users(user_id) ON DELETE CASCADE,
          FOREIGN KEY(speciality_id) REFERENCES specialities(speciality_id) ON DELETE CASCADE
        )
        ''');

        // Doctor availability table
        await db.execute('''
        CREATE TABLE doctor_availability (
          availability_id INTEGER PRIMARY KEY AUTOINCREMENT,
          doctor_id INTEGER,
          available_date TEXT,
          start_time TEXT,
          status TEXT CHECK(status IN ('free','booked')) DEFAULT 'free',
          FOREIGN KEY(doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
        )
        ''');

        // Consultations table
        await db.execute('''
        CREATE TABLE consultations (
          consultation_id INTEGER PRIMARY KEY AUTOINCREMENT,
          patient_id INTEGER,
          doctor_id INTEGER,
          availability_id INTEGER UNIQUE,
          consultation_date TEXT,
          start_time TEXT,
          status TEXT CHECK(status IN ('pending','scheduled','completed','cancelled')) DEFAULT 'scheduled',
          prescription TEXT,
          FOREIGN KEY(patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
          FOREIGN KEY(doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
          FOREIGN KEY(availability_id) REFERENCES doctor_availability(availability_id) ON DELETE CASCADE
        )
        ''');

        // Doctor reviews table
        await db.execute('''
        CREATE TABLE doctor_reviews (
          review_id INTEGER PRIMARY KEY AUTOINCREMENT,
          doctor_id INTEGER,
          patient_id INTEGER,
          rating INTEGER CHECK(rating >= 1 AND rating <= 5),
          comment TEXT,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY(doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
          FOREIGN KEY(patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
        )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Migration from version 1 to 2: Add profile_picture column
        if (oldVersion < 2) {
          try {
            // Check if column already exists (in case migration runs multiple times)
            final tableInfo = await db.rawQuery('PRAGMA table_info(users)');
            final hasProfilePicture = tableInfo.any(
              (column) => column['name'] == 'profile_picture',
            );

            if (!hasProfilePicture) {
              await db.execute(
                'ALTER TABLE users ADD COLUMN profile_picture TEXT',
              );
              print(
                '✅ Database migrated: Added profile_picture column to users table',
              );
            }
          } catch (e) {
            print('⚠️ Migration error (may already exist): $e');
            // Column might already exist, continue anyway
          }
        }
      },
      onOpen: (db) async {
        // Print all doctors with all columns
        final doctors = await db.query('doctors'); // query all rows
        if (doctors.isEmpty) {
          print('____No doctors found in the database.');
        } else {
          print('____Doctors table rows:');
          for (var doc in doctors) {
            print(doc); // Each doc is a Map<String, dynamic> with all columns
          }
        }
        final patients = await db.query('patients'); // query all rows
        if (patients.isEmpty) {
          print('____No patients found in the database.');
        } else {
          print('____patients table rows:');
          for (var pat in patients) {
            print(pat); // Each doc is a Map<String, dynamic> with all columns
          }
        }
      },
    );

    return _database!;
  }

  /// -----------------------------
  /// New method: Get specialities with doctor count (only specialties that have doctors)
  /// -----------------------------
  Future<List<Map<String, dynamic>>> getSpecialitiesWithDoctorCount() async {
    final db = await getDatabase();
    final result = await db.rawQuery('''
      SELECT s.speciality_id, s.speciality_name, COUNT(d.doctor_id) AS doctor_count
      FROM specialities s
      INNER JOIN doctors d ON s.speciality_id = d.speciality_id
      GROUP BY s.speciality_id
      HAVING COUNT(d.doctor_id) > 0
      ORDER BY s.speciality_name
    ''');
    return result;
  }

  /// Optional: Get top N specialities
  Future<List<Map<String, dynamic>>> getTopSpecialities(int limit) async {
    final allSpecialities = await getSpecialitiesWithDoctorCount();
    return allSpecialities.take(limit).toList();
  }

  /// Get all doctors by speciality
  Future<List<Map<String, dynamic>>> getDoctorsBySpeciality(int specialityId) async {
    final db = await getDatabase();
    final result = await db.rawQuery('''
      SELECT d.doctor_id, u.firstname, u.lastname, d.location_of_work, 
             s.speciality_name, COALESCE(d.average_rating, 0.0) AS average_rating
      FROM doctors d
      JOIN users u ON d.doctor_id = u.user_id
      JOIN specialities s ON d.speciality_id = s.speciality_id
      WHERE d.speciality_id = ?
    ''', [specialityId]);
    return result;
  }
}
