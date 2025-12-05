import 'users_abstract.dart';

class UsersDummy implements UsersRepo {
  final List<Map<String, dynamic>> dummyUsers = [];

  @override
  Future<int> insertUser(Map<String, dynamic> data) async {
    dummyUsers.add(data);
    return 1;
  }

  @override
  Future<Map<String, dynamic>?> getUserById(int id) async {
    return dummyUsers.firstWhere((u) => u['user_id'] == id);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return dummyUsers;
  }

  @override
  Future<int> deleteUser(int id) async {
    dummyUsers.removeWhere((u) => u['user_id'] == id);
    return 1;
  }
}
