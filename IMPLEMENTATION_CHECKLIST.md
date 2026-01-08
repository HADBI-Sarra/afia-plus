# Implementation Checklist & Quick Start Guide

## ✅ COMPLETED - Backend Implementation

### Services (Business Logic)
- ✅ `doctor_availability.service.js` - 11 methods for slot management
- ✅ `consultations.service.js` - 13 methods with double-booking prevention
- ✅ Error handling and validation

### Controllers (HTTP Handlers)
- ✅ `doctor_availability.controller.js` - 7 endpoints
- ✅ `consultations.controller.js` - 10 endpoints
- ✅ Response formatting with `sendResponse()` utility

### Routes
- ✅ `doctor_availability.routes.js` - All endpoints registered
- ✅ `consultations.routes.js` - All endpoints registered
- ✅ Integrated in `app.js` with:
  ```javascript
  app.use('/availability', doctorAvailabilityRoutes);
  app.use('/consultations', consultationsRoutes);
  ```

### Database Configuration
- ✅ Supabase client configured in `src/config/supabase.js`

---

## ✅ COMPLETED - Frontend Repository Layer

### Data Access Layer
- ✅ `lib/data/api/api_client.dart` - HTTP client with error handling
- ✅ `lib/data/repo/doctor_availability/doctor_availability_abstract.dart` - Interface
- ✅ `lib/data/repo/doctor_availability/doctor_availability_impl.dart` - Implementation
- ✅ `lib/data/repo/consultations/consultations_impl.dart` - **REFACTORED to use API**
- ✅ `lib/models/doctor_availability.dart` - Model with JSON mapping

### State Management
- ✅ `lib/cubits/doctor_availability_cubit.dart` - Complete with 9 methods
- ✅ `lib/cubits/doctor_appointments_cubit.dart` - Already uses API
- ✅ `lib/cubits/user_appointments_cubit.dart` - Already uses API

---

## ⏳ TO DO - Screen Integration

### Doctor Pages (Doctor Side)

#### 1. `lib/views/screens/doctorPages/doctor_availability.dart`
**Current State:** Uses old `AvailabilityCubit`  
**Action Required:**
1. Replace import:
   ```dart
   // OLD
   import 'package:afia_plus_app/logic/cubits/availability cubit/availability_cubit.dart';
   
   // NEW
   import 'package:afia_plus_app/cubits/doctor_availability_cubit.dart';
   ```

2. Update context reads:
   ```dart
   // OLD
   context.read<AvailabilityCubit>()
   
   // NEW
   context.read<DoctorAvailabilityCubit>()
   ```

3. Update method calls to match new cubit:
   ```dart
   // OLD: loadAvailabilityForDoctor(doctorId)
   // NEW: loadDoctorAvailability(doctorId)
   
   // OLD: addMultipleAvailabilities(doctorId, date, times)
   // NEW: createMultipleSlots(doctorId, slots)
   
   // OLD: deleteAvailabilityById(availabilityId, doctorId)
   // NEW: deleteSlot(availabilityId)
   ```

4. Update state checks:
   ```dart
   // OLD
   if (state is AvailabilityLoaded) {
     slotsForDay = state.doctorAvailabilityList...
   }
   
   // NEW
   if (state is DoctorAvailabilityState) {
     slotsForDay = state.availabilitySlots
       .where((a) => a.availableDate == dateKey && a.status == 'free')
       .toList();
   }
   ```

**Estimated Time:** 20 minutes

---

#### 2. `lib/views/screens/doctorPages/manage_appointments.dart`
**Current State:** Already uses `DoctorAppointmentsCubit` (API-based) ✅  
**Action Required:**
- Minimal updates may be needed
- Verify `DoctorAppointmentsCubit` methods match new API responses
- Test consultations loading and status updates

**Estimated Time:** 10 minutes (testing)

---

### User Pages (Patient Side)

#### 3. `lib/views/screens/userPages/user_appointments.dart`
**Current State:** Already uses `UserAppointmentsCubit` (API-based) ✅  
**Action Required:**
- Verify appointment loading and deletion work with API
- Test confirmed vs pending consultations display

