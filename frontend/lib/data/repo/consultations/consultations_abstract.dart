import 'package:afia_plus_app/models/consultation.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';

abstract class ConsultationsRepository {
  /// Get all consultations for a patient
  Future<List<ConsultationWithDetails>> getPatientConsultations(int patientId);

  /// Get all consultations for a doctor
  Future<List<ConsultationWithDetails>> getDoctorConsultations(int doctorId);

  /// Get confirmed consultations for a patient (scheduled or completed)
  Future<List<ConsultationWithDetails>> getConfirmedPatientConsultations(int patientId);

  /// Get not confirmed consultations for a patient (pending)
  Future<List<ConsultationWithDetails>> getNotConfirmedPatientConsultations(int patientId);

  /// Get upcoming consultations for a doctor (scheduled or pending)
  Future<List<ConsultationWithDetails>> getUpcomingDoctorConsultations(int doctorId);

  /// Get past consultations for a doctor (completed)
  Future<List<ConsultationWithDetails>> getPastDoctorConsultations(int doctorId);

  /// Get consultations with prescriptions for a patient
  Future<List<ConsultationWithDetails>> getPatientPrescriptions(int patientId);

  /// Create a new consultation
  Future<int> createConsultation(Consultation consultation);

  /// Update consultation status
  Future<void> updateConsultationStatus(int consultationId, String status);

  /// Update consultation prescription
  Future<void> updateConsultationPrescription(int consultationId, String prescription);

  /// Delete a consultation
  Future<void> deleteConsultation(int consultationId);

  /// Get consultation by ID
  Future<ConsultationWithDetails?> getConsultationById(int consultationId);
}

