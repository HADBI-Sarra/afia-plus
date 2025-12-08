import 'package:flutter/material.dart';
import 'package:afia_plus_app/commons/config.dart';
import 'package:afia_plus_app/views/screens/search/search.dart';
import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_users_view.dart';
import 'package:afia_plus_app/views/themes/style_simple/theme.dart';
import 'package:afia_plus_app/views/screens/sign_up/doctor/doctor_personal_data.dart';
import 'package:afia_plus_app/views/screens/sign_up/patient/patient_personal_data.dart';
import 'package:afia_plus_app/views/screens/sign_up/doctor/professional_info.dart';
import 'package:afia_plus_app/views/screens/homescreen/patient_home_screen.dart';
import 'package:afia_plus_app/views/screens/doctorPages/manage_appointments.dart';
import 'package:afia_plus_app/views/screens/userPages/user_appointments';
import 'package:afia_plus_app/views/screens/doctorPages/doctor_availability.dart';
import 'package:afia_plus_app/views/screens/userPages/prescription.dart';
import 'package:afia_plus_app/views/screens/homescreen/doctor_home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/logic/cubits/availability cubit/availability_cubit.dart';
import 'package:afia_plus_app/logic/cubits/booking/booking_cubit.dart';
import 'package:afia_plus_app/data/repo/doctor_availability/doctor_availability_impl.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_doctor_view.dart';
import 'package:afia_plus_app/commons/config.dart';
import 'package:afia_plus_app/views/themes/style_simple/theme.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/logic/cubits/signup/signup_cubit.dart';
import 'package:afia_plus_app/views/screens/root/root_screen.dart';
import 'package:afia_plus_app/views/screens/userprofile/user_profile_screen_doctor_view.dart';
import 'package:afia_plus_app/views/screens/userprofile/user_profile_user_view.dart';
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
        BlocProvider<AvailabilityCubit>(
         create: (_) => AvailabilityCubit(repo: DoctorAvailabilityImpl()),
        ),

          BlocProvider<BookingCubit>(
            create: (_) => BookingCubit(consultations: ConsultationsImpl(),availability: DoctorAvailabilityImpl(),)
          ),
      ],
      child: MaterialApp(
        title: APP_NAME,
        theme: appTheme,

      routes: {
        UserProfileScreen.routename: (context) => UserProfileScreen(),
        DoctorProfileScreen.routename: (context) => DoctorProfileScreen(),
        DoctorViewDoctorProfileScreen.routename: (context) =>
            DoctorViewDoctorProfileScreen(),
        DoctorViewUserProfileScreen.routename: (context) =>
            DoctorViewUserProfileScreen(),
        SearchScreen.routename: (context) => SearchScreen(),
      },
        home: DoctorViewUserProfileScreen(),
      ),
    );
  }
}

