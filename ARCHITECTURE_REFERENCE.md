# Supabase Migration - Quick Reference & Architecture

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        FLUTTER FRONTEND                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────────┐          ┌──────────────────────┐    │
│  │   UI Screens         │          │   UI Screens         │    │
│  │ doctor_availability  │          │ manage_appointments  │    │
│  │ user_appointments    │          │ prescription         │    │
│  └────────────┬─────────┘          └──────────┬───────────┘    │
│               │                               │                 │
│  ┌────────────▼─────────────────────────────▼──────────────┐   │
│  │              BLoC / Cubits (State Management)           │   │
│  │  ┌──────────────────────────────────────────────────┐   │   │
│  │  │ DoctorAvailabilityCubit                          │   │   │
│  │  │ DoctorAppointmentsCubit                          │   │   │
│  │  │ UserAppointmentsCubit                            │   │   │
│  │  └──────────────────────────────────────────────────┘   │   │
│  └────────────┬────────────────────────────────────────────┘   │
│               │                                                 │
│  ┌────────────▼─────────────────────────────────────────────┐  │
│  │           Repository Layer (Data Access)               │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ DoctorAvailabilityImpl (Interface)               │  │  │
│  │  │ ConsultationsImpl (API-based)                    │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  └────────────┬─────────────────────────────────────────────┘  │
│               │                                                 │
│  ┌────────────▼─────────────────────────────────────────────┐  │
│  │        API Client Service (HTTP Layer)                 │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ ApiClient.get/post/put/delete()                │  │  │
│  │  │ Error handling, timeout, response parsing      │  │  │
│  │  │ Base URL: http://192.168.1.7:3000              │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  └────────────┬─────────────────────────────────────────────┘  │
│               │                                                 │
└───────────────┼─────────────────────────────────────────────────┘
                │ HTTP
                │
┌───────────────▼─────────────────────────────────────────────────┐
│                   NODE.JS BACKEND (Express)                      │
├───────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │               API Routes & Controllers                   │   │
│  │  ┌─────────────────┐      ┌─────────────────────────┐   │   │
│  │  │ /availability   │      │ /consultations          │   │   │
│  │  │ GET, POST,      │      │ GET, POST, PUT, DELETE  │   │   │
│  │  │ PUT, DELETE     │      │                         │   │   │
│  │  └────────┬────────┘      └────────────┬────────────┘   │   │
│  └───────────┼──────────────────────────┬─────────────────┘   │
│              │                          │                      │
│  ┌───────────▼──────────────────────────▼─────────────────┐   │
│  │           Service Layer (Business Logic)              │   │
│  │  ┌──────────────────────────────────────────────────┐ │   │
│  │  │ DoctorAvailabilityService                        │ │   │
│  │  │ ✓ Slot creation & deletion                       │ │   │
│  │  │ ✓ Status management (free/booked)                │ │   │
│  │  │ ✓ Date range queries                             │ │   │
│  │  │ ✓ Bulk operations                                │ │   │
│  │  └──────────────────────────────────────────────────┘ │   │
│  │  ┌──────────────────────────────────────────────────┐ │   │
│  │  │ ConsultationsService                             │ │   │
│  │  │ ✓ Book consultation (atomic)                     │ │   │
│  │  │ ✓ Double-booking prevention                      │ │   │
│  │  │ ✓ Status transitions (pending→scheduled→completed) │   │
│  │  │ ✓ Prescription management                        │ │   │
│  │  │ ✓ Slot release on cancellation                   │ │   │
│  │  └──────────────────────────────────────────────────┘ │   │
│  └──────────────────────┬──────────────────────────────────┘   │
│                         │                                       │
│  ┌──────────────────────▼───────────────────────────────────┐  │
│  │          Supabase Client Connection                     │  │
│  │  ✓ Service Role Authentication                         │  │
│  │  ✓ PostgreSQL Connection Pool                          │  │
│  └──────────────────────┬───────────────────────────────────┘  │
│                         │                                       │
└─────────────────────────┼───────────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────────┐
│                      SUPABASE (PostgreSQL)                       │
├───────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────┐          ┌──────────────────────────────┐ │
│  │ doctor_          │          │ consultations                │ │
│  │ availability     │          │ ┌──────────────────────────┐│ │
│  │ ┌──────────────┐ │          │ │ consultation_id (PK)    ││ │
│  │ │availability_ │ │          │ │ patient_id (FK)         ││ │
│  │ │id (PK)       │ │          │ │ doctor_id (FK)          ││ │
│  │ │doctor_id (FK)│ │          │ │ availability_id (FK/UQ) ││ │
│  │ │available_date│ │          │ │ consultation_date       ││ │
│  │ │start_time    │ │          │ │ start_time              ││ │
│  │ │status        │ │          │ │ status (enum)           ││ │
│  │ │ (free/booked)│ │          │ │ prescription            ││ │
│  │ └──────────────┘ │          │ └──────────────────────────┘│ │
│  └──────────────────┘          └──────────────────────────────┘ │
│                                                                   │
│  Indexes:                  |  Constraints:                       │
│  • doctor_id + date        |  • Foreign Key: doctor_id          │
│  • status + date           |  • Foreign Key: patient_id         │
│  • doctor_id + status      |  • Foreign Key: availability_id    │
│                            |  • CHECK status values             │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

