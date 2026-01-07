import { supabaseAdmin } from '../src/config/supabase.js';
import { logger } from '../utils/logger.js';

/**
 * Consultations Service
 * Handles all operations for consultations on Supabase
 * Implements booking logic, status transitions, and transaction handling
 */

export class ConsultationsService {
    /**
     * Get all consultations for a patient
     * @param {number} patientId - Patient ID
     * @returns {Promise<Array>} List of consultations with doctor details
     */
    static async getPatientConsultations(patientId) {
        const { data, error } = await supabaseAdmin
            .from('consultations')
            .select(`
        *,
        doctor:doctors!consultations_doctor_id_fkey(
          doctor_id,
          speciality_id,
          price_per_hour,
          average_rating,
          user:users!doctors_user_id_fkey(
            firstname,
            lastname,
            profile_picture,
            phone_number
          ),
          speciality:specialities(speciality_name)
        )
      `)
            .eq('patient_id', patientId)
            .order('consultation_date', { ascending: false })
            .order('start_time', { ascending: false });

        if (error) throw new Error(`Failed to get patient consultations: ${error.message}`);
        return data || [];
    }

    /**
     * Get confirmed consultations for a patient (scheduled and completed)
     * @param {number} patientId - Patient ID
     * @returns {Promise<Array>} List of confirmed consultations
     */
    static async getConfirmedPatientConsultations(patientId) {
        const { data, error } = await supabaseAdmin
            .from('consultations')
            .select(`
        *,
        doctor:doctors!consultations_doctor_id_fkey(
          doctor_id,
          speciality_id,
          price_per_hour,
          average_rating,
          user:users!doctors_user_id_fkey(
            firstname,
            lastname,
            profile_picture,
            phone_number
          ),
          speciality:specialities(speciality_name)
        )
      `)
            .eq('patient_id', patientId)
            .in('status', ['scheduled', 'completed'])
            .order('consultation_date', { ascending: false })
            .order('start_time', { ascending: false });

        if (error) throw new Error(`Failed to get confirmed consultations: ${error.message}`);
        return data || [];
    }

    /**
     * Get pending consultations for a patient (not yet confirmed)
     * @param {number} patientId - Patient ID
     * @returns {Promise<Array>} List of pending consultations
     */
    static async getNotConfirmedPatientConsultations(patientId) {
        const { data, error } = await supabaseAdmin
            .from('consultations')
            .select(`
        *,
        doctor:doctors!consultations_doctor_id_fkey(
          doctor_id,
          speciality_id,
          price_per_hour,
          average_rating,
          user:users!doctors_user_id_fkey(
            firstname,
            lastname,
            profile_picture,
            phone_number
          ),
          speciality:specialities(speciality_name)
        )
      `)
            .eq('patient_id', patientId)
            .eq('status', 'pending')
            .order('consultation_date', { ascending: false })
            .order('start_time', { ascending: false });

        if (error) throw new Error(`Failed to get pending consultations: ${error.message}`);
        return data || [];
    }

    /**
     * Get all consultations for a doctor
     * @param {number} doctorId - Doctor ID
     * @returns {Promise<Array>} List of consultations with patient details
     */
    static async getDoctorConsultations(doctorId) {
        const { data, error } = await supabaseAdmin
            .from('consultations')
            .select(`
        *,
        patient:patients!consultations_patient_id_fkey(
          patient_id,
          date_of_birth,
          user:users!patients_patient_id_fkey(
            firstname,
            lastname,
            phone_number
          )
        ),
        availability:doctor_availability(availability_id, status)
      `)
            .eq('doctor_id', doctorId)
            .order('consultation_date', { ascending: false })
            .order('start_time', { ascending: false });

        if (error) throw new Error(`Failed to get doctor consultations: ${error.message}`);
        return data || [];
    }

