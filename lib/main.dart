import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;

import 'package:afia_plus_app/commons/config.dart';
import 'package:afia_plus_app/views/themes/style_simple/theme.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/logic/cubits/signup/signup_cubit.dart';
import 'package:afia_plus_app/logic/cubits/doctors/doctors_cubit.dart';
import 'package:afia_plus_app/views/screens/root/root_screen.dart';
import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_users_view.dart';

import 'data/db_helper.dart';
import 'data/repo/users/user_repository.dart';
import 'data/repo/users/db_user_repository.dart';
import 'data/repo/patients/patient_repository.dart';
import 'data/repo/patients/db_patient_repository.dart';
import 'data/repo/doctors/doctor_repository.dart';
import 'data/repo/doctors/db_doctor_repository.dart';
import 'data/repo/auth/auth_repository.dart';
import 'data/repo/auth/db_auth_repository.dart';
import 'data/repo/specialities/db_speciality_repository.dart';
import 'data/repo/specialities/speciality_repository.dart';

Future<void> initMyApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup FFI for desktop
  if (Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize DB
  final db = await DBHelper.getDatabase();

  // Dependency Injection
  final sl = GetIt.instance;

  sl.registerLazySingleton<UserRepository>(() => DBUserRepository());
  sl.registerLazySingleton<PatientRepository>(() => DBPatientRepository());
  sl.registerLazySingleton<DoctorRepository>(() => DBDoctorRepository());
  sl.registerLazySingleton<AuthRepository>(() => DbAuthRepository(db));
  sl.registerLazySingleton<SpecialityRepository>(() => DBSpecialityRepository());
}

void main() async {
  await initMyApp();
  runApp(const MainApp());
}

// main.dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = GetIt.instance<AuthRepository>();
    final patientRepo = GetIt.instance<PatientRepository>();
    final doctorRepo = GetIt.instance<DoctorRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(authRepository: authRepo, patientRepository: patientRepo, doctorRepository: doctorRepo),
        ),
        BlocProvider(
          create: (_) => SignupCubit(authRepository: authRepo),
        ),
        BlocProvider(
          create: (_) => DoctorsCubit(),
        ),
      ],
      child: MaterialApp(
        title: APP_NAME,
        theme: appTheme,
        home: const RootScreen(),
        // home: const DoctorProfileScreen(doctorId: 1),
      ),
    );
  }
}