**Estimated Time:** 10 minutes (testing)

---

#### 4. `lib/views/screens/userPages/prescription.dart`
**Current State:** May use old methods  
**Action Required:**
1. If using consultations repository, it's already refactored ✅
2. Ensure it calls correct method:
   ```dart
   // Load prescriptions for patient
   final prescriptions = await _repository.getPatientPrescriptions(patientId);
   ```

**Estimated Time:** 5 minutes (verification)

---

## Quick Start Verification

### 1. Backend Running
```bash
# Navigate to backend directory
cd backend

# Install dependencies if not done
npm install

# Start backend
npm start
# or with nodemon for development
npm run dev
```

Expected output: `Server running on port 3000`

### 2. Test Backend Endpoints
```bash
# Check if backend is responding
curl -X GET http://localhost:3000/availability/doctor/1

# Should return JSON with status and data
```

### 3. Update Flutter API Client
Edit `/frontend/lib/data/api/api_client.dart` line 8:
```dart
// For development (same PC):
static const String baseUrl = 'http://192.168.1.7:3000';

// For Android emulator:
// static const String baseUrl = 'http://10.0.2.2:3000';

// For web:
// static const String baseUrl = 'http://localhost:3000';
```

### 4. Run Flutter Tests
```bash
flutter pub get
flutter run
```

### 5. Verify in App
1. Doctor navigates to "Schedule Availability"
2. Creates a time slot
3. Verify API call succeeds (check network tab in Flutter DevTools)
4. Slot appears in list immediately

---

## Common Issues & Solutions

### Issue 1: "Connection refused" on API calls
**Cause:** Backend not running or wrong IP address  
**Solution:**
1. Check backend is running: `npm start`
2. Verify IP address: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
3. Update `api_client.dart` with correct IP

### Issue 2: "Failed to parse response"
**Cause:** Backend returning invalid JSON  
**Solution:**
1. Check backend error logs
2. Verify request payload matches expected format
3. Ensure response has `data` field

### Issue 3: "Double-booking still occurring"
**Cause:** Frontend booking before slot status updated  
**Solution:**
1. The backend prevents actual double-booking
2. Refresh slot list after booking
3. Check network latency

### Issue 4: Cubits not updating UI
**Cause:** Not properly integrated with BlocProvider  
**Solution:**
1. Wrap screen with `BlocProvider<DoctorAvailabilityCubit>()`
2. Use `BlocBuilder` for rebuilds
3. Verify cubit methods are async

---

## Integration Sequence

### Phase 1: Backend Verification (30 min)
1. Start backend server
2. Test each endpoint with cURL or Postman
3. Verify Supabase connection
4. Check error handling

### Phase 2: Doctor Availability Screen (1 hour)
1. Update `doctor_availability.dart`
2. Test slot creation
3. Test slot deletion
4. Test date filtering

### Phase 3: Doctor Appointments Screen (30 min)
1. Verify consultations loading
2. Test status updates
3. Test acceptance/rejection flow
4. Test prescription display

### Phase 4: User Appointments Screen (30 min)
1. Verify appointment booking
2. Test pending vs confirmed display
3. Test cancellation
4. Test prescription view

### Phase 5: Full Integration Testing (1 hour)
1. End-to-end booking flow (patient → doctor → completion)
2. Multiple doctors/patients
3. Date filtering
4. Offline scenario handling (optional)

---

## Database Queries Reference

### View All Available Slots
```sql
SELECT * FROM doctor_availability 
WHERE status = 'free' 
ORDER BY available_date, start_time;
```

### View Booked Consultations
```sql
SELECT c.*, u.firstname, u.lastname
FROM consultations c
JOIN users u ON c.patient_id = u.user_id
WHERE c.status IN ('pending', 'scheduled');
```

### Check for Double Booking
```sql
SELECT * FROM doctor_availability 
WHERE status = 'booked' 
AND availability_id IN (
  SELECT availability_id FROM consultations 
  WHERE status IN ('scheduled', 'pending')
);
```

---

## Performance Optimization Tips

