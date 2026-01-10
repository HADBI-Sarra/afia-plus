import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';
import 'package:afia_plus_app/views/screens/homescreen/patient_home_screen.dart';
import 'package:afia_plus_app/views/screens/homescreen/doctor_home_screen.dart';
import 'package:afia_plus_app/views/screens/welcome/welcome_screen.dart';
import 'package:afia_plus_app/views/screens/auth/email_verification_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  StreamSubscription? _sub;
  final AppLinks _appLinks = AppLinks();
  bool _isCheckingFirstLaunch = true;
  bool _isFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    _checkFirstLaunch();
  }

  Future<void> _initDeepLinks() async {
    // Listen for incoming links (app already in memory)
    _sub = _appLinks.uriLinkStream.listen((Uri uri) async {
      if (uri.scheme == 'afia' && uri.host == 'auth') {
        await _handleAuthDeepLink();
      }
    }, onError: (err) {
      print('Error listening to deep links: $err');
    });

    // Handle cold start - check for initial link when app opens
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null && initialUri.scheme == 'afia' && initialUri.host == 'auth') {
        // Wait a bit for context to be ready
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          await _handleAuthDeepLink();
        }
      }
    } catch (e) {
      print('Error getting initial URI: $e');
    }
  }

  Future<void> _handleAuthDeepLink() async {
    if (!mounted) return;
    
    // Refresh auth session to get latest user data including email_confirmed_at
    final authCubit = context.read<AuthCubit>();
    await authCubit.checkLoginStatus();
    
    if (!mounted) return;
    
    final authState = authCubit.state;
    
    // Check if user is authenticated
    if (authState is! AuthenticatedDoctor && authState is! AuthenticatedPatient) {
      // User is not authenticated - this shouldn't happen with a valid auth deep link
      // but handle it gracefully
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to verify your email'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }
    
    // Check if email is verified
    final bool isVerified = (authState is AuthenticatedDoctor && authState.doctor.isEmailVerified) ||
        (authState is AuthenticatedPatient && authState.patient.isEmailVerified);
    
    if (isVerified) {
      // Email is verified - show success message
      // RootScreen will automatically show home screen based on auth state
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email verified successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Email not verified - navigate to verification screen
      // Clear navigation stack to prevent going back to signup screens
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _checkFirstLaunch() async {
    final isFirst = await WelcomeScreen.isFirstLaunch();
    if (mounted) {
      setState(() {
        _isFirstLaunch = isFirst;
        _isCheckingFirstLaunch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking first launch
    if (_isCheckingFirstLaunch) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show welcome screen on first launch
    if (_isFirstLaunch) {
      return const WelcomeScreen();
    }

    // Otherwise, show normal auth flow
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Unauthenticated) {
          return const CreateAccountScreen();
        } else if (state is AuthenticatedPatient) {
          // Block access if email is not verified
          if (!state.patient.isEmailVerified) {
            return _EmailVerificationRequiredScreen(userEmail: state.patient.email);
          }
          return const PatientHomeScreen();
        } else if (state is AuthenticatedDoctor) {
          // Block access if email is not verified
          if (!state.doctor.isEmailVerified) {
            return _EmailVerificationRequiredScreen(userEmail: state.doctor.email);
          }
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

/// Screen shown when user is authenticated but email is not verified
class _EmailVerificationRequiredScreen extends StatelessWidget {
  final String userEmail;

  const _EmailVerificationRequiredScreen({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              const Text(
                'Email Verification Required',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Please check your email inbox ($userEmail) for the verification link.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Click the link in the email to verify your account and continue.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Refresh auth status to check if email was verified
                  context.read<AuthCubit>().checkLoginStatus();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('I\'ve Verified My Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
