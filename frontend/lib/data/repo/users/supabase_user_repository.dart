import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../../models/user.dart';
import '../../models/result.dart';
import '../../api/api_client.dart';
import './user_repository.dart';
import '../auth/token_provider.dart';

class SupabaseUserRepository implements UserRepository {
  final TokenProvider _tokenProvider = GetIt.instance<TokenProvider>();

  String? get _token => _tokenProvider.accessToken;

  void _ensureAuthenticated() {
    if (_token == null) {
      throw Exception('User not authenticated');
    }
  }

  @override
  Future<ReturnResult<User>> updateUser(User user) async {
    try {
      _ensureAuthenticated();

      final response = await ApiClient.put(
        '/users/me',
        user.toMap(),
        token: _token,
      );

      if (response.statusCode != 200) {
        return ReturnResult(
          state: false,
          message: 'Update failed',
        );
      }

      return ReturnResult(
        state: true,
        message: 'User updated',
        data: User.fromMap(jsonDecode(response.body)),
      );
    } catch (e) {
      return ReturnResult(
        state: false,
        message: e.toString(),
      );
    }
  }

  // ---------- Unsupported via endpoint ----------

  @override
  Future<ReturnResult<User?>> getUserById(int id) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Not supported via endpoint',
      ),
    );
  }

  @override
  Future<ReturnResult<User?>> getUserByEmail(String email) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Not supported',
      ),
    );
  }

  @override
  Future<ReturnResult<List<User>>> getAllUsers() {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Admin only',
      ),
    );
  }

  @override
  Future<ReturnResult<User>> createUser(User user) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Handled by auth',
      ),
    );
  }

  @override
  Future<ReturnResult> deleteUser(int id) {
    return Future.value(
      ReturnResult(
        state: false,
        message: 'Not allowed',
      ),
    );
  }
}
