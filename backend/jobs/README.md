# Background Jobs Configuration

## Auto-Complete Consultations Job

### Purpose
Automatically marks 'scheduled' consultations as 'completed' after their appointment time has passed.

### Schedule
- **Frequency**: Every hour (on the hour: 00:00, 01:00, 02:00, etc.)
- **Cron Expression**: `0 * * * *`
- **Timezone**: Africa/Algiers

### How It Works
1. Fetches all consultations with status = 'scheduled'
2. Filters those where appointment date/time + 1 hour has passed
3. Updates their status to 'completed'
4. Logs success/failure for each operation

### Configuration
Edit `backend/jobs/scheduler.js` to:
- Change schedule timing
- Modify timezone
- Add new jobs

### Monitoring
Check server logs for:
- `🤖 [AUTO-COMPLETE JOB] Starting...` - Job started
- `✅ [AUTO-COMPLETE JOB] Completed in Xs` - Job finished
- Success/error counts

### Manual Execution
Jobs run automatically on server start and then on schedule.

### Graceful Shutdown
Jobs stop cleanly when server receives SIGTERM or SIGINT (Ctrl+C).
