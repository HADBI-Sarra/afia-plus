import express from 'express';
import {
    getDoctorAvailability,
    getDoctorAvailabilityByDateRange,
    getFreeSlots,
    createAvailabilitySlot,
    bulkCreateSlots,
    updateAvailabilityStatus,
    deleteAvailabilitySlot
} from '../controllers/doctor_availability.controller.js';

const router = express.Router();

/**
 * Doctor Availability Routes
 */

// GET all availability slots for a doctor
router.get('/doctor/:doctorId', getDoctorAvailability);

// GET availability slots for a doctor within a date range
router.get('/doctor/:doctorId/range', getDoctorAvailabilityByDateRange);

// GET only free slots for a doctor on a specific date
router.get('/doctor/:doctorId/free', getFreeSlots);

// POST create a new availability slot
router.post('/', createAvailabilitySlot);

// POST bulk create availability slots
router.post('/bulk', bulkCreateSlots);

// PUT update availability slot status
router.put('/:id/status', updateAvailabilityStatus);

// DELETE availability slot
router.delete('/:id', deleteAvailabilitySlot);

export default router;