    /**
     * Get upcoming consultations for a doctor
     * @param {number} doctorId - Doctor ID
     * @returns {Promise<Array>} List of upcoming consultations
     */
    static async getUpcomingDoctorConsultations(doctorId) {
        const today = new Date().toISOString().split('T')[0];

        const { data, error } = await supabaseAdmin
            .from('consultations')
            .select(`
        *,
        patient:patients!consultations_patient_id_fkey(
          patient_id,
          date_of_birth,
          user:users!patients_patient_id_fkey(
            firstname,
            lastname,
            phone_number
          )
        ),
        availability:doctor_availability(availability_id, status)
      `)
            .eq('doctor_id', doctorId)
            .in('status', ['pending', 'scheduled'])
            .gte('consultation_date', today)
            .order('consultation_date', { ascending: true })
            .order('start_time', { ascending: true });

        if (error) throw new Error(`Failed to get upcoming consultations: ${error.message}`);
        return data || [];
    }

    /**
     * Get past consultations for a doctor (completed only)
     * Considers both date and time to determine if consultation has passed
     * @param {number} doctorId - Doctor ID
     * @returns {Promise<Array>} List of past consultations
     */
    static async getPastDoctorConsultations(doctorId) {
        const now = new Date();
        const today = now.toISOString().split('T')[0];

        const { data, error } = await supabaseAdmin
            .from('consultations')
            .select(`
        *,
        patient:patients!consultations_patient_id_fkey(
          patient_id,
          date_of_birth,
          user:users!patients_patient_id_fkey(
            firstname,
            lastname,
            phone_number
          )
        ),
        availability:doctor_availability(availability_id, status)
      `)
            .eq('doctor_id', doctorId)
            .eq('status', 'completed')
            .order('consultation_date', { ascending: false })
            .order('start_time', { ascending: false });

        if (error) throw new Error(`Failed to get past consultations: ${error.message}`);

        // Filter by date AND time on the server side
        const filteredData = (data || []).filter(consultation => {
            const consultationDate = new Date(consultation.consultation_date);
            const [hours, minutes] = consultation.start_time.split(':').map(Number);
            consultationDate.setHours(hours, minutes, 0, 0);
            return consultationDate < now;
        });

        return filteredData;
    }

    /**
     * Get patient prescriptions (completed consultations with prescription)
     * @param {number} patientId - Patient ID
     * @returns {Promise<Array>} List of prescriptions
     */
    static async getPatientPrescriptions(patientId) {
        const { data, error } = await supabaseAdmin
            .from('consultations')
            .select(`
        *,
        doctor:doctors!consultations_doctor_id_fkey(
          doctor_id,
          speciality_id,
          user:users!doctors_doctor_id_fkey(
            firstname,
            lastname,
            profile_picture,
            phone_number
          ),
          speciality:specialities(speciality_name)
        )
      `)
            .eq('patient_id', patientId)
            .eq('status', 'completed')
            .not('prescription', 'is', null)
            .order('consultation_date', { ascending: false });

        if (error) throw new Error(`Failed to get prescriptions: ${error.message}`);
        return data || [];
    }

