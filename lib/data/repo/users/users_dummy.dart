import 'users_abstract.dart';

class UsersDummy implements UsersRepo {
  List<Map<String, dynamic>> users = [
    {
      'user_id': 1,
      'role': 'patient',
      'firstname': 'Sara',
      'lastname': 'Benali',
      'email': 'sara@mail.com',
      'password': '12345',
      'phone_number': '0550xxxxxx',
      'nin': '123456789'
    },
    {
      'user_id': 2,
      'role': 'doctor',
      'firstname': 'Adam',
      'lastname': 'Mansouri',
      'email': 'adam@mail.com',
      'password': '12345',
      'phone_number': '0661xxxxxx',
      'nin': '987654321'
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    return users;
  }

  @override
  Future<int> addUser(Map<String, dynamic> data) async {
    data['user_id'] = users.length + 1;
    users.add(data);
    return 1;
  }

  @override
  Future<int> updateUser(int id, Map<String, dynamic> data) async {
    final index = users.indexWhere((e) => e['user_id'] == id);
    if (index != -1) {
      users[index] = {...users[index], ...data};
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteUser(int id) async {
    users.removeWhere((e) => e['user_id'] == id);
    return 1;
  }

  @override
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    return users.firstWhere(
      (u) => u['email'] == email,
      orElse: () => {},
    );
  }
}
