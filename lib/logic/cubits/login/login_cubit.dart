import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user.dart';
import '../../../data/models/result.dart';
import '../../../data/repo/auth/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepo;

  LoginCubit(this.authRepo) : super(LoginState());

  void validateEmail(String email) {
    if (email.isEmpty) {
      emit(state.copyWith(emailError: 'Email cannot be empty'));
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emit(state.copyWith(emailError: 'Enter a valid email'));
    } else {
      emit(state.copyWith(emailError: null));
    }
  }

  void validatePassword(String password) {
    if (password.isEmpty) {
      emit(state.copyWith(passwordError: 'Password cannot be empty'));
    } else if (password.length < 8) {
      emit(state.copyWith(passwordError: 'Password must be at least 8 characters'));
    } else {
      emit(state.copyWith(passwordError: null));
    }
  }

  Future<void> login(String email, String password) async {
    validateEmail(email);
    validatePassword(password);

    if (state.emailError != null || state.passwordError != null) return;

    emit(state.copyWith(isLoading: true, message: ''));

    final result = await authRepo.login(email, password);

    if (result.state) {
      emit(state.copyWith(isLoading: false, user: result.data, message: 'Login successful'));
    } else {
      emit(state.copyWith(isLoading: false, message: result.message));
    }
  }
}