    /**
     * Book a consultation (atomic transaction)
     * Prevents double-booking by checking availability status
     * @param {number} patientId - Patient ID
     * @param {number} doctorId - Doctor ID
     * @param {number} availabilityId - Availability slot ID
     * @param {string} consultationDate - Consultation date (YYYY-MM-DD)
     * @param {string} startTime - Start time (HH:MM)
     * @returns {Promise<Object>} Created consultation
     */
    static async bookConsultation(patientId, doctorId, availabilityId, consultationDate, startTime) {
        logger.info('🔹 BookConsultation Service called');
        logger.info('  Validating inputs...');

        // Validate inputs
        if (!patientId || !doctorId || !availabilityId || !consultationDate || !startTime) {
            throw new Error('Missing required fields for booking');
        }

        // CRITICAL: Validate that booking is not for past date/time
        const consultationDateTime = new Date(`${consultationDate}T${startTime}:00`);
        const now = new Date();

        if (consultationDateTime <= now) {
            throw new Error('Cannot book appointments for past dates or times');
        }

        logger.info('  Checking availability slot...');
        // Check if availability slot still exists and is free
        const { data: availability, error: availError } = await supabaseAdmin
            .from('doctor_availability')
            .select('*')
            .eq('availability_id', availabilityId)
            .single();

        if (availError || !availability) {
            logger.error('  ❌ Availability slot not found:', availError?.message);
            throw new Error('Availability slot not found');
        }

        logger.log('  Availability found:', availability);

        // Check if this exact availability slot already has ANY consultation (including cancelled ones to debug)
        logger.info('  Checking for existing consultation with availability_id:', availabilityId);
        const { data: allConsultations, error: allError } = await supabaseAdmin
            .from('consultations')
            .select('consultation_id, patient_id, status')
            .eq('availability_id', availabilityId);

        logger.log('  All consultations with this availability_id:', allConsultations, 'error:', allError);

        // Now check for ACTIVE consultations (not cancelled)
        const activeConsultations = allConsultations?.filter(c => c.status !== 'cancelled') || [];
        logger.log('  Active consultations (non-cancelled):', activeConsultations);

        // Delete any cancelled consultations to free up the availability_id for rebooking
        const cancelledConsultations = allConsultations?.filter(c => c.status === 'cancelled') || [];
        if (cancelledConsultations.length > 0) {
            logger.info('  🗑️ Deleting cancelled consultations to free up availability_id...');
            for (const cancelled of cancelledConsultations) {
                await supabaseAdmin
                    .from('consultations')
                    .delete()
                    .eq('consultation_id', cancelled.consultation_id);
                logger.info('  ✅ Deleted cancelled consultation:', cancelled.consultation_id);
            }
        }

        if (activeConsultations.length > 0) {
            logger.error('  ❌ Slot already has an active consultation:', activeConsultations[0]);
            throw new Error('This time slot has already been booked by another patient');
        }

        if (availability.status === 'booked') {
            logger.error('  ❌ Slot already marked as booked');
            throw new Error('This slot has already been booked');
        }

        logger.info('  Checking for existing consultations...');
        // Check for existing consultation for this patient at same time
        const { data: existingConsultation } = await supabaseAdmin
            .from('consultations')
            .select('consultation_id')
            .eq('patient_id', patientId)
            .eq('consultation_date', consultationDate)
            .eq('start_time', startTime)
            .eq('status', 'scheduled')
            .single();

        if (existingConsultation) {
            logger.error('  ❌ Patient already has consultation at this time');
            throw new Error('Patient already has a consultation at this time');
        }

        logger.info('  Creating consultation...');
        // Create consultation (status: pending - requires doctor acceptance)
        const { data: consultation, error: consultError } = await supabaseAdmin
            .from('consultations')
            .insert([{
                patient_id: patientId,
                doctor_id: doctorId,
                availability_id: availabilityId,
                consultation_date: consultationDate,
                start_time: startTime,
                status: 'pending'
            }])
            .select()
            .single();

        if (consultError) {
            logger.error('  ❌ Failed to create consultation:', consultError.message);
            throw new Error(`Failed to create consultation: ${consultError.message}`);
        }

        logger.log('  ✅ Consultation created:', consultation);
        logger.info('  Updating availability slot to booked...');

        // Update availability slot to booked
        const { error: updateError } = await supabaseAdmin
            .from('doctor_availability')
            .update({ status: 'booked' })
            .eq('availability_id', availabilityId);

        if (updateError) {
            logger.error('  ❌ Failed to update slot, rolling back...', updateError.message);
            // Rollback: delete the consultation we just created
            await supabaseAdmin
                .from('consultations')
                .delete()
                .eq('consultation_id', consultation.consultation_id);

            throw new Error(`Failed to mark slot as booked: ${updateError.message}`);
        }

        logger.info('  ✅ Availability slot marked as booked');
        logger.info('  ✅ Booking complete!');
        return consultation;
    }

