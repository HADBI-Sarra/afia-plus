import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/doctor.dart';
import '../../../data/models/result.dart';
import '../../../data/models/review.dart';
import '../../../data/repo/doctors/doctor_repository.dart';

class DoctorsCubit extends Cubit<Map<String, dynamic>> {
  late final DoctorRepository doctorRepo;

  DoctorsCubit() : super({'data': [], 'state': 'loading', 'message': ''}) {
    doctorRepo = GetIt.I<DoctorRepository>();
    loadDoctors();
  }

  Future<bool> loadDoctors() async {
    emit({...state, 'state': 'loading', 'message': '', 'data': []});

    try {
      final result = await doctorRepo.getAllDoctors();

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

  Future<ReturnResult<Doctor>> createDoctor(Doctor doctor) async {
    try {
      final result = await doctorRepo.createDoctor(doctor);
      await loadDoctors();
      return result;
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult<Doctor>> updateDoctor(Doctor doctor) async {
    try {
      final result = await doctorRepo.updateDoctor(doctor);
      await loadDoctors();
      return result;
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult> deleteDoctor(int id) async {
    try {
      final result = await doctorRepo.deleteDoctor(id);
      await loadDoctors();
      return result;
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult<Doctor?>> getDoctorById(int id) async {
    try {
      return await doctorRepo.getDoctorById(id);
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult<List<Review>>> getReviewsByDoctorId(int doctorId) async {
    try {
      return await doctorRepo.getReviewsByDoctorId(doctorId);
    } catch (e) {
      return ReturnResult(state: false, message: e.toString(), data: []);
    }
  }
}
