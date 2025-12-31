import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/auth/auth_repository.dart';
import 'package:afia_plus_app/data/models/patient.dart';
import 'package:afia_plus_app/data/models/doctor.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repo/patients/patient_repository.dart';
import '../../../data/repo/doctors/doctor_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final PatientRepository patientRepository;
  final DoctorRepository doctorRepository;

  AuthCubit({
    required this.authRepository,
    required this.patientRepository,
    required this.doctorRepository,
  }) : super(AuthLoading()) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    emit(AuthLoading());
    final result = await authRepository.getCurrentUser();

    if (!result.state || result.data == null) {
      emit(Unauthenticated());
      return;
    }

    final user = result.data!;

    if (user.role == 'doctor') {
      // Fetch full doctor data
      final doctorResult = await doctorRepository.getDoctorById(user.userId!);
      if (doctorResult.state && doctorResult.data != null) {
        emit(AuthenticatedDoctor(doctorResult.data!));
      } else {
        // fallback: create Doctor object from User
        final doctor = Doctor(
          userId: user.userId,
          role: user.role,
          firstname: user.firstname,
          lastname: user.lastname,
          email: user.email,
          password: user.password,
          phoneNumber: user.phoneNumber,
          nin: user.nin,
          bio: '',
          locationOfWork: '',
          degree: '',
          university: '',
          certification: '',
          institution: '',
          licenseNumber: '',
          licenseDescription: '',
          yearsExperience: null,
          areasOfExpertise: '',
          pricePerHour: null,
        );
        emit(AuthenticatedDoctor(doctor));
      }
    } else {
      // Fetch full patient data
      final patientResult = await patientRepository.getPatientById(user.userId!);
      if (patientResult.state && patientResult.data != null) {
        emit(AuthenticatedPatient(patientResult.data!));
      } else {
        // fallback: create Patient object from User
        final patient = Patient(
          userId: user.userId,
          role: user.role,
          firstname: user.firstname,
          lastname: user.lastname,
          email: user.email,
          password: user.password,
          phoneNumber: user.phoneNumber,
          nin: user.nin,
          dateOfBirth: '',
        );
        emit(AuthenticatedPatient(patient));
      }
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    emit(Unauthenticated());
  }
}
