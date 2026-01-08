import { DoctorAvailabilityService } from '../services/doctor_availability.service.js';
import { sendResponse, sendError } from '../utils/response.js';

/**
 * Doctor Availability Controller
 * Handles HTTP requests for doctor availability management
 */

/**
 * GET /availability/doctor/{id}
 * Get all availability slots for a doctor
 */
export async function getDoctorAvailability(req, res) {
    try {
        const { doctorId } = req.params;

        if (!doctorId) {
            return sendError(res, 400, 'Doctor ID is required');
        }

        const availability = await DoctorAvailabilityService.getDoctorAvailability(doctorId);
        return sendResponse(res, 200, 'Availability slots retrieved successfully', availability);
    } catch (error) {
        console.error('Error fetching doctor availability:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * GET /availability/doctor/{id}/range
 * Get availability slots for a doctor within a date range
 */
export async function getDoctorAvailabilityByDateRange(req, res) {
    try {
        const { doctorId } = req.params;
        const { startDate, endDate } = req.query;

        if (!doctorId || !startDate || !endDate) {
            return sendError(res, 400, 'Doctor ID, startDate, and endDate are required');
        }

        const availability = await DoctorAvailabilityService.getDoctorAvailabilityByDateRange(
            doctorId,
            startDate,
            endDate
        );

        return sendResponse(res, 200, 'Availability slots retrieved successfully', availability);
    } catch (error) {
        console.error('Error fetching availability range:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * GET /availability/doctor/{id}/free
 * Get only free (unboooked) slots for a doctor on a specific date
 */
export async function getFreeSlots(req, res) {
    try {
        const { doctorId } = req.params;
        const { date } = req.query;

        if (!doctorId || !date) {
            return sendError(res, 400, 'Doctor ID and date are required');
        }

        const freeSlots = await DoctorAvailabilityService.getFreeSlots(doctorId, date);
        return sendResponse(res, 200, 'Free slots retrieved successfully', freeSlots);
    } catch (error) {
        console.error('Error fetching free slots:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * POST /availability
 * Create a new availability slot
 * Body: { doctorId, availableDate, startTime }
 */
export async function createAvailabilitySlot(req, res) {
    try {
        const { doctorId, availableDate, startTime } = req.body;

        const slot = await DoctorAvailabilityService.createAvailabilitySlot(
            doctorId,
            availableDate,
            startTime
        );

        return sendResponse(res, 201, 'Availability slot created successfully', slot);
    } catch (error) {
        console.error('Error creating availability slot:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * POST /availability/bulk
 * Bulk create availability slots
 * Body: { doctorId, slots: [{date, startTime}, ...] }
 */
export async function bulkCreateSlots(req, res) {
    try {
        const { doctorId, slots } = req.body;

        if (!doctorId || !slots) {
            return sendError(res, 400, 'Doctor ID and slots array are required');
        }

        const created = await DoctorAvailabilityService.bulkCreateSlots(doctorId, slots);
        return sendResponse(res, 201, 'Slots created successfully', created);
    } catch (error) {
        console.error('Error creating slots in bulk:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * PUT /availability/{id}/status
 * Update availability slot status
 * Body: { status: 'free' | 'booked' }
 */
export async function updateAvailabilityStatus(req, res) {
    try {
        const { id } = req.params;
        const { status } = req.body;

        if (!status) {
            return sendError(res, 400, 'Status is required');
        }

        const updated = await DoctorAvailabilityService.updateAvailabilityStatus(id, status);
        return sendResponse(res, 200, 'Availability status updated successfully', updated);
    } catch (error) {
        console.error('Error updating availability status:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * DELETE /availability/{id}
 * Delete an availability slot
 */
export async function deleteAvailabilitySlot(req, res) {
    try {
        const { id } = req.params;

        await DoctorAvailabilityService.deleteAvailabilitySlot(id);
        return sendResponse(res, 200, 'Availability slot deleted successfully', {});
    } catch (error) {
        console.error('Error deleting availability slot:', error);
        return sendError(res, 500, error.message);
    }
}