---

## API Endpoints Summary

### Doctor Availability Endpoints

| Method | Endpoint | Purpose | Request | Response |
|--------|----------|---------|---------|----------|
| GET | `/availability/doctor/{id}` | Get all slots | - | `List[DoctorAvailability]` |
| GET | `/availability/doctor/{id}/range` | Get by date range | `?startDate=X&endDate=Y` | `List[DoctorAvailability]` |
| GET | `/availability/doctor/{id}/free` | Get free slots | `?date=X` | `List[DoctorAvailability]` |
| POST | `/availability` | Create slot | `{doctorId, availableDate, startTime}` | `DoctorAvailability` |
| POST | `/availability/bulk` | Bulk create | `{doctorId, slots[]}` | `List[DoctorAvailability]` |
| PUT | `/availability/{id}/status` | Update status | `{status}` | `DoctorAvailability` |
| DELETE | `/availability/{id}` | Delete slot | - | `{}` |

### Consultations Endpoints

| Method | Endpoint | Purpose | Request | Response |
|--------|----------|---------|---------|----------|
| POST | `/consultations/book` | **Book appointment** | `{patientId, doctorId, availabilityId, consultationDate, startTime}` | `Consultation` |
| GET | `/consultations/patient/{id}` | All patient consultations | - | `List[ConsultationWithDetails]` |
| GET | `/consultations/patient/{id}/confirmed` | Confirmed only | - | `List[ConsultationWithDetails]` |
| GET | `/consultations/patient/{id}/pending` | Pending only | - | `List[ConsultationWithDetails]` |
| GET | `/consultations/patient/{id}/prescriptions` | With prescriptions | - | `List[ConsultationWithDetails]` |
| GET | `/consultations/doctor/{id}` | All doctor consultations | - | `List[ConsultationWithDetails]` |
| GET | `/consultations/doctor/{id}/upcoming` | Upcoming only | - | `List[ConsultationWithDetails]` |
| GET | `/consultations/doctor/{id}/past` | Completed only | - | `List[ConsultationWithDetails]` |
| PUT | `/consultations/{id}/status` | Update status | `{status}` | `Consultation` |
| PUT | `/consultations/{id}/cancel` | Cancel consultation | - | `Consultation` |
| PUT | `/consultations/{id}/complete` | Mark completed | - | `Consultation` |
| POST | `/consultations/{id}/prescription` | Add prescription | `{prescription}` | `Consultation` |
| DELETE | `/consultations/{id}` | Delete consultation | - | `{}` |

---

## Key Features Implemented

### ✅ Double-Booking Prevention
**Implementation:** Backend atomic transaction
```
1. Check if availability_id slot status = 'free'
2. If booked → Reject
3. If free → Create consultation + Update slot to 'booked'
4. If update fails → Rollback consultation
```

### ✅ Status Transitions
**Consultation Lifecycle:**
```
pending (awaiting doctor) 
  ↓ (doctor accepts)
scheduled (confirmed appointment)
  ↓ (after appointment)
completed (finished)
OR cancelled (rejected/cancelled)
```

**Slot Lifecycle:**
```
free (available)
  ↓ (booked by patient)
booked (unavailable)
  ↓ (cancelled)
free (available again)
```

### ✅ Nested Data Relations
Backend returns related data:
- Consultation includes doctor info, speciality, ratings
- Consultation includes patient info, phone
- Automatic joins on database layer

### ✅ Error Handling
- API exceptions with status codes
- Descriptive error messages
- Timeout management
- Request validation

### ✅ State Management
- Cubits track loading, data, errors
- Processing sets prevent duplicate operations
- Optimistic UI updates

---

## Model Structure

### DoctorAvailability
```dart
class DoctorAvailability {
  final int? availabilityId;
  final int doctorId;
  final String availableDate;    // YYYY-MM-DD
  final String startTime;         // HH:MM
  final String status;            // 'free' | 'booked'
}
```

