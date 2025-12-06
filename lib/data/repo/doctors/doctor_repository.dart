import '../../models/doctor.dart';
import '../../models/result.dart';

abstract class DoctorRepository {
	Future<ReturnResult<Doctor>> createDoctor(Doctor doctor);
	Future<ReturnResult<Doctor?>> getDoctorById(int id);
	Future<ReturnResult<List<Doctor>>> getAllDoctors();
	Future<ReturnResult<Doctor>> updateDoctor(Doctor doctor);
	Future<ReturnResult> deleteDoctor(int id);
}

