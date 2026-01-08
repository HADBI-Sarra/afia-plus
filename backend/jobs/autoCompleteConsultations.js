import { supabaseAdmin } from '../src/config/supabase.js';
import { logger } from '../utils/logger.js';

/**
 * Auto-Complete Consultations Job
 * Automatically marks 'scheduled' consultations as 'completed' after their appointment time has passed
 * Runs every hour
 */

export async function autoCompleteConsultations() {
    const jobStartTime = new Date();
    logger.info('🤖 [AUTO-COMPLETE JOB] Starting...');

    try {
        // Get current date and time
        const now = new Date();
        const today = now.toISOString().split('T')[0];

        // Fetch all scheduled consultations that might have passed
        const { data: consultations, error: fetchError } = await supabaseAdmin
            .from('consultations')
            .select('consultation_id, consultation_date, start_time, doctor_id, patient_id')
            .eq('status', 'scheduled')
            .lte('consultation_date', today); // Get today and past dates

        if (fetchError) {
            logger.error('❌ [AUTO-COMPLETE JOB] Error fetching consultations:', fetchError.message);
            return;
        }

        if (!consultations || consultations.length === 0) {
            logger.info('✅ [AUTO-COMPLETE JOB] No scheduled consultations to process');
            return;
        }

        logger.info(`📋 [AUTO-COMPLETE JOB] Found ${consultations.length} scheduled consultations to check`);

        // Filter consultations that have actually passed (date + time)
        const passedConsultations = consultations.filter(consultation => {
            try {
                const consultationDateTime = new Date(consultation.consultation_date);
                const [hours, minutes] = consultation.start_time.split(':').map(Number);
                consultationDateTime.setHours(hours, minutes, 0, 0);

                // Add 1 hour to appointment time (consultation duration)
                consultationDateTime.setHours(consultationDateTime.getHours() + 1);

                // Check if consultation end time has passed
                return consultationDateTime < now;
            } catch (e) {
                logger.error(`⚠️ [AUTO-COMPLETE JOB] Error parsing date/time for consultation ${consultation.consultation_id}:`, e.message);
                return false;
            }
        });

        if (passedConsultations.length === 0) {
            logger.info('✅ [AUTO-COMPLETE JOB] No consultations have passed their appointment time');
            return;
        }

        logger.info(`⏰ [AUTO-COMPLETE JOB] ${passedConsultations.length} consultations have passed - updating to completed`);

        // Update each consultation to 'completed'
        let successCount = 0;
        let errorCount = 0;

        for (const consultation of passedConsultations) {
            try {
                const { error: updateError } = await supabaseAdmin
                    .from('consultations')
                    .update({
                        status: 'completed'
                    })
                    .eq('consultation_id', consultation.consultation_id);

                if (updateError) {
                    logger.error(`❌ [AUTO-COMPLETE JOB] Failed to update consultation ${consultation.consultation_id}:`, updateError.message);
                    errorCount++;
                } else {
                    logger.log(`✅ [AUTO-COMPLETE JOB] Completed consultation ${consultation.consultation_id} (Date: ${consultation.consultation_date} ${consultation.start_time})`);
                    successCount++;
                }
            } catch (e) {
                logger.error(`❌ [AUTO-COMPLETE JOB] Exception updating consultation ${consultation.consultation_id}:`, e.message);
                errorCount++;
            }
        }

        const jobEndTime = new Date();
        const duration = ((jobEndTime - jobStartTime) / 1000).toFixed(2);

        logger.info(`✅ [AUTO-COMPLETE JOB] Completed in ${duration}s | Success: ${successCount} | Errors: ${errorCount}`);

    } catch (error) {
        logger.error('❌ [AUTO-COMPLETE JOB] Unexpected error:', error.message);
        logger.error('Stack trace:', error.stack);
    }
}
