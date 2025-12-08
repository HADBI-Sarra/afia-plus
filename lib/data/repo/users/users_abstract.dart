abstract class UsersRepo {
  Future<List<Map<String, dynamic>>> getUsers();
  Future<int> addUser(Map<String, dynamic> data);
  Future<int> updateUser(int id, Map<String, dynamic> data);
  Future<int> deleteUser(int id);
  Future<Map<String, dynamic>?> getUserByEmail(String email);
}
