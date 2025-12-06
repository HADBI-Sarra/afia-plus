import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _databaseName = "AFIA_PLUS_DB.db";
  static const _databaseVersion = 1;
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onCreate: (db, version) async {
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

        await db.execute('''
        CREATE TABLE patients (
          patient_id INTEGER PRIMARY KEY,
          date_of_birth TEXT,
          FOREIGN KEY(patient_id) REFERENCES users(user_id) ON DELETE CASCADE
        )
        ''');

        await db.execute('''
        CREATE TABLE specialities (
          speciality_id INTEGER PRIMARY KEY AUTOINCREMENT,
          speciality_name TEXT UNIQUE
        )
        ''');

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
      onUpgrade: (db, oldVersion, newVersion) async {},
    );

    return _database!;
  }
}
