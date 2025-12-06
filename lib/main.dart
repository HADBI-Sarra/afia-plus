import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_doctor_view.dart';
import 'package:afia_plus_app/views/screens/userprofile/user_profile_screen_doctor_view.dart';
import 'package:afia_plus_app/views/screens/userprofile/user_profile_user_view.dart';
import 'package:flutter/material.dart';
import 'package:afia_plus_app/commons/config.dart';
import 'package:afia_plus_app/views/screens/search/search.dart';
import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_users_view.dart';
import 'package:afia_plus_app/views/themes/style_simple/theme.dart';
import 'package:afia_plus_app/views/screens/userPages/user_appointments.dart';
import 'package:afia_plus_app/utils/db_verification_screen.dart';
import 'package:afia_plus_app/utils/db_seeder.dart';
import 'package:afia_plus_app/cubits/locale_cubit.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:afia_plus_app/views/screens/homescreen/doctor_home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force reseed database (clears old data and inserts fresh test data)
  // Comment this out after first run if you want to keep your data
  try {
    print('🔄 Force reseeding database...');
    await DBSeeder.forceReseed();
    print('✅ Database reseeded successfully!');
  } catch (e) {
    print('❌ Error reseeding database: $e');
    // Fallback to normal seeding if force reseed fails
    await DBSeeder.ensureDatabaseSeeded();
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocaleCubit(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: APP_NAME,
            theme: appTheme,
            locale: locale, // Dynamic locale from LocaleCubit
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],
            home: DoctorHomeScreen(),

            //const DoctorHomeScreen(),
            //UpcomingAppointmentsPage(),
            routes: {
              UserProfileScreen.routename: (context) => UserProfileScreen(),
              DoctorProfileScreen.routename: (context) => DoctorProfileScreen(),
              DoctorViewDoctorProfileScreen.routename: (context) =>
                  DoctorViewDoctorProfileScreen(),
              DoctorViewUserProfileScreen.routename: (context) =>
                  DoctorViewUserProfileScreen(),
              SearchScreen.routename: (context) => SearchScreen(),
              '/db-verify': (context) => const DBVerificationScreen(),
            },

            //DoctorViewDoctorProfileScreen(),
          );
        },
      ),
    );
  }
}
