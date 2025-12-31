import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';
import 'package:afia_plus_app/views/screens/homescreen/patient_home_screen.dart';
import 'package:afia_plus_app/views/screens/homescreen/doctor_home_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Unauthenticated) {
          return const CreateAccountScreen(); // Or your login screen
        } else if (state is AuthenticatedPatient) {
          return const PatientHomeScreen();
        } else if (state is AuthenticatedDoctor) {
          return const DoctorHomeScreen();
        } else {
          return const Scaffold(
            body: Center(child: Text('Unknown state')),
          );
        }
      },
    );
  }
}
