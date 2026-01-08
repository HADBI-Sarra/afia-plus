import 'package:flutter_test/flutter_test.dart';
import 'package:afia_plus_app/data/models/auth_model.dart';
import 'package:afia_plus_app/data/models/user.dart';

void main() {
  group('Auth Model', () {
    final user = User(
      userId: 1,
      role: 'admin',
      firstname: 'John',
      lastname: 'Doe',
      email: 'john.doe@example.com',
      password: 'secret',
      phoneNumber: '1234567890',
      nin: 'NIN123',
      profilePicture: 'profile.png',
    );
    final loginTime = DateTime.now();
    final auth = Auth(user: user, loginTime: loginTime);

    test('toMap returns correct map', () {
      final map = auth.toMap();
      expect(map['user'], user.toMap());
      expect(map['login_time'], loginTime.toIso8601String());
    });

    test('fromMap returns correct Auth object', () {
      final authMap = {
        'user': user.toMap(),
        'login_time': loginTime.toIso8601String(),
      };
      final authFromMap = Auth.fromMap(authMap);
      expect(authFromMap.user.email, auth.user.email);
      expect(authFromMap.loginTime, auth.loginTime);
    });
  });
}
