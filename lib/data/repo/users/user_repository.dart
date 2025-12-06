import '../../models/user.dart';
import '../../models/result.dart';

abstract class UserRepository {
  Future<ReturnResult<User>> createUser(User user);
  Future<ReturnResult<User?>> getUserById(int id);
  Future<ReturnResult<User?>> getUserByEmail(String email);
  Future<ReturnResult<List<User>>> getAllUsers();
  Future<ReturnResult<User>> updateUser(User user);
  Future<ReturnResult> deleteUser(int id);
}