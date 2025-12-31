import 'package:sqflite/sqflite.dart';
import '../../db_helper.dart';
import '../../models/user.dart';
import '../../models/result.dart';
import 'user_repository.dart';

class DBUserRepository implements UserRepository {

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';

    final strong = value.length >= 8 &&
        RegExp(r'[a-z]').hasMatch(value) &&
        RegExp(r'[A-Z]').hasMatch(value) &&
        RegExp(r'[0-9]').hasMatch(value) &&
        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!strong) return 'Weak password';
    return null;
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) return 'First name cannot be empty';
    if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) {
      return 'Enter a valid first name';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) return 'Last name cannot be empty';
    if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) {
      return 'Enter a valid last name';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Phone number cannot be empty';
    if (!RegExp(r'^0[567][0-9]{8}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateNin(String? value) {
    if (value == null || value.isEmpty) return 'NIN cannot be empty';
    if (!RegExp(r'^[0-9]{18}$').hasMatch(value)) {
      return 'Enter a valid NIN';
    }
    return null;
  }

  Future<bool> _emailExists(Database db, String email) async {
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> _emailExistsForAnother(Database db, String email, int userId) async {
    final result = await db.query(
      'users',
      where: 'email = ? AND user_id != ?',
      whereArgs: [email, userId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  @override
  Future<ReturnResult<User>> createUser(User user) async {
    final db = await DBHelper.getDatabase();

    final emailError = _validateEmail(user.email);
    if (emailError != null) return ReturnResult(state: false, message: emailError);

    final passwordError = _validatePassword(user.password);
    if (passwordError != null) return ReturnResult(state: false, message: passwordError);

    final firstNameError = _validateFirstName(user.firstname);
    if (firstNameError != null) return ReturnResult(state: false, message: firstNameError);

    final lastNameError = _validateLastName(user.lastname);
    if (lastNameError != null) return ReturnResult(state: false, message: lastNameError);

    final phoneError = _validatePhoneNumber(user.phoneNumber);
    if (phoneError != null) return ReturnResult(state: false, message: phoneError);

    final ninError = _validateNin(user.nin);
    if (ninError != null) return ReturnResult(state: false, message: ninError);

    if (await _emailExists(db, user.email)) {
      return ReturnResult(state: false, message: "Email already used");
    }

    try {
      final userId = await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      final created = User(
        userId: userId,
        role: user.role,
        firstname: user.firstname,
        lastname: user.lastname,
        email: user.email,
        password: user.password,
        phoneNumber: user.phoneNumber,
        nin: user.nin,
        profilePicture: user.profilePicture,
      );

      return ReturnResult(
        state: true,
        message: 'User inserted successfully',
        data: created,
      );
    } catch (e) {
      return ReturnResult(state: false, message: 'User could not be inserted: $e');
    }
  }

  @override
  Future<ReturnResult<User?>> getUserById(int id) async {
    final db = await DBHelper.getDatabase();
    try {
      final result = await db.query(
        'users',
        where: 'user_id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return ReturnResult(state: false, message: 'User not found');
      }

      return ReturnResult(
        state: true,
        message: 'User found',
        data: User.fromMap(result.first),
      );
    } catch (e) {
      return ReturnResult(state: false, message: 'Error fetching user: $e');
    }
  }

  @override
  Future<ReturnResult<User?>> getUserByEmail(String email) async {
    final db = await DBHelper.getDatabase();
    try {
      final result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (result.isEmpty) {
        return ReturnResult(state: false, message: 'User not found');
      }

      return ReturnResult(
        state: true,
        message: 'User found',
        data: User.fromMap(result.first),
      );
    } catch (e) {
      return ReturnResult(state: false, message: 'Error fetching user: $e');
    }
  }

  @override
  Future<ReturnResult<List<User>>> getAllUsers() async {
    final db = await DBHelper.getDatabase();
    try {
      final result = await db.query('users');

      final users = result.map((row) => User.fromMap(row)).toList();

      return ReturnResult(
        state: true,
        message: 'Users fetched',
        data: users,
      );
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Error fetching users: $e',
        data: [],
      );
    }
  }

  @override
  Future<ReturnResult<User>> updateUser(User user) async {
    final db = await DBHelper.getDatabase();

    final emailError = _validateEmail(user.email);
    if (emailError != null) return ReturnResult(state: false, message: emailError);

    final passwordError = _validatePassword(user.password);
    if (passwordError != null) return ReturnResult(state: false, message: passwordError);

    final firstNameError = _validateFirstName(user.firstname);
    if (firstNameError != null) return ReturnResult(state: false, message: firstNameError);

    final lastNameError = _validateLastName(user.lastname);
    if (lastNameError != null) return ReturnResult(state: false, message: lastNameError);

    final phoneError = _validatePhoneNumber(user.phoneNumber);
    if (phoneError != null) return ReturnResult(state: false, message: phoneError);

    final ninError = _validateNin(user.nin);
    if (ninError != null) return ReturnResult(state: false, message: ninError);

    if (await _emailExistsForAnother(db, user.email, user.userId!)) {
      return ReturnResult(state: false, message: "Email already used by another account");
    }

    try {
      final count = await db.update(
        'users',
        user.toMap(),
        where: 'user_id = ?',
        whereArgs: [user.userId],
      );

      if (count == 0) {
        return ReturnResult(state: false, message: 'User not found');
      }

      return ReturnResult(
        state: true,
        message: 'User updated successfully',
        data: user,
      );
    } catch (e) {
      return ReturnResult(state: false, message: 'User could not be updated: $e');
    }
  }

  @override
  Future<ReturnResult> deleteUser(int id) async {
    final db = await DBHelper.getDatabase();
    try {
      final count = await db.delete(
        'users',
        where: 'user_id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        return ReturnResult(state: false, message: 'User not found');
      }

      return ReturnResult(state: true, message: 'User deleted successfully');
    } catch (e) {
      return ReturnResult(state: false, message: 'User could not be deleted: $e');
    }
  }
}
