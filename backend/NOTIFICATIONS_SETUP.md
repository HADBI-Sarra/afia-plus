# Backend Notifications Setup Guide

This document describes the backend notification system implementation using Node.js, Supabase, and Firebase Admin SDK.

## Overview

The notification system provides:
1. **Doctor notifications** when a patient books a consultation
2. **Patient notifications** when a doctor accepts a consultation
3. **Reminder notifications** sent 1 hour before consultation time
4. **Device token management** for storing and updating FCM tokens

## File Structure

```
backend/
├── services/
│   ├── notification.service.js      # Main notification service using FCM
│   ├── deviceToken.service.js       # Device token CRUD operations
│   └── reminder.service.js          # Reminder scheduling with cron
├── controllers/
│   └── deviceToken.controller.js    # HTTP handlers for token management
├── routes/
│   └── deviceToken.routes.js        # API routes for tokens
├── src/
│   └── config/
│       └── firebase.js              # Firebase Admin SDK initialization
└── sql/
    └── create_device_tokens_table.sql  # Database schema migration
```

## Prerequisites

1. **Firebase Project Setup**
   - Create a Firebase project at https://console.firebase.google.com
   - Enable Cloud Messaging (FCM) in your Firebase project
   - Download service account JSON file (Project Settings > Service Accounts > Generate New Private Key)

2. **Supabase Database**
   - Run the migration SQL to create `device_tokens` table:
     ```sql
     -- See backend/sql/create_device_tokens_table.sql
     ```

3. **Environment Variables**
   Add to your `.env` file:
   ```env
   # Firebase Configuration
   FIREBASE_SERVICE_ACCOUNT=./firebase_credentials/service_account.json
   # OR if using JSON string directly:
   # FIREBASE_SERVICE_ACCOUNT='{"type":"service_account","project_id":"..."}'
   ```

## Installation

1. Install dependencies:
   ```bash
   cd backend
   npm install
   ```

2. Set up Firebase service account:
   - Create `firebase_credentials/` directory in backend root
   - Place your `service_account.json` file there
   - OR set `FIREBASE_SERVICE_ACCOUNT` as a JSON string in `.env`

3. Run database migration:
   - Execute `backend/sql/create_device_tokens_table.sql` in your Supabase SQL editor

## API Endpoints

### Device Token Management

#### Store/Update Token
```http
POST /device-tokens
Content-Type: application/json

{
  "userId": 123,
  "token": "fcm_device_token_here",
  "deviceType": "android"  // optional: "android" | "ios" | "web"
}
```

#### Get User Tokens
```http
GET /device-tokens/user/:userId
```

#### Delete Token
```http
DELETE /device-tokens/:token
```

#### Delete All User Tokens
```http
DELETE /device-tokens/user/:userId
```

## Notification Types

### 1. Booking Notification (Doctor)
Triggered when a patient books a consultation.

**Data Payload:**
```json
{
  "type": "consultation_booking",
  "consultation_id": "123",
  "doctor_id": "456",
  "patient_id": "789",
  "consultation_date": "2025-01-15",
  "start_time": "14:00"
}
```

### 2. Acceptance Notification (Patient)
Triggered when a doctor accepts a pending consultation.

**Data Payload:**
```json
{
  "type": "consultation_accepted",
  "consultation_id": "123",
  "doctor_id": "456",
  "patient_id": "789",
  "consultation_date": "2025-01-15",
  "start_time": "14:00"
}
```

### 3. Reminder Notification (Both)
Sent 1 hour before consultation time.

**Data Payload:**
```json
{
  "type": "consultation_reminder",
  "consultation_id": "123",
  "doctor_id": "456",
  "patient_id": "789",
  "consultation_date": "2025-01-15",
  "start_time": "14:00"
}
```

## How It Works

### Booking Flow
1. Patient books consultation via `POST /consultations/book`
2. `ConsultationsService.bookConsultation()` creates consultation
3. `NotificationService.notifyDoctorOnBooking()` sends notification to doctor
4. `ReminderService.scheduleReminderForConsultation()` schedules reminder

### Acceptance Flow
1. Doctor accepts consultation via `PUT /consultations/:id/status` with `status: "scheduled"`
2. `ConsultationsService.updateConsultationStatus()` updates status
3. `NotificationService.notifyPatientOnAcceptance()` sends notification to patient
4. Reminder is ensured to be scheduled

### Reminder Flow
1. `ReminderService` runs every 15 minutes via cron job
2. Checks for consultations scheduled 1 hour from now (±15 min window)
3. Sends reminder notifications to both patient and doctor
4. Prevents duplicate reminders using time-based checks

## Reminder Scheduler

The reminder service runs automatically when the server starts:
- **Frequency:** Every 15 minutes
- **Reminder Time:** 1 hour before consultation
- **Window:** ±15 minutes to account for cron interval

To modify reminder timing, edit `backend/services/reminder.service.js`:
```javascript
// Change reminder time (default: 60 minutes)
await ReminderService.scheduleReminderForConsultation(consultation, 30); // 30 min before
```

## Flutter Integration

In your Flutter app, call the token endpoint when you receive an FCM token:

```dart
// After getting FCM token
final token = await FirebaseMessaging.instance.getToken();

// Send to backend
await http.post(
  Uri.parse('$baseUrl/device-tokens'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'userId': currentUserId,
    'token': token,
    'deviceType': 'android', // or 'ios'
  }),
);
```

## Error Handling

- Notifications are sent asynchronously and failures don't affect booking operations
- Invalid tokens are automatically removed from the database
- Reminder service continues even if individual reminders fail
- All errors are logged but don't crash the server

## Testing

1. **Test Token Storage:**
   ```bash
   Invoke-RestMethod -Uri "http://10.28.198.117:3000/device-tokens" `
      -Method POST `
      -ContentType "application/json" `
      -Body '{"userId":1,"token":"test_token","deviceType":"android"}'
   ```

2. **Test Booking Notification:**
   - Book a consultation and check server logs for notification sent

3. **Test Reminder:**
   - Create a consultation 1 hour from now
   - Wait for the next cron run (15 min) or trigger manually

## Troubleshooting

### Firebase Not Initialized
- Check `FIREBASE_SERVICE_ACCOUNT` environment variable
- Verify service account JSON file exists and is valid
- Check server logs for Firebase initialization errors

### Notifications Not Sending
- Verify device tokens exist in `device_tokens` table
- Check Firebase service account has Cloud Messaging permissions
- Review server logs for specific error messages

### Reminders Not Working
- Verify reminder service started (check server startup logs)
- Check cron job is running (should log every 15 minutes)
- Verify consultation status is 'scheduled' (reminders only for scheduled consultations)

### Invalid Tokens
- Tokens are automatically cleaned up when invalid
- User should refresh token in Flutter app if notifications stop working

## Security Notes

- Device tokens are user-specific and managed via authenticated endpoints
- Service account key should be kept secure (not committed to version control)
- Use environment variables for sensitive configuration
- Consider adding authentication middleware to device token endpoints

## Production Considerations

1. **Rate Limiting:** Consider rate limiting for token endpoints
2. **Token Cleanup:** Implement periodic cleanup of old/invalid tokens
3. **Monitoring:** Monitor notification success rates
4. **Retry Logic:** Consider implementing retry for failed notifications
5. **Batch Processing:** For large-scale, consider batching notifications

