# Code Examples & Integration Guide

## Quick Reference for Developers

### 1. Creating Availability Slots

#### From Doctor's Screen
```dart
// Example: Doctor creates 3 slots for a date
final slotsToCreate = [
  {'date': '2024-01-15', 'startTime': '09:00'},
  {'date': '2024-01-15', 'startTime': '10:00'},
  {'date': '2024-01-15', 'startTime': '11:00'},
];

// Using the cubit
await context.read<DoctorAvailabilityCubit>()
    .createMultipleSlots(_doctorId, slotsToCreate);

// Or single slot
await context.read<DoctorAvailabilityCubit>()
    .createAvailabilitySlot(_doctorId, '2024-01-15', '09:00');
```

#### Backend Response (Success)
```json
{
  "status": 201,
  "message": "Slots created successfully",
  "data": [
    {
      "availability_id": 1,
      "doctor_id": 1,
      "available_date": "2024-01-15",
      "start_time": "09:00",
      "status": "free"
    }
  ]
}
```

---

### 2. Booking Consultation (Double-Booking Prevention)

#### Patient Books Appointment
```dart
// Patient selects a slot and books
final consultation = await _consultationsRepository.createConsultation(
  Consultation(
    patientId: _patientId,
    doctorId: doctorId,
    availabilityId: slotId,
    consultationDate: '2024-01-15',
    startTime: '09:00',
    status: 'pending',
  ),
);

// What happens on backend:
// 1. Check if availability_id.status = 'free'
// 2. If 'booked' → return error
// 3. If 'free' → Create consultation + Update slot to 'booked' (atomic)
// 4. If update fails → Rollback (no orphaned consultation)
```

#### Success Response
```json
{
  "status": 201,
  "message": "Consultation booked successfully",
  "data": {
    "consultation_id": 5,
    "patient_id": 2,
    "doctor_id": 1,
    "availability_id": 1,
    "consultation_date": "2024-01-15",
    "start_time": "09:00",
    "status": "pending"
  }
}
```

#### Error Response (Double-Booking)
```json
{
  "status": 500,
  "message": "This slot has already been booked"
}
```

---

### 3. Doctor Accepting Consultation

#### Doctor Reviews Request
```dart
// Doctor sees pending consultation request
await context.read<DoctorAppointmentsCubit>()
    .acceptAppointment(consultationId, doctorId);

// Or using repository directly
await _consultationsRepository.updateConsultationStatus(
  consultationId,
  'scheduled',
);
```

#### Status Transitions
```
pending (awaiting doctor response)
  ↓ (doctor accepts)
scheduled (confirmed)
  ↓ (after meeting)
completed (done, can add prescription)

OR

pending 
  ↓ (doctor rejects)
cancelled
```

---

### 4. Adding Prescription After Consultation

#### Doctor Adds Prescription
```dart
// After completing the consultation
await _consultationsRepository.updateConsultationPrescription(
  consultationId,
  'Take 2 tablets of paracetamol twice daily for 5 days',
);

// Or via endpoint
await ApiClient.post(
  '/consultations/$consultationId/prescription',
  body: {'prescription': prescriptionText},
);
```

---

### 5. Getting Consultations

#### Patient Views Confirmed Appointments
```dart
// Get only confirmed appointments
final confirmed = await _consultationsRepository
    .getConfirmedPatientConsultations(_patientId);

// confirmed will have ConsultationWithDetails objects with:
// - Doctor name, phone, image, specialty
// - Consultation date, time, status
// - Prescription (if any)
```

#### Doctor Views Upcoming Appointments
```dart
// Get only upcoming consultations
final upcoming = await _consultationsRepository
    .getUpcomingDoctorConsultations(_doctorId);

// upcoming will include:
// - Patient names, phone numbers
// - Consultation date, time
// - Current status (pending/scheduled)
```

---

### 6. Cubit Usage in Screens

#### Example: Doctor Availability Screen
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/cubits/doctor_availability_cubit.dart';

class DoctorAvailabilityScreen extends StatefulWidget {
  @override
  State<DoctorAvailabilityScreen> createState() => _State();
}

class _State extends State<DoctorAvailabilityScreen> {
  late int _doctorId;

  @override
  void initState() {
    super.initState();
    _doctorId = /* get from auth cubit */;
    
    // Load initial availability
    context.read<DoctorAvailabilityCubit>()
        .loadDoctorAvailability(_doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorAvailabilityCubit, DoctorAvailabilityState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }

        // Display availability slots
        return ListView(
          children: state.availabilitySlots.map((slot) {
            final isProcessing = state.processingSlotIds.contains(
              slot.availabilityId,
            );
            
            return ListTile(
              title: Text('${slot.availableDate} at ${slot.startTime}'),
              subtitle: Text('Status: ${slot.status}'),
              trailing: isProcessing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          _deleteSlot(slot.availabilityId),
                    ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _deleteSlot(int slotId) async {
    await context.read<DoctorAvailabilityCubit>()
        .deleteSlot(slotId);
  }
}
```

---

### 7. Error Handling Examples

#### Try-Catch Pattern
```dart
try {
  await _consultationsRepository.bookConsultation(...);
  
  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Booking successful!')),
  );
} on ApiException catch (e) {
  // Handle API errors
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: ${e.message}'),
      backgroundColor: Colors.red,
    ),
  );
} catch (e) {
  // Handle other errors
  print('Unexpected error: $e');
}
```

#### Cubit Error Handling
```dart
BlocListener<DoctorAvailabilityCubit, DoctorAvailabilityState>(
  listener: (context, state) {
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              context.read<DoctorAvailabilityCubit>()
                  .clearError();
            },
          ),
        ),
      );
    }
  },
  child: /* your widget */,
)
```

---

### 8. API Client Usage

#### Direct HTTP Call (Advanced)
```dart
// GET request
final response = await ApiClient.get('/availability/doctor/1');
final slots = (response['data'] as List)
    .map((s) => DoctorAvailability.fromJson(s))
    .toList();