1. **Pagination:** Add limit/offset for large lists
   ```dart
   // GET /consultations/doctor/1?limit=20&offset=0
   ```

2. **Caching:** Implement local cache for frequently accessed data
   ```dart
   final List<DoctorAvailability>? _cache;
   ```

3. **Debouncing:** Debounce filter requests
   ```dart
   Timer? _filterTimer;
   ```

4. **Batch Operations:** Use bulk endpoints for multiple creates
   ```dart
   await _repository.bulkCreateSlots(doctorId, slots);
   ```

---

## Testing Checklist

- [ ] Backend starts without errors
- [ ] All API endpoints respond with correct format
- [ ] Doctor can create availability slot
- [ ] Doctor can delete availability slot
- [ ] Patient can see available slots
- [ ] Patient can book consultation
- [ ] Double-booking is prevented
- [ ] Doctor receives booking request
- [ ] Doctor can accept/reject consultation
- [ ] Consultation status updates correctly
- [ ] Slot is freed when consultation cancelled
- [ ] Prescription can be added
- [ ] Patient can view prescriptions
- [ ] All cubits update UI correctly
- [ ] Error messages display properly
- [ ] Network timeouts handled gracefully

---

## File Dependencies

### Doctor Availability Implementation Chain
```
doctor_availability.dart (Screen)
    ↓
DoctorAvailabilityCubit
    ↓
DoctorAvailabilityImpl (Repository)
    ↓
ApiClient
    ↓
Backend: /availability endpoints
    ↓
DoctorAvailabilityService
    ↓
Supabase: doctor_availability table
```

### Consultations Implementation Chain
```
manage_appointments.dart (Screen)
    ↓
DoctorAppointmentsCubit
    ↓
ConsultationsImpl (Repository)
    ↓
ApiClient
    ↓
Backend: /consultations endpoints
    ↓
ConsultationsService
    ↓
Supabase: consultations table + relations
```

---

## Code Examples

### Create Multiple Slots (Doctor)
```dart
// In doctor_availability.dart
final slotsToCreate = [
  {'date': '2024-01-15', 'startTime': '09:00'},
  {'date': '2024-01-15', 'startTime': '10:00'},
  {'date': '2024-01-15', 'startTime': '11:00'},
];

await context.read<DoctorAvailabilityCubit>()
  .createMultipleSlots(_doctorId, slotsToCreate);
```

### Book Consultation (Patient)
```dart
// In booking screen
final consultation = await _repository.createConsultation(
  Consultation(
    patientId: _patientId,
    doctorId: doctorId,
    availabilityId: availabilityId,
    consultationDate: selectedDate,
    startTime: selectedTime,
    status: 'pending',
  ),
);
```

### Update Consultation Status (Doctor)
```dart
// Accept pending consultation
await context.read<DoctorAppointmentsCubit>()
  .acceptAppointment(consultationId, _doctorId);
```

---

## Next Steps After Screen Integration

1. **Add Input Validation**
   - Validate dates are not in past
   - Validate times are within business hours
   - Validate required fields

2. **Add Loading States**
   - Show spinners during API calls
   - Disable buttons during processing

3. **Add Error Handling**
   - Show snackbars for errors
   - Retry logic for failed requests

4. **Add Notifications** (Optional)
   - Notify doctor of new booking requests
   - Notify patient of acceptance/rejection

5. **Add Offline Support** (Optional)
   - Queue requests when offline
   - Sync when back online

---

## Support & Debugging

### Enable Network Logging
```dart
// In main.dart, add before runApp:
HttpClient.enableTimelineLogging = true;
```

### Check API Response
```dart
// Add print in ApiClient._handleResponse:
print('Response: ${response.body}');
```

### Monitor Cubit State
```dart
// In screen:
BlocListener<DoctorAvailabilityCubit, DoctorAvailabilityState>(
  listener: (context, state) {
    print('State changed: $state');
  },
)
```

---

**Last Updated:** 2026-01-02  
**Implementation Status:** 73% Complete (Backend ✅ | Repos ✅ | Screens ⏳)  
**Estimated Completion:** 2-3 hours
