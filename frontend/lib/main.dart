import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:afia_plus_app/commons/config.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'utils/firebase.dart';
import 'package:afia_plus_app/views/themes/style_simple/theme.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/cubits/doctor_availability_cubit.dart';
import 'package:afia_plus_app/logic/cubits/booking/booking_cubit.dart';
import 'package:afia_plus_app/logic/cubits/doctors/doctors_cubit.dart';
import 'package:afia_plus_app/logic/cubits/signup/signup_cubit.dart';
import 'package:afia_plus_app/cubits/locale_cubit.dart';
import 'package:afia_plus_app/views/screens/root/root_screen.dart';
import 'package:afia_plus_app/views/screens/userprofile/user_profile_screen_doctor_view.dart';
import 'package:afia_plus_app/views/screens/userprofile/user_profile_user_view.dart';
import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_doctor_view.dart';
import 'package:afia_plus_app/views/screens/search/search.dart';
import 'package:afia_plus_app/data/repo/doctor_availability/doctor_availability_impl.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_abstract.dart';
import 'package:afia_plus_app/data/repo/users/supabase_user_repository.dart';
import 'package:afia_plus_app/data/repo/users/user_repository.dart';
import 'package:afia_plus_app/data/repo/patients/supabase_patient_repository.dart';
import 'package:afia_plus_app/data/repo/patients/patient_repository.dart';
import 'package:afia_plus_app/data/repo/doctors/db_doctor_repository.dart';
import 'package:afia_plus_app/data/repo/doctors/doctor_repository.dart';
import 'package:afia_plus_app/data/repo/auth/supabase_auth_repository.dart';
import 'package:afia_plus_app/data/repo/auth/auth_repository.dart';
import 'package:afia_plus_app/data/repo/specialities/db_speciality_repository.dart';
import 'package:afia_plus_app/data/repo/specialities/speciality_repository.dart';
import 'package:afia_plus_app/data/repo/auth/token_provider.dart';
import 'package:afia_plus_app/data/db_helper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initMyApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DB
  await DBHelper.getDatabase();

  // Dependency Injection
  final sl = GetIt.instance;

  sl.registerLazySingleton<TokenProvider>(() => TokenProvider());
  sl.registerLazySingleton<UserRepository>(() => SupabaseUserRepository());
  sl.registerLazySingleton<PatientRepository>(
    () => SupabasePatientRepository(),
  );
  sl.registerLazySingleton<DoctorRepository>(() => DBDoctorRepository());
  sl.registerLazySingleton<AuthRepository>(() => SupabaseAuthRepository());
  sl.registerLazySingleton<SpecialityRepository>(
    () => DBSpecialityRepository(),
  );
  sl.registerLazySingleton<ConsultationsRepository>(() => ConsultationsImpl());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  init_firebase_messaging();
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
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(
          create: (_) => AuthCubit(
            authRepository: authRepo,
            patientRepository: patientRepo,
            doctorRepository: doctorRepo,
          ),
        ),
        BlocProvider(create: (_) => DoctorsCubit()),
        BlocProvider(create: (_) => SignupCubit(authRepository: authRepo)),
        BlocProvider<DoctorAvailabilityCubit>(
          create: (_) =>
              DoctorAvailabilityCubit(repository: DoctorAvailabilityImpl()),
        ),

        BlocProvider<BookingCubit>(
          create: (_) => BookingCubit(consultations: ConsultationsImpl()),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: APP_NAME,
            theme: appTheme,
            locale: locale, // Dynamic locale from LocaleCubit
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
              Locale('fr'), // French
            ],
            home: const RootScreen(),
            //UpcomingAppointmentsPage(),
            //DoctorHomeScreen(),
            routes: {
              UserProfileScreen.routename: (context) =>
                  const UserProfileScreen(),
              // DoctorProfileScreen.routename: (context) => DoctorProfileScreen(),
              DoctorViewDoctorProfileScreen.routename: (context) =>
                  const DoctorViewDoctorProfileScreen(),
              DoctorViewUserProfileScreen.routename: (context) =>
                  const DoctorViewUserProfileScreen(),
              SearchScreen.routename: (context) => const SearchScreen(),
            },
            navigatorKey: navigatorKey,
          );
        },
      ),
    );
  }
}
