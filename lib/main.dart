import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';
import 'package:flutter/material.dart';
import 'package:afia_plus_app/commons/config.dart';
import 'package:afia_plus_app/views/screens/homescreen/home_screen.dart';
import 'package:afia_plus_app/views/screens/search/search.dart';
import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen.dart';
import 'package:afia_plus_app/views/themes/style_simple/theme.dart';

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
      home: DoctorProfileScreen(),
    );
  }
}
