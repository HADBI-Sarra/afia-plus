import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afia_plus_app/logic/cubits/signup/signup_cubit.dart';
import 'package:afia_plus_app/data/repo/auth/auth_repository.dart';
import 'package:afia_plus_app/logic/cubits/signup/signup_state.dart';
import 'package:afia_plus_app/data/models/result.dart';
import 'package:afia_plus_app/data/models/user.dart';
import 'package:afia_plus_app/data/models/patient.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('SignupCubit', () {
    late SignupCubit signupCubit;
    late MockAuthRepository authRepository;
    setUp(() {
      authRepository = MockAuthRepository();
      signupCubit = SignupCubit(authRepository: authRepository);
    });

    test('initial state is SignupState()', () {
      expect(signupCubit.state, isA<SignupState>());
    });

    test('setEmail updates email in state', () {
      signupCubit.setEmail('test@email.com');
      expect(signupCubit.state.email, 'test@email.com');
    });

    test('validateAccountStep fails on empty values', () {
      final isValid = signupCubit.validateAccountStep();
      expect(isValid, false);
      expect(signupCubit.state.emailError, isNotNull);
      expect(signupCubit.state.passwordError, isNotNull);
      expect(signupCubit.state.confirmPasswordError, isNotNull);
    });

    test('validateAccountStep passes with valid values', () {
      signupCubit.setEmail('user@email.com');
      signupCubit.setPassword('StrongP@ss1');
      signupCubit.setConfirmPassword('StrongP@ss1');
      final isValid = signupCubit.validateAccountStep();
      expect(isValid, true);
      expect(signupCubit.state.emailError, isNull);
      expect(signupCubit.state.passwordError, isNull);
      expect(signupCubit.state.confirmPasswordError, isNull);
    });

    group('checkEmailExists', () {
      test('emits email error if email exists', () async {
        signupCubit.setEmail('exist@email.com');
        when(
          () => authRepository.emailExists(any()),
        ).thenAnswer((_) async => true);
        final exists = await signupCubit.checkEmailExists();
        expect(exists, true);
        expect(signupCubit.state.emailError, 'Email already in use');
      });
      test('returns false if email does not exist', () async {
        signupCubit.setEmail('free@email.com');
        when(
          () => authRepository.emailExists(any()),
        ).thenAnswer((_) async => false);
        final exists = await signupCubit.checkEmailExists();
        expect(exists, false);
        expect(signupCubit.state.emailError, isNull);
      });
      test('handles errors gracefully', () async {
        signupCubit.setEmail('err@email.com');
        when(
          () => authRepository.emailExists(any()),
        ).thenThrow(Exception('timeout'));
        final exists = await signupCubit.checkEmailExists();
        expect(exists, false);
        expect(signupCubit.state.message, contains('timeout'));
      });
    });

    // More advanced tests for async flow (submits, etc.) can be added as needed.
  });
}
