import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../../models/patient.dart';
import '../../models/result.dart';
import '../../api/api_client.dart';
import './patient_repository.dart';
import '../auth/token_provider.dart';

class SupabasePatientRepository implements PatientRepository {
  final TokenProvider _tokenProvider = GetIt.instance<TokenProvider>();

  String? get _token => _tokenProvider.accessToken;

  void _ensureAuthenticated() {
    if (_token == null) {
      throw Exception('User not authenticated');
    }
  }

  @override
  Future<ReturnResult<Patient?>> getPatientById(int id) async {
    try {
      _ensureAuthenticated();

      // ID ignored — backend derives patient from token
      final response = await ApiClient.get(
        '/patients/me',
        token: _token,
      );

      if (response.statusCode != 200) {
        return ReturnResult(
          state: false,
          message: 'Patient not found',
        );
      }

      return ReturnResult(
        state: true,
        message: 'Patient loaded',
        data: Patient.fromMap(jsonDecode(response.body)),
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
  Future<ReturnResult<Patient>> updatePatient(Patient patient) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Patient update via user endpoint',
      ),
    );
  }

  @override
  Future<ReturnResult<List<Patient>>> getAllPatients() {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Admin only',
      ),
    );
  }

  @override
  Future<ReturnResult<Patient>> createPatient(Patient patient) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Handled during signup',
      ),
    );
  }

  @override
  Future<ReturnResult> deletePatient(int id) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Not allowed',
      ),
    );
  }
}
