import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afia_plus_app/logic/cubits/login/login_cubit.dart';
import 'package:afia_plus_app/data/repo/auth/auth_repository.dart';
import 'package:afia_plus_app/data/models/user.dart';
import 'package:afia_plus_app/logic/cubits/login/login_state.dart';
import 'package:afia_plus_app/data/models/result.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginCubit', () {
    late LoginCubit loginCubit;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      loginCubit = LoginCubit(mockAuthRepository);
    });

    test('initial state is LoginState()', () {
      expect(loginCubit.state, isA<LoginState>());
    });

    test('validateEmail sets email error for blank email', () {
      loginCubit.validateEmail('');
      expect(loginCubit.state.emailError, isNotNull);
    });

    test('validateEmail sets email error for invalid email', () {
      loginCubit.validateEmail('notvalid');
      expect(loginCubit.state.emailError, isNotNull);
    });

    test('validateEmail does not set error for valid email', () {
      loginCubit.validateEmail('you@mail.com');
      expect(loginCubit.state.emailError, isNull);
    });

    test('validatePassword sets password error for blank password', () {
      loginCubit.validatePassword('');
      expect(loginCubit.state.passwordError, isNotNull);
    });

    test('validatePassword sets password error for short password', () {
      loginCubit.validatePassword('short');
      expect(loginCubit.state.passwordError, isNotNull);
    });

    test('validatePassword passes for strong password', () {
      loginCubit.validatePassword('StrongPassword8');
      expect(loginCubit.state.passwordError, isNull);
    });

    group('login', () {
      final user = User(
        userId: 1,
        role: 'admin',
        firstname: 'Admin',
        lastname: 'User',
        email: 'admin@x.com',
        password: 'Password1',
        phoneNumber: '1111111111',
        nin: '000000000000000000',
      );
      test('shows error for invalid input', () async {
        await loginCubit.login('', '');
        expect(loginCubit.state.emailError, isNotNull);
        expect(loginCubit.state.passwordError, isNotNull);
      });

      test('emits state with user on successful login', () async {
        when(() => mockAuthRepository.login(any(), any())).thenAnswer(
          (_) async =>
              ReturnResult(state: true, message: 'Success', data: user),
        );
        await loginCubit.login(user.email, user.password);
        expect(loginCubit.state.user, isNotNull);
        expect(loginCubit.state.isLoading, false);
      });

      test('emits state with message on failure', () async {
        when(() => mockAuthRepository.login(any(), any())).thenAnswer(
          (_) async =>
              ReturnResult(state: false, message: 'Invalid credentials'),
        );
        await loginCubit.login('wrong@x.com', 'badpassword');
        expect(loginCubit.state.user, isNull);
        expect(loginCubit.state.isLoading, false);
        expect(loginCubit.state.message, 'Invalid credentials');
      });
    });
  });
}
