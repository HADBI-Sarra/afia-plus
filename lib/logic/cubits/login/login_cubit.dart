import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user.dart';
import '../../../data/models/result.dart';
import '../../../data/repo/auth/auth_repository.dart';
import '../auth/auth_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepo;
  final AuthCubit? authCubit;

  LoginCubit(this.authRepo, {this.authCubit}) : super(LoginState());

  void validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      emit(state.copyWith(emailError: 'Email cannot be empty'));
    } else if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$').hasMatch(trimmed)) {
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

  String? _validateEmailSync(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$').hasMatch(trimmed)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePasswordSync(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    // Check validation synchronously first
    final emailError = _validateEmailSync(email);
    final passwordError = _validatePasswordSync(password);

    // Update UI validation errors
    emit(state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      message: '',
    ));

    if (emailError != null || passwordError != null) {
      return;
    }

    emit(state.copyWith(isLoading: true, message: '', emailError: null, passwordError: null));

    final result = await authRepo.login(email, password);

    if (result.state) {
      emit(state.copyWith(isLoading: false, user: result.data, message: ''));
      // Refresh AuthCubit to update the authentication state and wait for it
      if (authCubit != null) {
        await authCubit!.checkLoginStatus();
        // Verify that we're actually authenticated before signaling navigation
        final authState = authCubit!.state;
        if (authState is AuthenticatedPatient || authState is AuthenticatedDoctor) {
          emit(state.copyWith(user: result.data, message: ''));
        }
      }
    } else {
      emit(state.copyWith(isLoading: false, message: result.message));
    }
  }
}
