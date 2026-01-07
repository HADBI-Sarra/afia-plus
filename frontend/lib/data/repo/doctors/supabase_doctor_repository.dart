import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../../models/doctor.dart';
import '../../models/result.dart';
import '../../models/review.dart';
import '../../api/api_client.dart';
import './doctor_repository.dart';
import '../auth/token_provider.dart';

class SupabaseDoctorRepository implements DoctorRepository {
  final TokenProvider _tokenProvider = GetIt.instance<TokenProvider>();

  String? get _token => _tokenProvider.accessToken;

  void _ensureAuthenticated() {
    if (_token == null) {
      throw Exception('User not authenticated');
    }
  }

  @override
  Future<ReturnResult<Doctor?>> getDoctorById(int id) async {
    try {
      // For patient view: fetch doctor profile by id (token optional)
      final response = await ApiClient.get('/doctors/profile/$id', token: _token);

      if (response.statusCode != 200) {
        return ReturnResult(
          state: false,
          message: 'Doctor not found',
        );
      }

      return ReturnResult(
        state: true,
        message: 'Doctor loaded',
        data: Doctor.fromMap(jsonDecode(response.body)),
      );
    } catch (e) {
      return ReturnResult(
        state: false,
        message: e.toString(),
      );
    }
  }

  // ---------- Unsupported / restricted ----------

  @override
  Future<ReturnResult<Doctor>> createDoctor(Doctor doctor) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Handled during signup',
      ),
    );
  }

  @override
  Future<ReturnResult<Doctor>> updateDoctor(Doctor doctor) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Doctor update via user endpoint',
      ),
    );
  }

  @override
  Future<ReturnResult<List<Doctor>>> getAllDoctors() {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Admin only',
      ),
    );
  }

  @override
  Future<ReturnResult> deleteDoctor(int id) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Not allowed',
      ),
    );
  }

  @override
  Future<ReturnResult<List<Review>>> getReviewsByDoctorId(int doctorId) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Not implemented',
      ),
    );
  }
}

