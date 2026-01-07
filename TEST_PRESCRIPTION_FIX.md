# 🔧 Prescription Fetch Fix - Testing Guide

## 🐛 Issue Found and Fixed

### The Problem
The backend SQL query had the wrong foreign key reference for the doctor's user information:
- ❌ **Before**: `users!patients_patient_id_fkey` (wrong - this is for patients!)
- ✅ **After**: `users!doctors_doctor_id_fkey` (correct - for doctors!)

This caused the query to fail when trying to join doctor information with prescriptions.

---

## ✅ What Was Fixed

### File: `backend/services/consultations.service.js`
**Line 216**: Changed the foreign key reference in the `getPatientPrescriptions` method

```javascript
// OLD (WRONG):
user:users!patients_patient_id_fkey(

// NEW (CORRECT):
user:users!doctors_doctor_id_fkey(
```

### Added Debugging Logs
1. **Backend**: `backend/controllers/consultations.controller.js`
   - Logs when prescriptions are requested
   - Shows how many were found
   - Lists each prescription

2. **Frontend**: `frontend/lib/cubits/prescription_cubit.dart`
   - Logs when loading starts
   - Shows how many prescriptions were loaded
   - Shows prescription paths
   - Logs errors clearly

---

## 🧪 Testing Steps

### Step 1: Restart Backend Server
```bash
cd backend
# Stop current server (Ctrl+C)
npm start
# or
node src/server.js
```

### Step 2: Verify Test Data Exists
```sql
-- Run in Supabase SQL Editor
SELECT 
  c.consultation_id,
  c.patient_id,
  c.doctor_id,
  c.consultation_date,
  c.status,
  c.prescription,
  u_patient.firstname as patient_name,
  u_doctor.firstname as doctor_name
FROM consultations c
LEFT JOIN patients p ON c.patient_id = p.patient_id
LEFT JOIN users u_patient ON p.patient_id = u_patient.user_id
LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
LEFT JOIN users u_doctor ON d.doctor_id = u_doctor.user_id
WHERE 
  c.status = 'completed'
  AND c.prescription IS NOT NULL;
```

**Expected**: Should show at least one consultation with a prescription

### Step 3: Test Backend API Directly
```powershell
# PowerShell - Replace 1 with your patient ID
curl http://localhost:3000/consultations/patient/1/prescriptions
```

**Expected Response**:
```json
{
  "success": true,
  "message": "Prescriptions retrieved successfully",
  "data": [
    {
      "consultation_id": 123,
      "prescription": "prescriptions/prescription_123.pdf",
      "doctor": {
        "user": {
          "firstname": "John",
          "lastname": "Doe"
        }
      }
    }
  ]
}
```

**Backend Console Should Show**:
```
📋 Getting prescriptions for patient: 1
✅ Found prescriptions: 1
  - Consultation 123: prescriptions/prescription_123.pdf
```

### Step 4: Test in Flutter App
1. **Restart the Flutter app** (hot restart won't reload the cubit)
2. Login as **patient**
3. Navigate to **"My Prescriptions"**
4. Check the Flutter console for logs

**Expected Flutter Console Logs**:
```
📋 Loading prescriptions for patient: 1
✅ Loaded 1 prescriptions
  - Consultation 123: prescriptions/prescription_123.pdf
```

---

## 🔍 Troubleshooting

### Issue 1: Still No Prescriptions Showing

**Check 1: Is the prescription actually uploaded?**
```sql
SELECT consultation_id, prescription 
FROM consultations 
WHERE consultation_id = YOUR_ID;
```
- If `prescription` is NULL, the upload didn't work
- Re-upload from doctor side

**Check 2: Is the status 'completed'?**
```sql
SELECT consultation_id, status 
FROM consultations 
WHERE consultation_id = YOUR_ID;
```
- Must be 'completed' to appear in prescriptions
- Update if needed: `UPDATE consultations SET status = 'completed' WHERE consultation_id = YOUR_ID;`

**Check 3: Is the patient ID correct?**
- Check what patient_id you're logged in as
- Verify it matches the consultation's patient_id

### Issue 2: Backend Returns Empty Array

**Backend logs show**:
```
📋 Getting prescriptions for patient: 1
✅ Found prescriptions: 0
```

**Solution**: Check database query conditions
```sql
-- Debug query - relaxed conditions
SELECT consultation_id, patient_id, status, prescription
FROM consultations
WHERE patient_id = 1;  -- Replace with your patient ID

-- If you see consultations but prescription is NULL
-- Upload prescription from doctor side first
```

### Issue 3: Frontend Shows Error

**Flutter console shows**:
```
❌ Error loading prescriptions: Failed to get prescriptions: ...
```

**Solutions**:
1. Check backend is running: `curl http://localhost:3000/consultations/patient/1/prescriptions`
2. Check network connection between app and backend
3. Verify API_BASE_URL in `frontend/lib/data/api/api_client.dart`

---

## 📊 Complete Test Flow

### 1. Setup (One Time)
```sql
-- Ensure test consultation exists
UPDATE consultations
SET 
  consultation_date = '2025-01-05',
  status = 'completed',
  prescription = 'prescriptions/prescription_1.pdf'  -- Simulate uploaded prescription
WHERE consultation_id = 1 AND patient_id = 1;  -- Adjust IDs
```

### 2. Backend Test
```powershell
# PowerShell
curl http://localhost:3000/consultations/patient/1/prescriptions
```

### 3. Frontend Test
- Login as patient (ID 1)
- Go to "My Prescriptions"
- Should see the consultation listed
- Click "View Prescription"

---

## ✅ Success Criteria

- [ ] Backend logs show prescriptions found
- [ ] API returns non-empty array
- [ ] Flutter console shows prescriptions loaded
- [ ] Prescriptions page shows consultation cards
- [ ] "View Prescription" button appears
- [ ] Clicking button opens PDF (or shows error if file missing)

---

## 🎯 Expected vs Actual

### Before Fix
```
❌ Backend SQL error (wrong foreign key)
❌ Empty array returned
❌ No prescriptions displayed
```

### After Fix
```
✅ Backend SQL query works correctly
✅ Prescriptions returned with doctor info
✅ Prescriptions displayed in app
✅ Can view/download PDFs
```

---

## 📝 Quick Verification Checklist

1. [ ] Restart backend server
2. [ ] Run SQL query to verify prescriptions exist in DB
3. [ ] Test API endpoint with curl
4. [ ] Check backend console logs (should show prescription count)
5. [ ] Restart Flutter app (full restart, not hot reload)
6. [ ] Login as patient
7. [ ] Navigate to "My Prescriptions"
8. [ ] Check Flutter console logs
9. [ ] Verify prescriptions are displayed
10. [ ] Test "View Prescription" button

---

## 🆘 Still Not Working?

1. **Backend logs** - Check for SQL errors or foreign key issues
2. **Database** - Verify foreign key relationships are correct
3. **Frontend logs** - Check for API call failures
4. **Network** - Ensure frontend can reach backend (check API_BASE_URL)
5. **Data** - Confirm prescriptions exist with correct status and patient_id

---

**The fix is simple but critical - just restart the backend server and test!** 🚀
