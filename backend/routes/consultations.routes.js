import express from 'express';
import {
    getPatientConsultations,
    getConfirmedPatientConsultations,
    getNotConfirmedPatientConsultations,
    getDoctorConsultations,
    getUpcomingDoctorConsultations,
    getPastDoctorConsultations,
    getPatientPrescriptions,
    bookConsultation,
    updateConsultationStatus,
    cancelConsultation,
    completeConsultation,
    addPrescription,
    deleteConsultation
} from '../controllers/consultations.controller.js';

const router = express.Router();

/**
 * Consultations Routes
 */

// Patient consultation endpoints
router.get('/patient/:patientId', getPatientConsultations);
router.get('/patient/:patientId/confirmed', getConfirmedPatientConsultations);
router.get('/patient/:patientId/pending', getNotConfirmedPatientConsultations);
router.get('/patient/:patientId/prescriptions', getPatientPrescriptions);

// Doctor consultation endpoints
router.get('/doctor/:doctorId', getDoctorConsultations);
router.get('/doctor/:doctorId/upcoming', getUpcomingDoctorConsultations);
router.get('/doctor/:doctorId/past', getPastDoctorConsultations);

// Booking and consultation management
router.post('/book', bookConsultation);
router.put('/:id/status', updateConsultationStatus);
router.put('/:id/cancel', cancelConsultation);
router.put('/:id/complete', completeConsultation);
router.post('/:id/prescription', addPrescription);
router.delete('/:id', deleteConsultation);

export default router;
