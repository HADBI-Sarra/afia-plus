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

  DateTime? _parseDateTime(String rawDate, String rawTime) {
    // Accept both yyyy-MM-dd and dd/MM/yyyy to support stored / displayed values
    final normalizedDate = rawDate.contains('/') ? rawDate.split('/') : rawDate.split('-');
    final timeParts = rawTime.split(':');

    if (normalizedDate.length != 3 || timeParts.length < 2) return null;
    try {
      // If first part has 4 chars assume yyyy-MM-dd else dd/MM/yyyy
      final isYearFirst = normalizedDate[0].length == 4;
      final year = int.parse(isYearFirst ? normalizedDate[0] : normalizedDate[2]);
      final month = int.parse(normalizedDate[1]);
      final day = int.parse(isYearFirst ? normalizedDate[2] : normalizedDate[0]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return DateTime.tryParse('$rawDate $rawTime');
    }
  }

  bool _isPastAppointment(ConsultationWithDetails consultation) {
    final date = _parseDateTime(
      consultation.consultation.consultationDate,
      consultation.consultation.startTime,
    );
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }

  Future<void> loadAppointments(int doctorId) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final allUpcoming = await _repository.getUpcomingDoctorConsultations(doctorId);
      final past = await _repository.getPastDoctorConsultations(doctorId);
      // Separate by status and combine as needed
      final scheduled = allUpcoming.where((c) => c.consultation.status == 'scheduled');
      final pending = allUpcoming.where((c) => c.consultation.status == 'pending');
      final combinedUpcoming = <ConsultationWithDetails>[...pending, ...scheduled];

      // Move any pending/scheduled consultations whose date already passed to past list
      final expired = combinedUpcoming.where(_isPastAppointment).toList();
      final upcomingFiltered = combinedUpcoming.where((c) => !_isPastAppointment(c)).toList();
      
      emit(state.copyWith(
        upcomingAppointments: upcomingFiltered,
        pastAppointments: [...past, ...expired],
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

