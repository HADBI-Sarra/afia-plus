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
          role TEXT CHECK(role IN ('doctor','patient','admin')),
          username TEXT UNIQUE,
          firstname TEXT,
          lastname TEXT,
          email TEXT UNIQUE,
          password TEXT,
          phone_number TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE patients (
          patient_id INTEGER PRIMARY KEY,
          date_of_birth TEXT,
          age INTEGER,
          health_condition TEXT,
          FOREIGN KEY(patient_id) REFERENCES users(user_id)
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
          years_experience INTEGER,
          location_of_work TEXT,
          description TEXT,
          FOREIGN KEY(doctor_id) REFERENCES users(user_id),
          FOREIGN KEY(speciality_id) REFERENCES specialities(speciality_id)
        )
      ''');

        await db.execute('''
        CREATE TABLE doctor_availability (
          availability_id INTEGER PRIMARY KEY AUTOINCREMENT,
          doctor_id INTEGER,
          available_date TEXT,
          start_time TEXT,
          end_time TEXT,
          status TEXT CHECK(status IN ('free','booked')) DEFAULT 'free',
          FOREIGN KEY(doctor_id) REFERENCES doctors(doctor_id)
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
          end_time TEXT,
          status TEXT CHECK(status IN ('scheduled','completed','cancelled','missed')) DEFAULT 'scheduled',
          symptoms_description TEXT,
          notes_from_doctor TEXT,
          FOREIGN KEY(patient_id) REFERENCES patients(patient_id),
          FOREIGN KEY(doctor_id) REFERENCES doctors(doctor_id),
          FOREIGN KEY(availability_id) REFERENCES doctor_availability(availability_id)
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {},
    );

    return _database!;
  }
}