### Consultation
```dart
class Consultation {
  final int? consultationId;
  final int patientId;
  final int doctorId;
  final int? availabilityId;
  final String consultationDate;   // YYYY-MM-DD
  final String startTime;          // HH:MM
  final String status;             // 'pending'|'scheduled'|'completed'|'cancelled'
  final String? prescription;
}
```

### ConsultationWithDetails
```dart
class ConsultationWithDetails {
  final Consultation consultation;
  final String? doctorFirstName;
  final String? doctorLastName;
  final String? doctorSpecialty;
  final String? patientFirstName;
  final String? patientLastName;
  final String? doctorImagePath;
  final String? doctorPhoneNumber;
  final String? patientPhoneNumber;
}
```

---

## Configuration Checklist

- [ ] Supabase project created
- [ ] Environment variables set (`.env`):
  - [ ] `SUPABASE_URL`
  - [ ] `SUPABASE_SERVICE_ROLE_KEY`
- [ ] Backend running on port 3000
- [ ] Flutter API client base URL configured
- [ ] Cubits registered in service locator (if using)
- [ ] Network permissions configured (Android/iOS)
- [ ] Tests running successfully

---

## Testing Endpoints (cURL Examples)

### Create Availability Slot
```bash
curl -X POST http://localhost:3000/availability \
  -H "Content-Type: application/json" \
  -d '{
    "doctorId": 1,
    "availableDate": "2024-01-15",
    "startTime": "09:00"
  }'
```

### Book Consultation (Prevents Double-Booking)
```bash
curl -X POST http://localhost:3000/consultations/book \
  -H "Content-Type: application/json" \
  -d '{
    "patientId": 5,
    "doctorId": 1,
    "availabilityId": 10,
    "consultationDate": "2024-01-15",
    "startTime": "09:00"
  }'
```

### Get Free Slots for Date
```bash
curl -X GET "http://localhost:3000/availability/doctor/1/free?date=2024-01-15" \
  -H "Content-Type: application/json"
```

### Update Consultation Status
```bash
curl -X PUT http://localhost:3000/consultations/5/status \
  -H "Content-Type: application/json" \
  -d '{"status": "scheduled"}'
```

---

## File Structure Summary

```
backend/
├── services/
│   ├── doctor_availability.service.js    ✅ NEW
│   └── consultations.service.js          ✅ NEW
├── controllers/
│   ├── doctor_availability.controller.js ✅ NEW
│   └── consultations.controller.js       ✅ NEW
├── routes/
│   ├── doctor_availability.routes.js     ✅ NEW
│   └── consultations.routes.js           ✅ NEW
└── src/
    ├── app.js                            ✅ UPDATED
    └── config/
        └── supabase.js                   ✅ EXISTING

frontend/
├── lib/
│   ├── data/
│   │   ├── api/
│   │   │   └── api_client.dart           ✅ EXISTING
│   │   └── repo/
│   │       ├── doctor_availability/
│   │       │   ├── doctor_availability_abstract.dart    ✅ UPDATED
│   │       │   └── doctor_availability_impl.dart        ✅ UPDATED
│   │       └── consultations/
│   │           ├── consultations_abstract.dart  ✅ EXISTING
│   │           └── consultations_impl.dart      ✅ UPDATED
│   ├── models/
│   │   └── doctor_availability.dart      ✅ NEW
│   ├── cubits/
│   │   ├── doctor_availability_cubit.dart           ✅ NEW
│   │   ├── doctor_appointments_cubit.dart           ✅ USING API
│   │   └── user_appointments_cubit.dart             ✅ USING API
│   └── views/screens/
│       ├── doctorPages/
│       │   ├── doctor_availability.dart    ⏳ TO UPDATE
│       │   └── manage_appointments.dart    ⏳ TO UPDATE
│       └── userPages/
│           ├── user_appointments.dart      ⏳ TO UPDATE
│           └── prescription.dart           ⏳ TO UPDATE
```

---

## Professional Notes

### Why This Architecture?

1. **Separation of Concerns:**
   - Services handle database operations
   - Controllers handle HTTP requests/responses
   - Repositories abstract backend communication
   - Cubits manage UI state

2. **Scalability:**
   - Easy to add new endpoints
   - Easy to modify business logic
   - Can add caching layer later

3. **Testability:**
   - Services can be unit tested
   - Repositories can be mocked
   - Cubits can be tested with mock repositories

4. **Maintainability:**
   - Clear code organization
   - Single responsibility principle
   - Consistent patterns throughout

5. **Safety:**
   - Double-booking prevention
   - Transaction rollback on failure
   - Input validation

---

**Created:** 2026-01-02  
**Status:** Backend & Repository Tier ✅ | Screen Integration ⏳
