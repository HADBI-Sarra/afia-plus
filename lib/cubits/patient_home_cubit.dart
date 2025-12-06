import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_abstract.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';

class PatientHomeState {
  final List<ConsultationWithDetails> upcomingConsultations;
  final bool isLoading;
  final String? error;
  final Set<int> deletingConsultationIds; // Track which consultations are being deleted

  PatientHomeState({
    this.upcomingConsultations = const [],
    this.isLoading = false,
    this.error,
    this.deletingConsultationIds = const {},
  });

  PatientHomeState copyWith({
    List<ConsultationWithDetails>? upcomingConsultations,
    bool? isLoading,
    String? error,
    Set<int>? deletingConsultationIds,
  }) {
    return PatientHomeState(
      upcomingConsultations: upcomingConsultations ?? this.upcomingConsultations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      deletingConsultationIds: deletingConsultationIds ?? this.deletingConsultationIds,
    );
  }
}

class PatientHomeCubit extends Cubit<PatientHomeState> {
  final ConsultationsRepository _repository;

  PatientHomeCubit({ConsultationsRepository? repository})
      : _repository = repository ?? ConsultationsRepositoryImpl(),
        super(PatientHomeState());

  Future<void> loadUpcomingConsultations(int patientId) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final consultations = await _repository.getConfirmedPatientConsultations(patientId);
      // Filter to show only upcoming (scheduled) consultations, limit to 1-2 for home screen
      final upcoming = consultations
          .where((c) => c.consultation.status == 'scheduled')
          .take(2)
          .toList();
      
      emit(state.copyWith(
        upcomingConsultations: upcoming,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> refreshConsultations(int patientId) async {
    await loadUpcomingConsultations(patientId);
  }

  Future<void> deleteAppointment(int consultationId, int patientId) async {
    try {
      // Add to deleting set
      emit(state.copyWith(
        deletingConsultationIds: {...state.deletingConsultationIds, consultationId},
      ));
      
      await _repository.deleteConsultation(consultationId);
      await loadUpcomingConsultations(patientId);
      
      // Remove from deleting set
      final newDeletingSet = Set<int>.from(state.deletingConsultationIds)..remove(consultationId);
      emit(state.copyWith(deletingConsultationIds: newDeletingSet));
    } catch (e) {
      // Remove from deleting set on error
      final newDeletingSet = Set<int>.from(state.deletingConsultationIds)..remove(consultationId);
      emit(state.copyWith(
        error: e.toString(),
        deletingConsultationIds: newDeletingSet,
      ));
    }
  }
}

