# Backend Notifications Implementation Summary

## Overview

Complete backend notification system using Node.js, Supabase, and Firebase Admin SDK has been implemented. The system sends push notifications for booking events, consultation acceptance, and reminders.

## Implementation Details

### Files Created

1. **Firebase Configuration**
   - `backend/src/config/firebase.js` - Initializes Firebase Admin SDK from service account

2. **Notification Services**
   - `backend/services/notification.service.js` - Main notification service with FCM integration
   - `backend/services/deviceToken.service.js` - Manages FCM tokens in Supabase
   - `backend/services/reminder.service.js` - Schedules and sends reminder notifications using cron

3. **Controllers & Routes**
   - `backend/controllers/deviceToken.controller.js` - HTTP handlers for token management
   - `backend/routes/deviceToken.routes.js` - API routes for device tokens

4. **Database Migration**
   - `backend/sql/create_device_tokens_table.sql` - SQL schema for device_tokens table

5. **Documentation**
   - `backend/NOTIFICATIONS_SETUP.md` - Complete setup and usage guide

### Files Modified

1. **Backend Services**
   - `backend/services/consultations.service.js` - Added notification triggers:
     - Sends notification to doctor when patient books consultation
     - Sends notification to patient when doctor accepts consultation
     - Schedules reminders for consultations

2. **Server Configuration**
   - `backend/src/app.js` - Added device token routes
   - `backend/src/server.js` - Initialized reminder service on startup
   - `backend/package.json` - Added dependencies:
     - `firebase-admin: ^12.0.0`
     - `node-cron: ^3.0.3`

## Features Implemented

### ✅ 1. Notification to Doctor on Booking
- Triggered automatically when patient books consultation
- Sent via `NotificationService.notifyDoctorOnBooking()`
- Includes patient name, date, and time

### ✅ 2. Notification to Patient on Acceptance
- Triggered when doctor updates consultation status to 'scheduled'
- Sent via `NotificationService.notifyPatientOnAcceptance()`
- Includes doctor name, date, and time

### ✅ 3. Reminder Notifications
- Automatically scheduled when consultation is created/accepted
- Sends reminders 1 hour before consultation time
- Cron job runs every 15 minutes to check for reminders
- Sends to both patient and doctor

### ✅ 4. Device Token Management
- Store/update tokens via `POST /device-tokens`
- Get user tokens via `GET /device-tokens/user/:userId`
- Delete tokens via `DELETE /device-tokens/:token`
- Automatic cleanup of invalid tokens

### ✅ 5. Reusable Notification Service
- `NotificationService` class with static methods
- Can send to user by ID or to specific tokens
- Handles Android and iOS notification formats
- Automatic token cleanup on failure

### ✅ 6. Reminder Scheduling
- `ReminderService` with cron-based scheduling
- Checks every 15 minutes for upcoming consultations
- Prevents duplicate reminders
- Handles timezone conversions

## API Endpoints

### Device Token Management
```
POST   /device-tokens              - Store/update device token
GET    /device-tokens/user/:userId - Get user's device tokens
DELETE /device-tokens/:token       - Delete specific token
DELETE /device-tokens/user/:userId - Delete all user's tokens
```

## Notification Data Payloads

All notifications include:
- `type`: Notification type ('consultation_booking', 'consultation_accepted', 'consultation_reminder')
- `consultation_id`: Consultation ID
- `doctor_id`: Doctor ID
- `patient_id`: Patient ID
- `consultation_date`: Date (YYYY-MM-DD)
- `start_time`: Time (HH:MM)
- `timestamp`: ISO timestamp

## Setup Required

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Environment Variables
Add to `.env`:
```env
FIREBASE_SERVICE_ACCOUNT=./firebase_credentials/service_account.json
# OR as JSON string:
# FIREBASE_SERVICE_ACCOUNT='{"type":"service_account",...}'
```

### 3. Database Migration
Run `backend/sql/create_device_tokens_table.sql` in Supabase SQL editor.

### 4. Firebase Setup
- Download service account JSON from Firebase Console
- Place in `backend/firebase_credentials/service_account.json`
- OR set as JSON string in environment variable

## How It Works

### Booking Flow
1. Patient books via `POST /consultations/book`
2. `ConsultationsService.bookConsultation()` creates consultation
3. `NotificationService.notifyDoctorOnBooking()` sends to doctor
4. `ReminderService.scheduleReminderForConsultation()` schedules reminder

### Acceptance Flow
1. Doctor accepts via `PUT /consultations/:id/status` with `{"status": "scheduled"}`
2. `ConsultationsService.updateConsultationStatus()` updates status
3. `NotificationService.notifyPatientOnAcceptance()` sends to patient
4. Reminder is ensured to be scheduled

### Reminder Flow
1. Cron job runs every 15 minutes
2. `ReminderService.checkAndSendReminders()` queries consultations
3. Finds consultations 1 hour away (±15 min window)
4. `NotificationService.sendConsultationReminder()` sends to both parties

## Error Handling

- Notifications are non-blocking (booking succeeds even if notification fails)
- Invalid tokens are automatically removed from database
- All errors are logged but don't crash the server
- Reminder service continues even if individual reminders fail

## Testing

### Test Token Storage
```bash
Invoke-RestMethod -Uri "http://10.28.198.117:3000/device-tokens" `
   -Method POST `
   -ContentType "application/json" `
   -Body '{"userId":1,"token":"test_token","deviceType":"android"}'
```

### Test Booking Notification
1. Book a consultation via Flutter app or API
2. Check server logs for: "📨 Notifying doctor X about new booking"
3. Doctor should receive push notification

### Test Acceptance Notification
1. Accept a consultation via API: `PUT /consultations/:id/status` with `{"status": "scheduled"}`
2. Check server logs for: "📨 Notifying patient X about acceptance"
3. Patient should receive push notification

### Test Reminder
1. Create a consultation 1 hour from now
2. Wait for next cron run (15 min) or trigger manually
3. Both patient and doctor should receive reminder notifications

## Notes

- Reminders only work for consultations with status 'scheduled'
- Notifications require valid device tokens in `device_tokens` table
- Reminder service starts automatically with server
- All notification sending is asynchronous and non-blocking
- Server can run without Firebase configured (notifications will fail gracefully)

## Production Considerations

1. **Monitor notification success rates** in logs
2. **Set up Firebase service account** properly
3. **Implement retry logic** for failed notifications if needed
4. **Rate limiting** on token endpoints recommended
5. **Token cleanup job** for old/invalid tokens (utility method provided)
6. **Monitoring/alerting** for notification failures

