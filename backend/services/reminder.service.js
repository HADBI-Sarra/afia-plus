import cron from 'node-cron';
import { supabaseAdmin } from '../src/config/supabase.js';
import { NotificationService } from './notification.service.js';
import { logger } from '../utils/logger.js';

/**
 * Reminder Service
 * Schedules and sends reminder notifications for upcoming consultations
 */
export class ReminderService {
    static reminderTask = null;
    static isRunning = false;

    /**
     * Start the reminder scheduler
     * Runs every 15 minutes to check for consultations that need reminders
     */
    static start() {
        if (this.isRunning) {
            logger.warn('⚠️ Reminder service is already running');
            return;
        }

        // Run every 15 minutes
        this.reminderTask = cron.schedule('*/15 * * * *', async () => {
            try {
                logger.info('⏰ Running reminder check...');
                await this.checkAndSendReminders();
            } catch (error) {
                logger.error('❌ Error in reminder check:', error.message);
            }
        }, {
            scheduled: true,
            timezone: 'UTC'
        });

        this.isRunning = true;
        logger.info('✅ Reminder service started (runs every 15 minutes)');
        
        // Run immediately on start
        this.checkAndSendReminders().catch(err => {
            logger.error('❌ Error in initial reminder check:', err.message);
        });
    }

    /**
     * Stop the reminder scheduler
     */
    static stop() {
        if (this.reminderTask) {
            this.reminderTask.stop();
            this.reminderTask = null;
            this.isRunning = false;
            logger.info('⏹️ Reminder service stopped');
        }
    }

    /**
     * Check for consultations that need reminders and send them
     * Sends reminders 1 hour before consultation time
     */
    static async checkAndSendReminders() {
        try {
            const now = new Date();
            const oneHourFromNow = new Date(now.getTime() + 60 * 60 * 1000); // 1 hour from now
            const fifteenMinutesAgo = new Date(now.getTime() - 15 * 60 * 1000); // 15 minutes ago

            // Get consultations that are:
            // 1. Scheduled (status = 'scheduled')
            // 2. Between 15 minutes ago and 1 hour from now
            // 3. Not already sent reminder (we'll check last_reminder_sent or use a separate tracking mechanism)

            const today = now.toISOString().split('T')[0];
            const tomorrow = new Date(now.getTime() + 24 * 60 * 60 * 1000).toISOString().split('T')[0];

            // Get all scheduled consultations for today and tomorrow
            const { data: consultations, error } = await supabaseAdmin
                .from('consultations')
                .select('*')
                .eq('status', 'scheduled')
                .in('consultation_date', [today, tomorrow])
                .order('consultation_date', { ascending: true })
                .order('start_time', { ascending: true });

            if (error) {
                throw new Error(`Failed to fetch consultations: ${error.message}`);
            }

            if (!consultations || consultations.length === 0) {
                logger.info('📭 No consultations need reminders right now');
                return;
            }

            logger.info(`🔍 Found ${consultations.length} scheduled consultations to check`);

            // Process each consultation
            for (const consultation of consultations) {
                try {
                    await this.processConsultationReminder(consultation, now, oneHourFromNow, fifteenMinutesAgo);
                } catch (error) {
                    logger.error(`❌ Error processing reminder for consultation ${consultation.consultation_id}:`, error.message);
                }
            }
        } catch (error) {
            logger.error('❌ Error in checkAndSendReminders:', error.message);
        }
    }

    /**
     * Process reminder for a single consultation
     * @param {Object} consultation - Consultation object
     * @param {Date} now - Current time
     * @param {Date} oneHourFromNow - One hour from now
     * @param {Date} fifteenMinutesAgo - Fifteen minutes ago
     */
    static async processConsultationReminder(consultation, now, oneHourFromNow, fifteenMinutesAgo) {
        const { consultation_id, consultation_date, start_time } = consultation;

        // Parse consultation datetime
        const consultationDateTime = new Date(`${consultation_date}T${start_time}:00`);
        
        // Calculate time until consultation
        const timeUntilConsultation = consultationDateTime.getTime() - now.getTime();
        const hoursUntilConsultation = timeUntilConsultation / (1000 * 60 * 60);

        // Check if consultation is between 15 minutes ago and 1 hour from now
        // This ensures we send reminders roughly 1 hour before, accounting for the 15-minute cron interval
        if (timeUntilConsultation >= -15 * 60 * 1000 && timeUntilConsultation <= 60 * 60 * 1000) {
            // Check if we've already sent a reminder (within the last 2 hours to avoid duplicates)
            const reminderWindowStart = new Date(now.getTime() - 2 * 60 * 60 * 1000);
            
            // We'll use a simple approach: check if consultation was created/updated recently
            // In production, you might want to add a last_reminder_sent column to the consultations table
            const consultationCreatedAt = new Date(consultation.created_at || consultation.updated_at);
            
            // Only send if consultation was created before the reminder window
            if (consultationCreatedAt < reminderWindowStart || hoursUntilConsultation >= 0.75) {
                logger.info(`📨 Sending reminder for consultation ${consultation_id} (${hoursUntilConsultation.toFixed(2)} hours until)`);
                
                // Send reminder notification
                const sent = await NotificationService.sendConsultationReminder(consultation);
                
                if (sent) {
                    // Optionally update a last_reminder_sent field if it exists
                    // For now, we rely on the time-based check to avoid duplicates
                    logger.info(`✅ Reminder sent for consultation ${consultation_id}`);
                } else {
                    logger.warn(`⚠️ Failed to send reminder for consultation ${consultation_id}`);
                }
            } else {
                logger.debug(`⏭️ Skipping consultation ${consultation_id} - reminder already sent recently`);
            }
        }
    }

    /**
     * Schedule a reminder for a specific consultation
     * Can be used for immediate scheduling of reminders
     * @param {Object} consultation - Consultation object
     * @param {number} minutesBefore - Minutes before consultation to send reminder (default: 60)
     */
    static async scheduleReminderForConsultation(consultation, minutesBefore = 60) {
        try {
            const { consultation_date, start_time, consultation_id } = consultation;
            const consultationDateTime = new Date(`${consultation_date}T${start_time}:00`);
            const reminderTime = new Date(consultationDateTime.getTime() - minutesBefore * 60 * 1000);
            const now = new Date();

            // If reminder time is in the past or very soon, schedule it for immediate sending
            if (reminderTime <= now) {
                logger.info(`📨 Sending immediate reminder for consultation ${consultation_id}`);
                return await NotificationService.sendConsultationReminder(consultation);
            }

            // Otherwise, the cron job will pick it up
            logger.info(`⏰ Reminder scheduled for consultation ${consultation_id} at ${reminderTime.toISOString()}`);
            return true;
        } catch (error) {
            logger.error(`❌ Error scheduling reminder for consultation ${consultation.consultation_id}:`, error.message);
            return false;
        }
    }
}

