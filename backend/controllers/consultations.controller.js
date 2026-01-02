import { ConsultationsService } from '../services/consultations.service.js';
import { sendResponse, sendError } from '../utils/response.js';

/**
 * Consultations Controller
 * Handles HTTP requests for consultation management
 */

/**
 * GET /consultations/patient/{id}
 * Get all consultations for a patient
 */
export async function getPatientConsultations(req, res) {
    try {
        const { patientId } = req.params;

        if (!patientId) {
            return sendError(res, 400, 'Patient ID is required');
        }

        const consultations = await ConsultationsService.getPatientConsultations(patientId);
        return sendResponse(res, 200, 'Patient consultations retrieved successfully', consultations);
    } catch (error) {
        console.error('Error fetching patient consultations:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * GET /consultations/patient/{id}/confirmed
 * Get confirmed consultations for a patient
 */
export async function getConfirmedPatientConsultations(req, res) {
    try {
        const { patientId } = req.params;

        if (!patientId) {
            return sendError(res, 400, 'Patient ID is required');
        }

        const consultations = await ConsultationsService.getConfirmedPatientConsultations(patientId);
        return sendResponse(res, 200, 'Confirmed consultations retrieved successfully', consultations);
    } catch (error) {
        console.error('Error fetching confirmed consultations:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * GET /consultations/patient/{id}/pending
 * Get pending (not confirmed) consultations for a patient
 */
export async function getNotConfirmedPatientConsultations(req, res) {
    try {
        const { patientId } = req.params;

        if (!patientId) {
            return sendError(res, 400, 'Patient ID is required');
        }

        const consultations = await ConsultationsService.getNotConfirmedPatientConsultations(patientId);
        return sendResponse(res, 200, 'Pending consultations retrieved successfully', consultations);
    } catch (error) {
        console.error('Error fetching pending consultations:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * GET /consultations/doctor/{id}
 * Get all consultations for a doctor
 */
export async function getDoctorConsultations(req, res) {
    try {
        const { doctorId } = req.params;

        if (!doctorId) {
            return sendError(res, 400, 'Doctor ID is required');
        }

        const consultations = await ConsultationsService.getDoctorConsultations(doctorId);
        return sendResponse(res, 200, 'Doctor consultations retrieved successfully', consultations);
    } catch (error) {
        console.error('Error fetching doctor consultations:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * GET /consultations/doctor/{id}/upcoming
 * Get upcoming consultations for a doctor
 */
export async function getUpcomingDoctorConsultations(req, res) {
    try {
        const { doctorId } = req.params;

        if (!doctorId) {
            return sendError(res, 400, 'Doctor ID is required');
        }

        const consultations = await ConsultationsService.getUpcomingDoctorConsultations(doctorId);
        return sendResponse(res, 200, 'Upcoming consultations retrieved successfully', consultations);
    } catch (error) {
        console.error('Error fetching upcoming consultations:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * GET /consultations/doctor/{id}/past
 * Get past consultations for a doctor
 */
export async function getPastDoctorConsultations(req, res) {
    try {
        const { doctorId } = req.params;

        if (!doctorId) {
            return sendError(res, 400, 'Doctor ID is required');
        }

        const consultations = await ConsultationsService.getPastDoctorConsultations(doctorId);
        return sendResponse(res, 200, 'Past consultations retrieved successfully', consultations);
    } catch (error) {
        console.error('Error fetching past consultations:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * GET /consultations/patient/{id}/prescriptions
 * Get prescriptions for a patient
 */
export async function getPatientPrescriptions(req, res) {
    try {
        const { patientId } = req.params;

        if (!patientId) {
            return sendError(res, 400, 'Patient ID is required');
        }

        const prescriptions = await ConsultationsService.getPatientPrescriptions(patientId);
        return sendResponse(res, 200, 'Prescriptions retrieved successfully', prescriptions);
    } catch (error) {
        console.error('Error fetching prescriptions:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * POST /consultations/book
 * Book a consultation
 * Body: { patientId, doctorId, availabilityId, consultationDate, startTime }
 */
export async function bookConsultation(req, res) {
    try {
        const { patientId, doctorId, availabilityId, consultationDate, startTime } = req.body;

        const consultation = await ConsultationsService.bookConsultation(
            patientId,
            doctorId,
            availabilityId,
            consultationDate,
            startTime
        );

        return sendResponse(res, 201, 'Consultation booked successfully', consultation);
    } catch (error) {
        console.error('Error booking consultation:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * PUT /consultations/{id}/status
 * Update consultation status
 * Body: { status: 'pending' | 'scheduled' | 'completed' | 'cancelled' }
 */
export async function updateConsultationStatus(req, res) {
    try {
        const { id } = req.params;
        const { status } = req.body;

        if (!status) {
            return sendError(res, 400, 'Status is required');
        }

        const consultation = await ConsultationsService.updateConsultationStatus(id, status);
        return sendResponse(res, 200, 'Consultation status updated successfully', consultation);
    } catch (error) {
        console.error('Error updating consultation status:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * PUT /consultations/{id}/cancel
 * Cancel a consultation
 */
export async function cancelConsultation(req, res) {
    try {
        const { id } = req.params;

        const consultation = await ConsultationsService.cancelConsultation(id);
        return sendResponse(res, 200, 'Consultation cancelled successfully', consultation);
    } catch (error) {
        console.error('Error cancelling consultation:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * PUT /consultations/{id}/complete
 * Complete a consultation
 */
export async function completeConsultation(req, res) {
    try {
        const { id } = req.params;

        const consultation = await ConsultationsService.completeConsultation(id);
        return sendResponse(res, 200, 'Consultation completed successfully', consultation);
    } catch (error) {
        console.error('Error completing consultation:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * POST /consultations/{id}/prescription
 * Add prescription to a consultation
 * Body: { prescription }
 */
export async function addPrescription(req, res) {
    try {
        const { id } = req.params;
        const { prescription } = req.body;

        if (!prescription) {
            return sendError(res, 400, 'Prescription is required');
        }

        const consultation = await ConsultationsService.addPrescription(id, prescription);
        return sendResponse(res, 200, 'Prescription added successfully', consultation);
    } catch (error) {
        console.error('Error adding prescription:', error);
        return sendError(res, 500, error.message);
    }
}

/**
 * DELETE /consultations/{id}
 * Delete a consultation (only for pending/cancelled)
 */
export async function deleteConsultation(req, res) {
    try {
        const { id } = req.params;

        await ConsultationsService.deleteConsultation(id);
        return sendResponse(res, 200, 'Consultation deleted successfully', {});
    } catch (error) {
        console.error('Error deleting consultation:', error);
        return sendError(res, 500, error.message);
    }
}
