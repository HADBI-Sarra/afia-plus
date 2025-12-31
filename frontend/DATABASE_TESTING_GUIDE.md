# Database Testing Guide

## How to Verify Database Usage

### Method 1: Using the Verification Screen (Recommended)

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Navigate to the verification screen:**
   - In your app, navigate to: `/db-verify`
   - Or temporarily change `main.dart` line 32 to:
     ```dart
     home: DBVerificationScreen(),
     ```

3. **Insert Test Data:**
   - Click the "Insert Test Data" button
   - This will create:
     - 1 Patient user (Besmala Boukenouche)
     - 1 Doctor user (Mohamed Brahimi)
     - 3 Consultations:
       - 1 Scheduled (upcoming)
       - 1 Completed (with prescription)
       - 1 Pending (not confirmed)

4. **Verify Database:**
   - Click the "Verify Database" button
   - You should see all tables and their data

### Method 2: Check Database File Directly

1. **Find the database file location:**
   - The database is stored at: `AFIA_PLUS_DB.db`
   - On Android: `/data/data/com.example.afia_plus_app/databases/AFIA_PLUS_DB.db`
   - You can use Android Studio's Device File Explorer to view it

2. **Use SQLite Browser:**
   - Download DB Browser for SQLite: https://sqlitebrowser.org/
   - Open the database file
   - Browse tables: `users`, `consultations`, `doctors`, `patients`, etc.

### Method 3: Test Through App Screens

1. **After inserting test data:**
   - Go to **User Appointments** screen
   - You should see:
     - **Confirmed Appointments**: 1 scheduled consultation
     - **Not Confirmed Appointments**: 1 pending consultation

2. **Check Prescriptions:**
   - Go to **Prescriptions** screen
   - You should see 1 prescription from the completed consultation

3. **Check Doctor Appointments:**
   - Go to **Manage Appointments** screen (as doctor)
   - You should see:
     - **Upcoming Appointments**: 1 scheduled + 1 pending
     - **Past Appointments**: 1 completed

4. **Check Home Screens:**
   - **Patient Home**: Should show upcoming consultations
   - **Doctor Home**: Should show coming and pending consultations

### Method 4: Add Debug Logging

Add this to any cubit to see database queries:

```dart
print('🔍 Loading consultations from database...');
final consultations = await _repository.getPatientConsultations(patientId);
print('✅ Loaded ${consultations.length} consultations');
```

## Expected Database Structure

### Tables Created:
- `users` - User accounts (doctors and patients)
- `patients` - Patient-specific data
- `doctors` - Doctor-specific data
- `specialities` - Medical specialties
- `doctor_availability` - Available time slots
- `consultations` - Appointment records
- `doctor_reviews` - Reviews and ratings

### Test Data IDs:
- **Patient ID**: 1 (Besmala Boukenouche)
- **Doctor ID**: 1 (Mohamed Brahimi)

**Note:** Update these IDs in the cubits if your test data has different IDs.

## Troubleshooting

### If screens show "No data":
1. Make sure you've inserted test data using the verification screen
2. Check that patient/doctor IDs match (currently hardcoded as `1`)
3. Verify database file exists and has data

### If you see errors:
1. Run `flutter clean` then `flutter pub get`
2. Check that `sqflite` is properly installed
3. Verify database initialization in `db_helper.dart`

### To reset database:
1. Uninstall the app from your device/emulator
2. Reinstall - this will recreate the database
3. Or use the verification screen's "Clear Test Data" (if implemented)

## Quick Test Checklist

- [ ] Database file is created on first run
- [ ] Test data can be inserted
- [ ] User Appointments screen shows data
- [ ] Prescriptions screen shows data
- [ ] Doctor Appointments screen shows data
- [ ] Home screens show consultations
- [ ] Accept/Reject buttons work (updates database)
- [ ] Delete appointment works (removes from database)
- [ ] PDF upload works (updates prescription in database)

## Verification Commands

```bash
# Check for compilation errors
flutter analyze

# Run the app
flutter run

# Check database file (Android)
adb shell
run-as com.example.afia_plus_app
cd databases
ls -la AFIA_PLUS_DB.db
```

