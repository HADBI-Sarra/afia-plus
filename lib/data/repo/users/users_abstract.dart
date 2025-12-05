abstract class UsersRepo {
  Future<int> insertUser(Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getUserById(int id);
  Future<List<Map<String, dynamic>>> getAllUsers();
  Future<int> deleteUser(int id);
}
