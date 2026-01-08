import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/cubits/locale_cubit.dart';
import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const String _firstLaunchKey = 'first_launch_completed';

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) != true;
  }

  static Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, true);
  }

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;
  String? _loadingLocale;

  Future<void> _selectLanguage(Locale locale) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _loadingLocale = locale.languageCode;
    });

    try {
      // Change the locale
      await context.read<LocaleCubit>().changeLocale(locale);
      
      // Mark first launch as completed
      await WelcomeScreen.setFirstLaunchCompleted();
      
      // Navigate to create account screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingLocale = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageHeight = (constraints.maxHeight * 0.45).clamp(300.0, 500.0);
              final screenHeight = constraints.maxHeight;
              
              // Calculate flexible spacing: take remaining space, but with min/max limits
              final remainingSpace = screenHeight - imageHeight - 200; // 200 is approximate space for texts and buttons
              final flexibleSpacing = remainingSpace.clamp(16.0, 80.0);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 6.0, 24.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome Image (constrained height to avoid huge empty gaps)
                      SizedBox(
                        height: imageHeight,
                        child: Image.asset(
                          'assets/images/welcome.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Welcome Text
                      Text(
                        '3afiaPlus مرحبًا بك في',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkGreenColor,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'رعايتك الصحية أقرب إليك',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              color: greyColor,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: flexibleSpacing),

                      Text(
                        ':اختر لغتك للمتابعة',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 20,
                              color: darkGreenColor,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Language Selection Buttons - Reordered: Arabic, French, English
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () => _selectLanguage(const Locale('ar')),
                            style: greenButtonStyle,
                            child: _isLoading && _loadingLocale == 'ar'
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'العربية',
                                    style: whiteButtonText,
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () => _selectLanguage(const Locale('fr')),
                            style: greenButtonStyle,
                            child: _isLoading && _loadingLocale == 'fr'
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Français',
                                    style: whiteButtonText,
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () => _selectLanguage(const Locale('en')),
                            style: greenButtonStyle,
                            child: _isLoading && _loadingLocale == 'en'
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'English',
                                    style: whiteButtonText,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}

