import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';

class DoctorHomeState {
  final List<ConsultationWithDetails> comingConsultations;
  final List<ConsultationWithDetails> pendingConsultations;
  final bool isLoading;
  final String? error;
  final Set<int> processingConsultationIds; // Track consultations being processed

  DoctorHomeState({
    this.comingConsultations = const [],
    this.pendingConsultations = const [],
    this.isLoading = false,
    this.error,
    this.processingConsultationIds = const {},
  });

  DoctorHomeState copyWith({
    List<ConsultationWithDetails>? comingConsultations,
    List<ConsultationWithDetails>? pendingConsultations,
    bool? isLoading,
    String? error,
    Set<int>? processingConsultationIds,
  }) {
    return DoctorHomeState(
      comingConsultations: comingConsultations ?? this.comingConsultations,
      pendingConsultations: pendingConsultations ?? this.pendingConsultations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      processingConsultationIds: processingConsultationIds ?? this.processingConsultationIds,
    );
  }
}

class DoctorHomeCubit extends Cubit<DoctorHomeState> {
  final ConsultationsImpl _repository;

  DoctorHomeCubit({ConsultationsImpl? repository})
      : _repository = repository ?? ConsultationsImpl(),
        super(DoctorHomeState());

  Future<void> loadConsultations(int doctorId) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final upcoming = await _repository.getUpcomingDoctorConsultations(doctorId);
      
      // Separate into coming (scheduled) and pending
      final coming = upcoming
          .where((c) => c.consultation.status == 'scheduled')
          .take(2)
          .toList();
      final pending = upcoming
          .where((c) => c.consultation.status == 'pending')
          .take(2)
          .toList();
      
      emit(state.copyWith(
        comingConsultations: coming,
        pendingConsultations: pending,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> acceptConsultation(int consultationId, int doctorId) async {
    try {
      emit(state.copyWith(
        processingConsultationIds: {...state.processingConsultationIds, consultationId},
      ));
      
      await _repository.updateConsultationStatus(consultationId, 'scheduled');
      await loadConsultations(doctorId);
      
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

  Future<void> rejectConsultation(int consultationId, int doctorId) async {
    try {
      print('🔄 Rejecting consultation $consultationId...');
      emit(state.copyWith(
        processingConsultationIds: {...state.processingConsultationIds, consultationId},
      ));
      
      await _repository.updateConsultationStatus(consultationId, 'cancelled');
      print('✅ Status updated in database');
      
      // Reload consultations to reflect the change
      final upcoming = await _repository.getUpcomingDoctorConsultations(doctorId);
      print('📋 Reloaded: ${upcoming.length} upcoming consultations');
      
      // Separate into coming (scheduled) and pending
      final coming = upcoming
          .where((c) => c.consultation.status == 'scheduled')
          .take(2)
          .toList();
      final pending = upcoming
          .where((c) => c.consultation.status == 'pending')
          .take(2)
          .toList();
      
      print('📊 Separated: ${coming.length} coming, ${pending.length} pending');
      
      final newProcessingSet = Set<int>.from(state.processingConsultationIds)..remove(consultationId);
      emit(state.copyWith(
        comingConsultations: coming,
        pendingConsultations: pending,
        processingConsultationIds: newProcessingSet,
        error: null,
      ));
      print('✅ State updated successfully');
    } catch (e, stackTrace) {
      print('❌ Error rejecting consultation: $e');
      print('Stack trace: $stackTrace');
      final newProcessingSet = Set<int>.from(state.processingConsultationIds)..remove(consultationId);
      emit(state.copyWith(
        error: e.toString(),
        processingConsultationIds: newProcessingSet,
      ));
      rethrow; // Re-throw to let the UI handle it
    }
  }

  Future<void> refreshConsultations(int doctorId) async {
    await loadConsultations(doctorId);
  }
}

