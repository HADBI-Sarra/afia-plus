# Quick Start Guide - Database Seeding

## ✅ Automatic Database Seeding

**Good news!** The database is now **automatically seeded** when you first run the app. 

### What happens automatically:

1. **On first app launch**, the database is automatically populated with:
   - 1 Patient user (Besmala Boukenouche)
   - 6 Doctor users (matching original static data)
   - 7 Consultations:
     - 2 Confirmed (scheduled) appointments
     - 2 Not Confirmed (pending) appointments  
     - 3 Completed consultations with prescriptions

2. **All screens will now show data:**
   - ✅ User Appointments: Shows confirmed and pending appointments
   - ✅ Prescriptions: Shows 3 prescriptions
   - ✅ Patient Home: Shows upcoming consultations
   - ✅ Doctor screens: Show appointments

### Manual Seeding (if needed):

If you need to reset or re-seed the database:

1. **Option 1: Use Verification Screen**
   - Navigate to `/db-verify` route
   - Click "Insert Test Data" button
   - Click "Verify Database" to see the data

2. **Option 2: Uninstall and Reinstall**
   - Uninstall the app
   - Reinstall - database will auto-seed on first launch

### Important Note About Patient ID:

The patient ID is currently **hardcoded as `1`** in the cubits. If your database uses a different patient ID:

1. Check the patient ID in the verification screen
2. Update these files with the correct patient ID:
   - `lib/views/screens/userPages/prescription.dart` (line ~15)
   - `lib/views/screens/userPages/user_appointments.dart` (line ~9)
   - `lib/views/screens/homescreen/patient_home_screen.dart` (line ~16)

Or use the `DBSeeder.getPatientId()` function to get it dynamically.

### Testing:

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Check the screens:**
   - User Appointments page → Should show 2 confirmed + 2 pending
   - Prescriptions page → Should show 3 prescriptions
   - Patient Home → Should show upcoming consultations

3. **Verify database:**
   - Navigate to `/db-verify` route
   - Click "Verify Database" to see all data

### Data Structure:

**Confirmed Appointments (scheduled):**
- Dr. Mohamed Brahimi - 12 Nov, 12:00 - 12:45
- Dr. Righi Sirine - 13 Nov, 10:00 - 10:30

**Not Confirmed Appointments (pending):**
- Dr. Boukenouche Lamis - 15 Nov, 12:00 - 12:45
- Dr. Medouar Abdelilah - 16 Nov, 12:00 - 12:45

**Prescriptions:**
- Dr. Brahimi Mohamed - 18 September, 2025
- Dr. Lakhal Amine - 17 March, 2025
- Dr. Moussaoui Samia - 02 January, 2025

---

**Everything is ready!** Just run the app and the data will be there automatically! 🎉

