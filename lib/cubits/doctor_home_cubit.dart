import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';

class DoctorHomeState {
  final List<ConsultationWithDetails> comingConsultations;
  final List<ConsultationWithDetails> pendingConsultations;
  final int todayConsultations;
  final int pendingConsultationsCount;
  final int totalPatients;
  final bool isLoading;
  final String? error;
  final Set<int> processingConsultationIds; // Track consultations being processed

  DoctorHomeState({
    this.comingConsultations = const [],
    this.pendingConsultations = const [],
    this.todayConsultations = 0,
    this.pendingConsultationsCount = 0,
    this.totalPatients = 0,
    this.isLoading = false,
    this.error,
    this.processingConsultationIds = const {},
  });

  DoctorHomeState copyWith({
    List<ConsultationWithDetails>? comingConsultations,
    List<ConsultationWithDetails>? pendingConsultations,
    int? todayConsultations,
    int? pendingConsultationsCount,
    int? totalPatients,
    bool? isLoading,
    String? error,
    Set<int>? processingConsultationIds,
  }) {
    return DoctorHomeState(
      comingConsultations: comingConsultations ?? this.comingConsultations,
      pendingConsultations: pendingConsultations ?? this.pendingConsultations,
      todayConsultations: todayConsultations ?? this.todayConsultations,
      pendingConsultationsCount: pendingConsultationsCount ?? this.pendingConsultationsCount,
      totalPatients: totalPatients ?? this.totalPatients,
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

  /// Calculate overview stats from consultation data
  void _updateOverviewStats(List<ConsultationWithDetails> upcoming, List<ConsultationWithDetails> past) {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];

    // Today: scheduled only, scheduled for today
    final todayConsults = upcoming.where((c) =>
      c.consultation.status == 'scheduled' && c.consultation.consultationDate == todayStr
    ).length;

    // Pending: all upcoming with status 'pending'
    final pendingConsults = upcoming.where((c) =>
      c.consultation.status == 'pending'
    ).length;

    // Unique patients from COMPLETED
    final completedConsults = past.where((c) => c.consultation.status == 'completed');
    final uniquePatientIds = <int>{};
    for (final consult in completedConsults) {
      uniquePatientIds.add(consult.consultation.patientId);
    }

    emit(state.copyWith(
      todayConsultations: todayConsults,
      pendingConsultationsCount: pendingConsults,
      totalPatients: uniquePatientIds.length,
    ));
  }

  Future<void> loadConsultations(int doctorId) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final upcoming = await _repository.getUpcomingDoctorConsultations(doctorId);
      final past = await _repository.getPastDoctorConsultations(doctorId);

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

      // Update overview stats
      _updateOverviewStats(upcoming, past);
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
      
      final past = await _repository.getPastDoctorConsultations(doctorId);
      
      final newProcessingSet = Set<int>.from(state.processingConsultationIds)..remove(consultationId);
      emit(state.copyWith(
        comingConsultations: coming,
        pendingConsultations: pending,
        processingConsultationIds: newProcessingSet,
        error: null,
      ));

      // Update overview stats
      _updateOverviewStats(upcoming, past);
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

