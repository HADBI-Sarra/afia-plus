import 'package:afia_plus_app/data/db_helper.dart';
import 'users_abstract.dart';

class UsersImpl implements UsersRepo {
  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DBHelper.getDatabase();
    return await db.query('users');
  }

  @override
  Future<int> addUser(Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('users', data);
  }

  @override
  Future<int> updateUser(int id, Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();
    return await db.update(
      'users',
      data,
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteUser(int id) async {
    final db = await DBHelper.getDatabase();
    return await db.delete(
      'users',
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await DBHelper.getDatabase();
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
