import { supabaseAdmin } from '../src/config/supabase.js';

/**
 * Doctor Availability Service
 * Handles all operations for doctor availability slots on Supabase
 */

export class DoctorAvailabilityService {
    /**
     * Get all available slots for a specific doctor
     * @param {number} doctorId - Doctor ID
     * @returns {Promise<Array>} List of availability slots
     */
    static async getDoctorAvailability(doctorId) {
        const { data, error } = await supabaseAdmin
            .from('doctor_availability')
            .select('*')
            .eq('doctor_id', doctorId)
            .order('available_date', { ascending: true })
            .order('start_time', { ascending: true });

        if (error) throw new Error(`Failed to get doctor availability: ${error.message}`);
        return data || [];
    }

    /**
     * Get available slots for a date range
     * @param {number} doctorId - Doctor ID
     * @param {string} startDate - Start date (YYYY-MM-DD)
     * @param {string} endDate - End date (YYYY-MM-DD)
     * @returns {Promise<Array>} List of availability slots
     */
    static async getDoctorAvailabilityByDateRange(doctorId, startDate, endDate) {
        const { data, error } = await supabaseAdmin
            .from('doctor_availability')
            .select('*')
            .eq('doctor_id', doctorId)
            .gte('available_date', startDate)
            .lte('available_date', endDate)
            .eq('status', 'free')
            .order('available_date', { ascending: true })
            .order('start_time', { ascending: true });

        if (error) throw new Error(`Failed to get availability by date range: ${error.message}`);
        return data || [];
    }

    /**
     * Create a new availability slot
     * @param {number} doctorId - Doctor ID
     * @param {string} availableDate - Date (YYYY-MM-DD)
     * @param {string} startTime - Start time (HH:MM)
     * @returns {Promise<Object>} Created availability slot
     */
    static async createAvailabilitySlot(doctorId, availableDate, startTime) {
        // Validate inputs
        if (!doctorId || !availableDate || !startTime) {
            throw new Error('Missing required fields: doctorId, availableDate, startTime');
        }

        // Check if doctor exists
        const { data: doctor, error: doctorError } = await supabaseAdmin
            .from('doctors')
            .select('doctor_id')
            .eq('doctor_id', doctorId)
            .single();

        if (doctorError || !doctor) {
            throw new Error('Doctor not found');
        }

        // Check if slot already exists (prevent duplicates)
        const { data: existingSlot } = await supabaseAdmin
            .from('doctor_availability')
            .select('availability_id')
            .eq('doctor_id', doctorId)
            .eq('available_date', availableDate)
            .eq('start_time', startTime)
            .single();

        if (existingSlot) {
            throw new Error('Slot already exists for this date and time');
        }

        // Create new slot
        const { data, error } = await supabaseAdmin
            .from('doctor_availability')
            .insert([{
                doctor_id: doctorId,
                available_date: availableDate,
                start_time: startTime,
                status: 'free'
            }])
            .select()
            .single();

        if (error) throw new Error(`Failed to create availability slot: ${error.message}`);
        return data;
    }

    /**
     * Update availability slot status
     * @param {number} availabilityId - Availability ID
     * @param {string} status - New status (free, booked)
     * @returns {Promise<Object>} Updated availability slot
     */
    static async updateAvailabilityStatus(availabilityId, status) {
        if (!['free', 'booked'].includes(status)) {
            throw new Error('Invalid status. Must be "free" or "booked"');
        }

        const { data, error } = await supabaseAdmin
            .from('doctor_availability')
            .update({ status })
            .eq('availability_id', availabilityId)
            .select()
            .single();

        if (error) throw new Error(`Failed to update availability status: ${error.message}`);
        return data;
    }

    /**
     * Delete an availability slot
     * @param {number} availabilityId - Availability ID
     * @returns {Promise<void>}
     */
    static async deleteAvailabilitySlot(availabilityId) {
        // Check if slot is booked
        const { data: slot } = await supabaseAdmin
            .from('doctor_availability')
            .select('status')
            .eq('availability_id', availabilityId)
            .single();

        if (slot?.status === 'booked') {
            throw new Error('Cannot delete a booked slot');
        }

        const { error } = await supabaseAdmin
            .from('doctor_availability')
            .delete()
            .eq('availability_id', availabilityId);

        if (error) throw new Error(`Failed to delete availability slot: ${error.message}`);
    }

    /**
     * Get free slots for a doctor on a specific date
     * @param {number} doctorId - Doctor ID
     * @param {string} date - Date (YYYY-MM-DD)
     * @returns {Promise<Array>} List of free slots
     */
    static async getFreeSlots(doctorId, date) {
        const { data, error } = await supabaseAdmin
            .from('doctor_availability')
            .select('*')
            .eq('doctor_id', doctorId)
            .eq('available_date', date)
            .eq('status', 'free')
            .order('start_time', { ascending: true });

        if (error) throw new Error(`Failed to get free slots: ${error.message}`);
        return data || [];
    }

    /**
     * Bulk create availability slots for a doctor
     * @param {number} doctorId - Doctor ID
     * @param {Array} slots - Array of {date, startTime} objects
     * @returns {Promise<Array>} Created slots
     */
    static async bulkCreateSlots(doctorId, slots) {
        if (!Array.isArray(slots) || slots.length === 0) {
            throw new Error('Slots must be a non-empty array');
        }

        const slotsToInsert = slots.map(slot => ({
            doctor_id: doctorId,
            available_date: slot.date,
            start_time: slot.startTime,
            status: 'free'
        }));

        const { data, error } = await supabaseAdmin
            .from('doctor_availability')
            .insert(slotsToInsert)
            .select();

        if (error) throw new Error(`Failed to bulk create slots: ${error.message}`);
        return data || [];
    }
}
