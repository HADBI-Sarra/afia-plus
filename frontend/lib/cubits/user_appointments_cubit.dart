import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/utils/logger.dart';
import 'package:afia_plus_app/utils/logger.dart';

class UserAppointmentsState {
  final List<ConsultationWithDetails> confirmedAppointments;
  final List<ConsultationWithDetails> notConfirmedAppointments;
  final bool isLoading;
  final String? error;
  final Set<int>
  deletingConsultationIds; // Track which consultations are being deleted

  UserAppointmentsState({
    this.confirmedAppointments = const [],
    this.notConfirmedAppointments = const [],
    this.isLoading = false,
    this.error,
    this.deletingConsultationIds = const {},
  });

  UserAppointmentsState copyWith({
    List<ConsultationWithDetails>? confirmedAppointments,
    List<ConsultationWithDetails>? notConfirmedAppointments,
    bool? isLoading,
    String? error,
    Set<int>? deletingConsultationIds,
  }) {
    return UserAppointmentsState(
      confirmedAppointments:
          confirmedAppointments ?? this.confirmedAppointments,
      notConfirmedAppointments:
          notConfirmedAppointments ?? this.notConfirmedAppointments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      deletingConsultationIds:
          deletingConsultationIds ?? this.deletingConsultationIds,
    );
  }
}

class UserAppointmentsCubit extends Cubit<UserAppointmentsState> {
  final ConsultationsImpl _repository;

  UserAppointmentsCubit({ConsultationsImpl? repository})
    : _repository = repository ?? ConsultationsImpl(),
      super(UserAppointmentsState());

  Future<void> loadAppointments(int patientId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final confirmed = await _repository.getConfirmedPatientConsultations(
        patientId,
      );
      final notConfirmed = await _repository
          .getNotConfirmedPatientConsultations(patientId);

      emit(
        state.copyWith(
          confirmedAppointments: confirmed,
          notConfirmedAppointments: notConfirmed,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteAppointment(int consultationId, int patientId) async {
    try {
      AppLogger.log('🗑️ Cancelling appointment $consultationId...');
      // Add to deleting set
      emit(
        state.copyWith(
          deletingConsultationIds: {
            ...state.deletingConsultationIds,
            consultationId,
          },
        ),
      );

      // First, update status to 'cancelled' so the appointment can be deleted
      AppLogger.log('  Step 1: Updating status to cancelled');
      await _repository.updateConsultationStatus(consultationId, 'cancelled');

      // Then delete the consultation
      AppLogger.log('  Step 2: Deleting consultation');
      await _repository.deleteConsultation(consultationId);

      // Reload appointments to reflect changes
      AppLogger.log('  Step 3: Reloading appointments');
      await loadAppointments(patientId);

      // Remove from deleting set
      final newDeletingSet = Set<int>.from(state.deletingConsultationIds)
        ..remove(consultationId);
      emit(state.copyWith(deletingConsultationIds: newDeletingSet));
      AppLogger.success('✅ Appointment cancelled and deleted successfully');
    } catch (e) {
      AppLogger.error('❌ Error deleting appointment: $e');
      // Remove from deleting set on error
      final newDeletingSet = Set<int>.from(state.deletingConsultationIds)
        ..remove(consultationId);
      emit(
        state.copyWith(
          error: e.toString(),
          deletingConsultationIds: newDeletingSet,
        ),
      );
    }
  }

  Future<void> refreshAppointments(int patientId) async {
    await loadAppointments(patientId);
  }
}
