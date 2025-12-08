import 'package:afia_plus_app/data/repo/consultations/consultations_abstract.dart';
import 'package:afia_plus_app/models/consultation.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';

class ConsultationsDummyRepository implements ConsultationsRepository {
  @override
  Future<List<ConsultationWithDetails>> getPatientConsultations(int patientId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      ConsultationWithDetails(
        consultation: Consultation(
          consultationId: 1,
          patientId: patientId,
          doctorId: 1,
          consultationDate: '2025-11-12',
          startTime: '12:00',
          status: 'scheduled',
        ),
        doctorFirstName: 'Mohamed',
        doctorLastName: 'Brahimi',
        doctorSpecialty: 'Cardiologist',
        doctorImagePath: 'assets/images/doctorBrahimi.png',
      ),
      ConsultationWithDetails(
        consultation: Consultation(
          consultationId: 2,
          patientId: patientId,
          doctorId: 2,
          consultationDate: '2025-11-13',
          startTime: '10:00',
          status: 'scheduled',
        ),
        doctorFirstName: 'Righi',
        doctorLastName: 'Sirine',
        doctorSpecialty: 'Dentist',
        doctorImagePath: 'assets/images/doctorSirine.png',
      ),
      ConsultationWithDetails(
        consultation: Consultation(
          consultationId: 3,
          patientId: patientId,
          doctorId: 3,
          consultationDate: '2025-11-15',
          startTime: '12:00',
          status: 'pending',
        ),
        doctorFirstName: 'Boukenouche',
        doctorLastName: 'Lamis',
        doctorSpecialty: 'Radiologist',
        doctorImagePath: 'assets/images/doctorLamis.png',
      ),
    ];
  }

  @override
  Future<List<ConsultationWithDetails>> getDoctorConsultations(int doctorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<List<ConsultationWithDetails>> getConfirmedPatientConsultations(int patientId) async {
    final all = await getPatientConsultations(patientId);
    return all.where((c) => c.consultation.isConfirmed).toList();
  }

  @override
  Future<List<ConsultationWithDetails>> getNotConfirmedPatientConsultations(int patientId) async {
    final all = await getPatientConsultations(patientId);
    return all.where((c) => c.consultation.isPending).toList();
  }

  @override
  Future<List<ConsultationWithDetails>> getUpcomingDoctorConsultations(int doctorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<List<ConsultationWithDetails>> getPastDoctorConsultations(int doctorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<List<ConsultationWithDetails>> getPatientPrescriptions(int patientId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<int> createConsultation(Consultation consultation) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 1;
  }

  @override
  Future<void> updateConsultationStatus(int consultationId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> updateConsultationPrescription(int consultationId, String prescription) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> deleteConsultation(int consultationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<ConsultationWithDetails?> getConsultationById(int consultationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return null;
  }
}

