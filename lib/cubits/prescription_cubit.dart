import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_abstract.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';

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
    : _repository = repository ?? ConsultationsRepositoryImpl(),
      super(PrescriptionState());

  Future<void> loadPrescriptions(int patientId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final prescriptions = await _repository.getPatientPrescriptions(
        patientId,
      );
      emit(state.copyWith(prescriptions: prescriptions, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> refreshPrescriptions(int patientId) async {
    await loadPrescriptions(patientId);
  }
}
