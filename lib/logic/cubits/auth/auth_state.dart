part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {}

class Unauthenticated extends AuthState {}

// Authenticated patient now holds a Patient object
class AuthenticatedPatient extends AuthState {
  final Patient patient;
  AuthenticatedPatient(this.patient);

  @override
  List<Object?> get props => [patient];
}

// Authenticated doctor now holds a Doctor object
class AuthenticatedDoctor extends AuthState {
  final Doctor doctor;
  AuthenticatedDoctor(this.doctor);

  @override
  List<Object?> get props => [doctor];
}
