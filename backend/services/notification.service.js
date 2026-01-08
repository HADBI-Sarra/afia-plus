import { firebaseAdmin } from '../src/config/firebase.js';
import { DeviceTokenService } from './deviceToken.service.js';
import { logger } from '../utils/logger.js';

/**
 * Notification Service
 * Handles sending FCM notifications using Firebase Admin SDK
 */
export class NotificationService {
    /**
     * Send a notification to a user by their user ID
     * @param {number} userId - User ID
     * @param {Object} notification - Notification payload { title, body, data }
     * @returns {Promise<boolean>} Success status
     */
    static async sendToUser(userId, notification) {
        try {
            if (!firebaseAdmin) {
                logger.error('❌ Firebase Admin SDK not initialized');
                return false;
            }

            // Get all device tokens for the user
            const tokens = await DeviceTokenService.getUserTokens(userId);
            
            if (!tokens || tokens.length === 0) {
                logger.warn(`⚠️ No device tokens found for user ${userId}`);
                return false;
            }

            // Extract token strings
            const tokenStrings = tokens.map(t => t.token).filter(t => t);

            if (tokenStrings.length === 0) {
                logger.warn(`⚠️ No valid device tokens found for user ${userId}`);
                return false;
            }

            // Send to all devices
            return await this.sendToTokens(tokenStrings, notification);
        } catch (error) {
            logger.error(`❌ Error sending notification to user ${userId}:`, error.message);
            return false;
        }
    }

    /**
     * Send a notification to multiple device tokens
     * @param {string[]} tokens - Array of FCM tokens
     * @param {Object} notification - Notification payload { title, body, data }
     * @returns {Promise<boolean>} Success status
     */
    static async sendToTokens(tokens, notification) {
        try {
            if (!firebaseAdmin) {
                logger.error('❌ Firebase Admin SDK not initialized');
                return false;
            }

            if (!tokens || tokens.length === 0) {
                logger.warn('⚠️ No tokens provided');
                return false;
            }

            const { title, body, data = {} } = notification;

            // Prepare message
            const message = {
                notification: {
                    title: title || 'Notification',
                    body: body || ''
                },
                data: {
                    // Convert all data values to strings (FCM requirement)
                    ...Object.keys(data).reduce((acc, key) => {
                        acc[key] = String(data[key] || '');
                        return acc;
                    }, {}),
                    // Add timestamp
                    timestamp: new Date().toISOString()
                },
                // Android-specific options
                android: {
                    priority: 'high',
                    notification: {
                        sound: 'default',
                        channelId: 'default'
                    }
                },
                // APNs (iOS) specific options
                apns: {
                    payload: {
                        aps: {
                            sound: 'default',
                            badge: 1
                        }
                    }
                }
            };

            // Send to all tokens
            const responses = await firebaseAdmin.messaging().sendEachForMulticast({
                tokens,
                ...message
            });

            // Check results
            let successCount = 0;
            let failureCount = 0;

            responses.responses.forEach((response, idx) => {
                if (response.success) {
                    successCount++;
                    logger.info(`✅ Notification sent to token ${idx + 1}`);
                } else {
                    failureCount++;
                    const token = tokens[idx];
                    
                    // Handle invalid tokens
                    if (response.error?.code === 'messaging/invalid-registration-token' ||
                        response.error?.code === 'messaging/registration-token-not-registered') {
                        logger.warn(`⚠️ Invalid token detected: ${token?.substring(0, 20)}...`);
                        // Remove invalid token from database
                        DeviceTokenService.deleteToken(token).catch(err => {
                            logger.error(`Failed to delete invalid token: ${err.message}`);
                        });
                    } else {
                        logger.error(`❌ Failed to send to token ${idx + 1}: ${response.error?.message}`);
                    }
                }
            });

            logger.info(`📨 Sent ${successCount}/${tokens.length} notifications successfully`);
            return successCount > 0;
        } catch (error) {
            logger.error('❌ Error sending notifications:', error.message);
            return false;
        }
    }

