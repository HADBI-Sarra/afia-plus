import '../../../data/models/user.dart';

class LoginState {
  final String? emailError;
  final String? passwordError;
  final bool isLoading;
  final String message;
  final User? user;

  LoginState({
    this.emailError,
    this.passwordError,
    this.isLoading = false,
    this.message = '',
    this.user,
  });

  LoginState copyWith({
    String? emailError,
    String? passwordError,
    bool? isLoading,
    String? message,
    User? user,
  }) {
    return LoginState(
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}
