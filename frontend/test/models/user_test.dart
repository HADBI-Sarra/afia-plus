import 'package:flutter_test/flutter_test.dart';
import 'package:afia_plus_app/data/models/user.dart';

void main() {
  group('User Model', () {
    test('toMap returns correct map', () {
      final user = User(
        userId: 1,
        role: 'doctor',
        firstname: 'Alice',
        lastname: 'Smith',
        email: 'alice.smith@example.com',
        password: 'mypassword',
        phoneNumber: '0987654321',
        nin: 'NIN456',
        profilePicture: null,
      );
      final map = user.toMap();
      expect(map['user_id'], 1);
      expect(map['role'], 'doctor');
      expect(map['firstname'], 'Alice');
      expect(map['lastname'], 'Smith');
      expect(map['email'], 'alice.smith@example.com');
      expect(map['password'], 'mypassword');
      expect(map['phone_number'], '0987654321');
      expect(map['nin'], 'NIN456');
      expect(map['profile_picture'], null);
    });

    test('fromMap returns correct User object', () {
      final map = {
        'user_id': 2,
        'role': 'patient',
        'firstname': 'Bob',
        'lastname': 'Brown',
        'email': 'bob.brown@example.com',
        'password': 'password2',
        'phone_number': '1122334455',
        'nin': 'NIN789',
        'profile_picture': 'bob.png',
      };
      final user = User.fromMap(map);
      expect(user.userId, 2);
      expect(user.role, 'patient');
      expect(user.firstname, 'Bob');
      expect(user.lastname, 'Brown');
      expect(user.email, 'bob.brown@example.com');
      expect(user.password, 'password2');
      expect(user.phoneNumber, '1122334455');
      expect(user.nin, 'NIN789');
      expect(user.profilePicture, 'bob.png');
    });
  });
}
