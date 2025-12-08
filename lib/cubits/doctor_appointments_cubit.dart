import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/utils/pdf_service.dart';
import 'dart:io';

class DoctorAppointmentsState {
  final List<ConsultationWithDetails> upcomingAppointments;
  final List<ConsultationWithDetails> pastAppointments;
  final bool isLoading;
  final String? error;
  final Set<int> processingConsultationIds; // Track consultations being processed

  DoctorAppointmentsState({
    this.upcomingAppointments = const [],
    this.pastAppointments = const [],
    this.isLoading = false,
    this.error,
    this.processingConsultationIds = const {},
  });

  DoctorAppointmentsState copyWith({
    List<ConsultationWithDetails>? upcomingAppointments,
    List<ConsultationWithDetails>? pastAppointments,
    bool? isLoading,
    String? error,
    Set<int>? processingConsultationIds,
  }) {
    return DoctorAppointmentsState(
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      pastAppointments: pastAppointments ?? this.pastAppointments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      processingConsultationIds: processingConsultationIds ?? this.processingConsultationIds,
    );
  }
}

class DoctorAppointmentsCubit extends Cubit<DoctorAppointmentsState> {
  final ConsultationsImpl _repository;

  DoctorAppointmentsCubit({ConsultationsImpl? repository})
      : _repository = repository ?? ConsultationsImpl(),
        super(DoctorAppointmentsState());

  Future<void> loadAppointments(int doctorId) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final upcoming = await _repository.getUpcomingDoctorConsultations(doctorId);
      final past = await _repository.getPastDoctorConsultations(doctorId);
      
      emit(state.copyWith(
        upcomingAppointments: upcoming,
        pastAppointments: past,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> acceptAppointment(int consultationId, int doctorId) async {
    try {
      emit(state.copyWith(
        processingConsultationIds: {...state.processingConsultationIds, consultationId},
      ));
      
      await _repository.updateConsultationStatus(consultationId, 'scheduled');
      await loadAppointments(doctorId);
      
      final newProcessingSet = Set<int>.from(state.processingConsultationIds)..remove(consultationId);
      emit(state.copyWith(processingConsultationIds: newProcessingSet));
    } catch (e) {
      final newProcessingSet = Set<int>.from(state.processingConsultationIds)..remove(consultationId);
      emit(state.copyWith(
        error: e.toString(),
        processingConsultationIds: newProcessingSet,
      ));
    }
  }

  Future<void> rejectAppointment(int consultationId, int doctorId) async {
    try {
      print('🔄 Rejecting appointment $consultationId...');
      emit(state.copyWith(
        processingConsultationIds: {...state.processingConsultationIds, consultationId},
      ));
      
      await _repository.updateConsultationStatus(consultationId, 'cancelled');
      print('✅ Status updated in database');
      
      // Reload appointments to reflect the change
      final upcoming = await _repository.getUpcomingDoctorConsultations(doctorId);
      final past = await _repository.getPastDoctorConsultations(doctorId);
      
      print('📋 Reloaded: ${upcoming.length} upcoming, ${past.length} past appointments');
      
      final newProcessingSet = Set<int>.from(state.processingConsultationIds)..remove(consultationId);
      emit(state.copyWith(
        upcomingAppointments: upcoming,
        pastAppointments: past,
        processingConsultationIds: newProcessingSet,
        error: null,
      ));
      print('✅ State updated successfully');
    } catch (e, stackTrace) {
      print('❌ Error rejecting appointment: $e');
      print('Stack trace: $stackTrace');
      final newProcessingSet = Set<int>.from(state.processingConsultationIds)..remove(consultationId);
      emit(state.copyWith(
        error: e.toString(),
        processingConsultationIds: newProcessingSet,
      ));
      rethrow; // Re-throw to let the UI handle it
    }
  }

  Future<void> uploadPrescriptionPDF(int consultationId, File pdfFile, String prescriptionText) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      
      // Save PDF to app's documents directory and get the stored path
      final storedPath = await PDFService.saveUploadedPDF(pdfFile, consultationId);
      
      // Store PDF path in database (prescription field now stores the path)
      await _repository.updateConsultationPrescription(consultationId, storedPath);
      
      // Reload appointments to reflect the update
      final doctorId = state.upcomingAppointments.isNotEmpty 
          ? state.upcomingAppointments.first.consultation.doctorId
          : state.pastAppointments.isNotEmpty
              ? state.pastAppointments.first.consultation.doctorId
              : 1;
      
      await loadAppointments(doctorId);
      
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to upload PDF: ${e.toString()}',
      ));
    }
  }

  Future<void> refreshAppointments(int doctorId) async {
    await loadAppointments(doctorId);
  }
}

