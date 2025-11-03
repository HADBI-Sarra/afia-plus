import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_doctor_view.dart';
import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';
import 'package:afia_plus_app/views/screens/userprofile/user_profile_user_view.dart';
import 'package:flutter/material.dart';
import 'package:afia_plus_app/commons/config.dart';
import 'package:afia_plus_app/views/screens/homescreen/home_screen.dart';
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

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: appTheme,
      home: PatientHomeScreen(),
    );
  }
}
