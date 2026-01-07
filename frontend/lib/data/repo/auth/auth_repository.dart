import '../../models/user.dart';
import '../../models/result.dart';
import '../../models/patient.dart';
import '../../models/doctor.dart';

abstract class AuthRepository {
  Future<ReturnResult<User>> login(String email, String password);
  Future<ReturnResult<User>> signup(User user, String password, {Patient? patientData, Doctor? doctorData});
  Future<ReturnResult> logout();
  Future<ReturnResult<User?>> getCurrentUser();
  Future<bool> emailExists(String email);
  Future<ReturnResult<String>> uploadProfilePicture(String imagePath);
}
