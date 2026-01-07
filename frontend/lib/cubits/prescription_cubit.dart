import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_abstract.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/utils/logger.dart';

class PrescriptionState {
  final List<ConsultationWithDetails> prescriptions;
  final bool isLoading;
  final String? error;

  PrescriptionState({
    this.prescriptions = const [],
    this.isLoading = false,
    this.error,
  });

  PrescriptionState copyWith({
    List<ConsultationWithDetails>? prescriptions,
    bool? isLoading,
    String? error,
  }) {
    return PrescriptionState(
      prescriptions: prescriptions ?? this.prescriptions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final ConsultationsRepository _repository;

  PrescriptionCubit({ConsultationsRepository? repository})
    : _repository = repository ?? ConsultationsImpl(),
      super(PrescriptionState());

  Future<void> loadPrescriptions(int patientId) async {
    AppLogger.log('📋 Loading prescriptions for patient: $patientId');
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final prescriptions = await _repository.getPatientPrescriptions(
        patientId,
      );
      AppLogger.success('✅ Loaded ${prescriptions.length} prescriptions');
      for (var p in prescriptions) {
        AppLogger.log(
          '  - Consultation ${p.consultation.consultationId}: ${p.consultation.prescription}',
        );
      }
      emit(state.copyWith(prescriptions: prescriptions, isLoading: false));
    } catch (e) {
      AppLogger.error('❌ Error loading prescriptions: $e');
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> refreshPrescriptions(int patientId) async {
    await loadPrescriptions(patientId);
  }
}
