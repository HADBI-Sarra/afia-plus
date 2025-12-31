import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/user.dart';
import '../../../data/models/result.dart';
import '../../../data/repo/users/user_repository.dart';

class UsersCubit extends Cubit<Map<String, dynamic>> {
  late final UserRepository userRepo;

  UsersCubit() : super({'data': [], 'state': 'loading', 'message': ''}) {
    userRepo = GetIt.I<UserRepository>();
    loadUsers();
  }

  Future<bool> loadUsers() async {
    emit({...state, 'state': 'loading', 'message': '', 'data': []});

    try {
      final result = await userRepo.getAllUsers();

      if (result.state) {
        emit({
          ...state,
          'data': result.data ?? [],
          'state': 'done',
          'message': ''
        });
      } else {
        emit({
          ...state,
          'state': 'error',
          'message': result.message,
          'data': []
        });
      }
    } catch (e) {
      emit({...state, 'state': 'error', 'message': e.toString(), 'data': []});
    }

    return true;
  }

  Future<ReturnResult<User>> createUser(User user) async {
    try {
      final result = await userRepo.createUser(user);
      await loadUsers();
      return result;
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult<User>> updateUser(User user) async {
    try {
      final result = await userRepo.updateUser(user);
      await loadUsers();
      return result;
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult> deleteUser(int id) async {
    try {
      final result = await userRepo.deleteUser(id);
      await loadUsers();
      return result;
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult<User?>> getUserById(int id) async {
    try {
      return await userRepo.getUserById(id);
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }

  Future<ReturnResult<User?>> getUserByEmail(String email) async {
    try {
      return await userRepo.getUserByEmail(email);
    } catch (e) {
      return ReturnResult(state: false, message: e.toString());
    }
  }
}