// POST request
final response = await ApiClient.post(
  '/consultations/book',
  body: {
    'patientId': 2,
    'doctorId': 1,
    'availabilityId': 10,
    'consultationDate': '2024-01-15',
    'startTime': '09:00',
  },
);

// PUT request
await ApiClient.put(
  '/consultations/5/status',
  body: {'status': 'completed'},
);

// DELETE request
await ApiClient.delete('/availability/10');
```

---

### 9. Testing Endpoints with cURL

#### Create Slot
```bash
curl -X POST http://localhost:3000/availability \
  -H "Content-Type: application/json" \
  -d '{
    "doctorId": 1,
    "availableDate": "2024-01-15",
    "startTime": "09:00"
  }'
```

#### Get Free Slots
```bash
curl -X GET "http://localhost:3000/availability/doctor/1/free?date=2024-01-15" \
  -H "Content-Type: application/json"
```

#### Book Consultation
```bash
curl -X POST http://localhost:3000/consultations/book \
  -H "Content-Type: application/json" \
  -d '{
    "patientId": 2,
    "doctorId": 1,
    "availabilityId": 1,
    "consultationDate": "2024-01-15",
    "startTime": "09:00"
  }'
```

#### Update Status
```bash
curl -X PUT http://localhost:3000/consultations/5/status \
  -H "Content-Type: application/json" \
  -d '{"status": "scheduled"}'
```

#### Get Upcoming
```bash
curl -X GET http://localhost:3000/consultations/doctor/1/upcoming \
  -H "Content-Type: application/json"
```

---

### 10. Model Examples

#### DoctorAvailability Model
```dart
final slot = DoctorAvailability(
  availabilityId: 1,
  doctorId: 5,
  availableDate: '2024-01-15',
  startTime: '09:00',
  status: 'free',
);

// Convert to JSON for API
final json = slot.toJson();
// Result: {
//   "availability_id": 1,
//   "doctor_id": 5,
//   "available_date": "2024-01-15",
//   "start_time": "09:00",
//   "status": "free"
// }

// Create from API response
final slotFromApi = DoctorAvailability.fromJson({
  'availability_id': 1,
  'doctor_id': 5,
  'available_date': '2024-01-15',
  'start_time': '09:00',
  'status': 'free',
});

// Make a copy with changes
final bookedSlot = slot.copyWith(status: 'booked');
```

#### Consultation Model
```dart
final consultation = Consultation(
  consultationId: 5,
  patientId: 2,
  doctorId: 1,
  availabilityId: 10,
  consultationDate: '2024-01-15',
  startTime: '09:00',
  status: 'pending',
  prescription: null,
);

// Convert to map for API
final map = consultation.toMap();
```

---

## Integration Flow Diagram

```
User Interface (Screens)
         ↓
   Cubit Layer
    ├─ DoctorAvailabilityCubit
    ├─ DoctorAppointmentsCubit  
    └─ UserAppointmentsCubit
         ↓
   Repository Layer
    ├─ DoctorAvailabilityImpl
    └─ ConsultationsImpl
         ↓
   API Client Layer
    └─ ApiClient.get/post/put/delete
         ↓
   Network (HTTP)
    ↓ POST /availability/book
    ↓ GET /consultations/pending
         ↓
   Backend (Express.js)
    ├─ Controllers (handle requests)
    ├─ Services (business logic)
    └─ Database (Supabase)
```

---

## Common Patterns

### 1. Load Data on Screen Init
```dart
@override
void initState() {
  super.initState();
  context.read<DoctorAvailabilityCubit>()
      .loadDoctorAvailability(_doctorId);
}
```

### 2. Handle Loading State
```dart
if (state.isLoading) {
  return LoadingWidget();
}
```

### 3. Handle Error State
```dart
if (state.error != null) {
  return ErrorWidget(message: state.error!);
}
```

### 4. Display Data
```dart
return ListView(
  children: state.availabilitySlots.map((slot) {
    return SlotTile(slot: slot);
  }).toList(),
);
```

### 5. Prevent Duplicate Operations
```dart
final isProcessing = state.processingSlotIds.contains(slotId);
if (isProcessing) {
  return LoadingWidget();
}
```

---

**For more details, see the comprehensive guides in the project root directory.**
