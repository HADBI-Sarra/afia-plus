import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/views/screens/homescreen/patient_home_screen.dart';
import 'package:afia_plus_app/views/screens/homescreen/doctor_home_screen.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _pollingTimer;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    // Start checking verification status immediately
    _checkVerificationStatus();
    // Poll every 3 seconds to check if email was verified
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && !_isChecking) {
        _checkVerificationStatus();
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerificationStatus() async {
    if (_isChecking) return;
    
    setState(() {
      _isChecking = true;
    });

    final authCubit = context.read<AuthCubit>();
    await authCubit.checkLoginStatus();

    if (!mounted) return;

    final authState = authCubit.state;

    // Check if user is authenticated and email is verified
    if (authState is AuthenticatedPatient && authState.patient.isEmailVerified) {
      // Email verified - navigate to home
      _pollingTimer?.cancel();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email verified successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else if (authState is AuthenticatedDoctor && authState.doctor.isEmailVerified) {
      // Email verified - navigate to home
      _pollingTimer?.cancel();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email verified successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else if (authState is! AuthenticatedPatient && authState is! AuthenticatedDoctor) {
      // User is not authenticated - stop polling and show message
      _pollingTimer?.cancel();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to continue'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
        // Navigate back to root - RootScreen will handle showing login/create account
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }

    setState(() {
      _isChecking = false;
    });
  }

  String _getUserEmail() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthenticatedPatient) {
      return authState.patient.email;
    } else if (authState is AuthenticatedDoctor) {
      return authState.doctor.email;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle state changes
        if (state is AuthenticatedPatient && state.patient.isEmailVerified) {
          _pollingTimer?.cancel();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
            (route) => false,
          );
        } else if (state is AuthenticatedDoctor && state.doctor.isEmailVerified) {
          _pollingTimer?.cancel();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isChecking)
                  const CircularProgressIndicator()
                else
                  const Icon(
                    Icons.email_outlined,
                    size: 80,
                    color: Colors.orange,
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Verifying Your Email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'We are checking if your email has been verified...',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${_getUserEmail()}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isChecking ? null : _checkVerificationStatus,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Check Again'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Show instructions
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Email Verification'),
                        content: const Text(
                          'Please check your email inbox and click the verification link. '
                          'If you haven\'t received the email, check your spam folder.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Need Help?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

