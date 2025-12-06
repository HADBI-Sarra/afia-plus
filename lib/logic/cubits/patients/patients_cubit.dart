import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/patient.dart';
import '../../../data/models/result.dart';
import '../../../data/repo/patients/patient_repository.dart';

class PatientCubit extends Cubit<Map<String, dynamic>> {
  late final PatientRepository patientRepo;

  PatientCubit() : super({'data': [], 'state': 'loading', 'message': ''}) {
    patientRepo = GetIt.I<PatientRepository>();
    loadPatients();
  }

  Future<bool> loadPatients() async {
    emit({...state, 'state': 'loading', 'message': '', 'data': []});

    try {
      final result = await patientRepo.getAllPatients();

      if (result.state) {
        emit({
          ...state,
          'data': result.data ?? [],
          'state': 'done',
          'message': ''
        });
      } else {
        emit({
          ...state,
          'state': 'error',
          'message': result.message,
          'data': []
        });
      }
    } catch (e) {
      emit({...state, 'state': 'error', 'message': e.toString(), 'data': []});
    }

    return true;
  }

  Future<ReturnResult<Patient>> createPatient(Patient patient) async {
    try {
      final result = await patientRepo.createPatient(patient);
      await loadPatients();
      return result;
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult<Patient>> updatePatient(Patient patient) async {
    try {
      final result = await patientRepo.updatePatient(patient);
      await loadPatients();
      return result;
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult> deletePatient(int id) async {
    try {
      final result = await patientRepo.deletePatient(id);
      await loadPatients();
      return result;
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult<Patient?>> getPatientById(int id) async {
    try {
      return await patientRepo.getPatientById(id);
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }
}
