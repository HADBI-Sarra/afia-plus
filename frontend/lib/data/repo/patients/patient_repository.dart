import '../../models/patient.dart';
import '../../models/result.dart';

abstract class PatientRepository {
  Future<ReturnResult<Patient>> createPatient(Patient patient);
  Future<ReturnResult<Patient?>> getPatientById(int id);
  Future<ReturnResult<List<Patient>>> getAllPatients();
  Future<ReturnResult<Patient>> updatePatient(Patient patient);
  Future<ReturnResult> deletePatient(int id);
}
