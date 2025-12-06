import '../../models/user.dart';
import '../../models/result.dart';
import 'user_repository.dart';

class DummyUserRepository implements UserRepository {
  final List<User> _users = [];
  int _autoId = 1;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';

    final long = value.length >= 8;
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);

    final strongPassword =
        long && hasLowercase && hasUppercase && hasNumber && hasSpecial;

    if (!strongPassword) return 'Weak password';

    return null;
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) return 'First name cannot be empty';
    if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) return 'Enter a valid first name';
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) return 'Last name cannot be empty';
    if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) return 'Enter a valid last name';
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Phone number cannot be empty';
    if (!RegExp(r'^0[567][0-9]{8}$').hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  String? _validateNin(String? value) {
    if (value == null || value.isEmpty) return 'NIN cannot be empty';
    if (!RegExp(r'^[0-9]{18}$').hasMatch(value)) return 'Enter a valid NIN';
    return null;
  }

  @override
  Future<ReturnResult<User>> createUser(User user) async {
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

    final newUser = User(
      userId: _autoId++,
      role: user.role,
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email,
      password: user.password,
      phoneNumber: user.phoneNumber,
      nin: user.nin,
      profilePicture: user.profilePicture,
    );

    _users.add(newUser);

    return ReturnResult(
      state: true,
      message: 'User created successfully',
      data: newUser,
    );
  }

  @override
  Future<ReturnResult<User?>> getUserById(int id) async {
    try {
      final index = _users.indexWhere((u) => u.userId == id);
      if (index != -1) {
        return ReturnResult(
          state: true,
          message: 'User found',
          data: _users[index],
        );
      }
      return ReturnResult(state: false, message: 'User not found');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error fetching user: $e');
    }
  }

  @override
  Future<ReturnResult<User?>> getUserByEmail(String email) async {
    try {
      final index = _users.indexWhere((u) => u.email == email);
      if (index != -1) {
        return ReturnResult(
          state: true,
          message: 'User found',
          data: _users[index],
        );
      }
      return ReturnResult(state: false, message: 'User not found');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error fetching user: $e');
    }
  }

  @override
  Future<ReturnResult<List<User>>> getAllUsers() async {
    try {
      return ReturnResult(
        state: true,
        message: 'Users fetched',
        data: List.from(_users),
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
  Future<ReturnResult<User>> updateUser(User updated) async {
    final emailError = _validateEmail(updated.email);
    if (emailError != null) return ReturnResult(state: false, message: emailError);

    final passwordError = _validatePassword(updated.password);
    if (passwordError != null) return ReturnResult(state: false, message: passwordError);

    final firstNameError = _validateFirstName(updated.firstname);
    if (firstNameError != null) return ReturnResult(state: false, message: firstNameError);

    final lastNameError = _validateLastName(updated.lastname);
    if (lastNameError != null) return ReturnResult(state: false, message: lastNameError);

    final phoneError = _validatePhoneNumber(updated.phoneNumber);
    if (phoneError != null) return ReturnResult(state: false, message: phoneError);

    final ninError = _validateNin(updated.nin);
    if (ninError != null) return ReturnResult(state: false, message: ninError);

    final index = _users.indexWhere((u) => u.userId == updated.userId);
    if (index == -1) return ReturnResult(state: false, message: 'User not found');

    _users[index] = updated;

    return ReturnResult(
      state: true,
      message: 'User updated successfully',
      data: updated,
    );
  }

  @override
  Future<ReturnResult> deleteUser(int id) async {
    final index = _users.indexWhere((u) => u.userId == id);
    if (index == -1) return ReturnResult(state: false, message: 'User not found');

    _users.removeAt(index);

    return ReturnResult(
      state: true,
      message: 'User deleted successfully',
    );
  }
}
