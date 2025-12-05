import 'package:afia_plus_app/data/db_helper.dart';

import 'users_abstract.dart';

class UsersImpl implements UsersRepo {
  @override
  Future<int> insertUser(Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('users', data);
  }

  @override
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await DBHelper.getDatabase();
    final result = await db.query(
      'users',
      where: 'user_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await DBHelper.getDatabase();
    return await db.query('users');
  }

  @override
  Future<int> deleteUser(int id) async {
    final db = await DBHelper.getDatabase();
    return await db.delete('users', where: 'user_id = ?', whereArgs: [id]);
  }
}
