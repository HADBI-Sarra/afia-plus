import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/utils/logger.dart';

class PatientHomeState {
  final List<ConsultationWithDetails> upcomingConsultations;
  final bool isLoading;
  final String? error;
  final Set<int>
  deletingConsultationIds; // Track which consultations are being deleted

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
      upcomingConsultations:
          upcomingConsultations ?? this.upcomingConsultations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      deletingConsultationIds:
          deletingConsultationIds ?? this.deletingConsultationIds,
    );
  }
}

class PatientHomeCubit extends Cubit<PatientHomeState> {
  final ConsultationsImpl _repository;

  PatientHomeCubit({ConsultationsImpl? repository})
    : _repository = repository ?? ConsultationsImpl(),
      super(PatientHomeState());

  DateTime? _parseDateTime(String rawDate, String rawTime) {
    final normalizedDate = rawDate.contains('/')
        ? rawDate.split('/')
        : rawDate.split('-');
    final timeParts = rawTime.split(':');
    if (normalizedDate.length != 3 || timeParts.length < 2) return null;
    try {
      final isYearFirst = normalizedDate[0].length == 4;
      final year = int.parse(
        isYearFirst ? normalizedDate[0] : normalizedDate[2],
      );
      final month = int.parse(normalizedDate[1]);
      final day = int.parse(
        isYearFirst ? normalizedDate[2] : normalizedDate[0],
      );
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
    return !date.isAfter(
      DateTime.now(),
    ); // only consider "upcoming" if start time > now
  }

  Future<void> loadUpcomingConsultations(int patientId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final confirmed = await _repository.getConfirmedPatientConsultations(
        patientId,
      );

      // Show both pending and scheduled as "coming" on home; limit to 2 for brevity
      final scheduled = confirmed.where(
        (c) => c.consultation.status == 'scheduled',
      );
      // Only show scheduled (accepted) as coming consultations (not pending)
      final upcoming = scheduled
          .where((c) => !_isPastAppointment(c))
          .take(2)
          .toList();

      emit(state.copyWith(upcomingConsultations: upcoming, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> refreshConsultations(int patientId) async {
    await loadUpcomingConsultations(patientId);
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

      // Reload upcoming consultations
      AppLogger.log('  Step 3: Reloading consultations');
      await loadUpcomingConsultations(patientId);

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
}