    /**
     * Update consultation status
     * @param {number} consultationId - Consultation ID
     * @param {string} status - New status (pending, scheduled, completed, cancelled)
     * @returns {Promise<Object>} Updated consultation
     */
    static async updateConsultationStatus(consultationId, status) {
        const validStatuses = ['pending', 'scheduled', 'completed', 'cancelled'];
        if (!validStatuses.includes(status)) {
            throw new Error(`Invalid status. Must be one of: ${validStatuses.join(', ')}`);
        }

        const { data: consultation, error: fetchError } = await supabaseAdmin
            .from('consultations')
            .select('*')
            .eq('consultation_id', consultationId)
            .single();

        if (fetchError || !consultation) {
            throw new Error('Consultation not found');
        }

        // If cancelling, free up the availability slot
        if (status === 'cancelled' && consultation.status !== 'cancelled') {
            if (consultation.availability_id) {
                // Free up the availability slot
                await supabaseAdmin
                    .from('doctor_availability')
                    .update({ status: 'free' })
                    .eq('availability_id', consultation.availability_id);

                // Delete the consultation to allow rebooking (due to unique constraint on availability_id)
                await supabaseAdmin
                    .from('consultations')
                    .delete()
                    .eq('consultation_id', consultationId);

                logger.info('✅ Consultation cancelled and deleted, slot freed');
                return { ...consultation, status: 'cancelled', deleted: true };
            }
        }

        // If scheduling from pending, update status
        if (status === 'scheduled' && consultation.status === 'pending') {
            // Doctor accepted the consultation
        }

        const { data, error } = await supabaseAdmin
            .from('consultations')
            .update({ status })
            .eq('consultation_id', consultationId)
            .select()
            .single();

        if (error) throw new Error(`Failed to update consultation status: ${error.message}`);
        return data;
    }

    /**
     * Add prescription to a completed consultation
     * @param {number} consultationId - Consultation ID
     * @param {string} prescription - Prescription text/PDF path
     * @returns {Promise<Object>} Updated consultation
     */
    static async addPrescription(consultationId, prescription) {
        if (!prescription) {
            throw new Error('Prescription cannot be empty');
        }

        const { data, error } = await supabaseAdmin
            .from('consultations')
            .update({ prescription })
            .eq('consultation_id', consultationId)
            .select()
            .single();

        if (error) throw new Error(`Failed to add prescription: ${error.message}`);
        return data;
    }

    /**
     * Cancel a consultation and free up the slot
     * @param {number} consultationId - Consultation ID
     * @returns {Promise<Object>} Updated consultation
     */
    static async cancelConsultation(consultationId) {
        const consultation = await this.updateConsultationStatus(consultationId, 'cancelled');
        return consultation;
    }

    /**
     * Delete a consultation (only for pending/cancelled)
     * @param {number} consultationId - Consultation ID
     * @returns {Promise<void>}
     */
    static async deleteConsultation(consultationId) {
        const { data: consultation } = await supabaseAdmin
            .from('consultations')
            .select('*')
            .eq('consultation_id', consultationId)
            .single();

        if (!consultation) {
            throw new Error('Consultation not found');
        }

        if (!['pending', 'cancelled'].includes(consultation.status)) {
            throw new Error('Can only delete pending or cancelled consultations');
        }

        // Free up slot if it exists
        if (consultation.availability_id) {
            await supabaseAdmin
                .from('doctor_availability')
                .update({ status: 'free' })
                .eq('availability_id', consultation.availability_id);
        }

        const { error } = await supabaseAdmin
            .from('consultations')
            .delete()
            .eq('consultation_id', consultationId);

        if (error) throw new Error(`Failed to delete consultation: ${error.message}`);
    }

    /**
     * Complete a consultation
     * @param {number} consultationId - Consultation ID
     * @returns {Promise<Object>} Updated consultation
     */
    static async completeConsultation(consultationId) {
        const consultation = await this.updateConsultationStatus(consultationId, 'completed');
        return consultation;
    }
}

