import 'user.dart';

class Auth {
  final User user;
  final DateTime loginTime;

  Auth({
    required this.user,
    required this.loginTime,
  });

  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      loginTime: DateTime.parse(map['login_time']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'login_time': loginTime.toIso8601String(),
    };
  }
}
