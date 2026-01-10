import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repo/auth/auth_repository.dart';
import '../../../data/models/patient.dart';
import '../../../data/models/doctor.dart';
import '../auth/auth_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepo;
  final AuthCubit? authCubit;

  LoginCubit(this.authRepo, {this.authCubit}) : super(LoginState());

  void validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      emit(state.copyWith(emailError: 'errorEmailEmpty'));
    } else if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$').hasMatch(trimmed)) {
      emit(state.copyWith(emailError: 'errorEmailInvalid'));
    } else {
      emit(state.copyWith(emailError: null));
    }
  }

  void validatePassword(String password) {
    if (password.isEmpty) {
      emit(state.copyWith(passwordError: 'errorPasswordEmpty'));
    } else if (password.length < 8) {
      emit(state.copyWith(passwordError: 'errorPasswordShort'));
    } else {
      emit(state.copyWith(passwordError: null));
    }
  }

  String? _validateEmailSync(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return 'errorEmailEmpty';
    } else if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$').hasMatch(trimmed)) {
      return 'errorEmailInvalid';
    }
    return null;
  }

  String? _validatePasswordSync(String password) {
    if (password.isEmpty) {
      return 'errorPasswordEmpty';
    } else if (password.length < 8) {
      return 'errorPasswordShort';
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    // Always trim inputs before validation and backend call
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    // Check validation synchronously first
    final emailError = _validateEmailSync(trimmedEmail);
    final passwordError = _validatePasswordSync(trimmedPassword);

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

    final result = await authRepo.login(trimmedEmail, trimmedPassword);

    if (result.state && result.data != null) {
      // Check if email is verified
      final user = result.data!;
      final bool isEmailVerified = (user is Patient && user.isEmailVerified) ||
          (user is Doctor && user.isEmailVerified);

      if (!isEmailVerified) {
        // Email not verified - block login
        emit(state.copyWith(
          isLoading: false,
          message: 'Please verify your email before logging in',
        ));
        return;
      }

      print('Login successful, setting user in LoginCubit: ${user.email}');
      emit(state.copyWith(isLoading: false, user: user, message: ''));
      // Refresh AuthCubit to update the authentication state
      // Navigation will be handled by listener in login screen
      if (authCubit != null) {
        print('Calling checkLoginStatus...');
        await authCubit!.checkLoginStatus();
        print('checkLoginStatus completed. Auth state: ${authCubit!.state.runtimeType}');
      }
    } else {
      emit(state.copyWith(isLoading: false, message: result.message));
    }
  }
}