    /**
     * Send notification to doctor when patient books consultation
     * @param {Object} consultation - Consultation object with patient and doctor info
     * @returns {Promise<boolean>} Success status
     */
    static async notifyDoctorOnBooking(consultation) {
        try {
            const { doctor_id, patient_id, consultation_date, start_time, consultation_id } = consultation;

            // Get patient info
            const { supabaseAdmin } = await import('../src/config/supabase.js');
            const { data: patientData } = await supabaseAdmin
                .from('patients')
                .select('user:users!patients_patient_id_fkey(firstname, lastname)')
                .eq('patient_id', patient_id)
                .single();

            const patientName = patientData?.user 
                ? `${patientData.user.firstname || ''} ${patientData.user.lastname || ''}`.trim()
                : 'A patient';

            const notification = {
                title: 'New Consultation Request',
                body: `${patientName} has booked a consultation for ${consultation_date} at ${start_time}`,
                data: {
                    type: 'consultation_booking',
                    consultation_id: String(consultation_id),
                    doctor_id: String(doctor_id),
                    patient_id: String(patient_id),
                    consultation_date: consultation_date,
                    start_time: start_time
                }
            };

            logger.info(`📨 Notifying doctor ${doctor_id} about new booking`);
            return await this.sendToUser(doctor_id, notification);
        } catch (error) {
            logger.error('❌ Error notifying doctor on booking:', error.message);
            return false;
        }
    }

    /**
     * Send notification to patient when doctor accepts consultation
     * @param {Object} consultation - Consultation object with patient and doctor info
     * @returns {Promise<boolean>} Success status
     */
    static async notifyPatientOnAcceptance(consultation) {
        try {
            const { patient_id, doctor_id, consultation_date, start_time, consultation_id } = consultation;

            // Get doctor info
            const { supabaseAdmin } = await import('../src/config/supabase.js');
            const { data: doctorData } = await supabaseAdmin
                .from('doctors')
                .select('user:users!doctors_user_id_fkey(firstname, lastname)')
                .eq('doctor_id', doctor_id)
                .single();

            const doctorName = doctorData?.user
                ? `Dr. ${doctorData.user.firstname || ''} ${doctorData.user.lastname || ''}`.trim()
                : 'Your doctor';

            const notification = {
                title: 'Consultation Accepted',
                body: `${doctorName} has accepted your consultation for ${consultation_date} at ${start_time}`,
                data: {
                    type: 'consultation_accepted',
                    consultation_id: String(consultation_id),
                    doctor_id: String(doctor_id),
                    patient_id: String(patient_id),
                    consultation_date: consultation_date,
                    start_time: start_time
                }
            };

            logger.info(`📨 Notifying patient ${patient_id} about acceptance`);
            return await this.sendToUser(patient_id, notification);
        } catch (error) {
            logger.error('❌ Error notifying patient on acceptance:', error.message);
            return false;
        }
    }

    /**
     * Send reminder notification before consultation
     * @param {Object} consultation - Consultation object with patient and doctor info
     * @returns {Promise<boolean>} Success status
     */
    static async sendConsultationReminder(consultation) {
        try {
            const { 
                consultation_id, 
                patient_id, 
                doctor_id, 
                consultation_date, 
                start_time 
            } = consultation;

            // Get doctor info for patient reminder
            const { supabaseAdmin } = await import('../src/config/supabase.js');
            const { data: doctorData } = await supabaseAdmin
                .from('doctors')
                .select('user:users!doctors_user_id_fkey(firstname, lastname)')
                .eq('doctor_id', doctor_id)
                .single();

            // Get patient info for doctor reminder
            const { data: patientData } = await supabaseAdmin
                .from('patients')
                .select('user:users!patients_patient_id_fkey(firstname, lastname)')
                .eq('patient_id', patient_id)
                .single();

            const doctorName = doctorData?.user
                ? `Dr. ${doctorData.user.firstname || ''} ${doctorData.user.lastname || ''}`.trim()
                : 'Your doctor';

            const patientName = patientData?.user
                ? `${patientData.user.firstname || ''} ${patientData.user.lastname || ''}`.trim()
                : 'Your patient';

            // Send reminder to patient
            const patientNotification = {
                title: 'Consultation Reminder',
                body: `You have a consultation with ${doctorName} today at ${start_time}`,
                data: {
                    type: 'consultation_reminder',
                    consultation_id: String(consultation_id),
                    doctor_id: String(doctor_id),
                    patient_id: String(patient_id),
                    consultation_date: consultation_date,
                    start_time: start_time
                }
            };

            // Send reminder to doctor
            const doctorNotification = {
                title: 'Consultation Reminder',
                body: `You have a consultation with ${patientName} today at ${start_time}`,
                data: {
                    type: 'consultation_reminder',
                    consultation_id: String(consultation_id),
                    doctor_id: String(doctor_id),
                    patient_id: String(patient_id),
                    consultation_date: consultation_date,
                    start_time: start_time
                }
            };

            logger.info(`📨 Sending reminder for consultation ${consultation_id}`);

            // Send to both patient and doctor
            const patientResult = await this.sendToUser(patient_id, patientNotification);
            const doctorResult = await this.sendToUser(doctor_id, doctorNotification);

            return patientResult || doctorResult;
        } catch (error) {
            logger.error('❌ Error sending consultation reminder:', error.message);
            return false;
        }
    }
}

