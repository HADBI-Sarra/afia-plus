import 'package:afia_plus_app/views/screens/root/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';
import '../../../data/repo/auth/auth_repository.dart';
import '../../../logic/cubits/login/login_cubit.dart';
import '../../../logic/cubits/login/login_state.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:afia_plus_app/utils/localization_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        GetIt.instance<AuthRepository>(),
        authCubit: context.read<AuthCubit>(),
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LoginCubit, LoginState>(
            listenWhen: (previous, current) {
              // Listen for message changes
              return previous.message != current.message && current.message.isNotEmpty;
            },
            listener: (context, state) {
              // Show snackbar for error messages
              if (state.message.isNotEmpty && !state.message.contains('authenticated')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(getLocalizedError(state.message, context) ?? state.message),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          BlocListener<LoginCubit, LoginState>(
            listenWhen: (previous, current) {
              // Listen for successful login - user changed from null to non-null and not loading
              final wasNull = previous.user == null;
              final isNotNull = current.user != null;
              final notLoading = !current.isLoading;
              
              print('Login listener check: wasNull=$wasNull, isNotNull=$isNotNull, notLoading=$notLoading');
              
              return wasNull && isNotNull && notLoading;
            },
            listener: (context, state) async {
              print('Login listener triggered! User: ${state.user?.email}');
              
              // Wait for AuthCubit to update (checkLoginStatus is async)
              await Future.delayed(const Duration(milliseconds: 800));
              
              if (!context.mounted) {
                print('Context not mounted, skipping navigation');
                return;
              }
              
              // Check AuthCubit state before navigating
              final authCubit = context.read<AuthCubit>();
              final authState = authCubit.state;
              
              print('AuthCubit state after login: ${authState.runtimeType}');
              
              if (authState is AuthenticatedPatient || authState is AuthenticatedDoctor) {
                print('Navigating to RootScreen...');
                // Navigate to home screen after successful login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const RootScreen()),
                  (route) => false,
                );
              } else {
                print('Auth state is not authenticated: ${authState.runtimeType}');
              }
            },
          ),
          // Backup listener: Listen to AuthCubit state changes directly
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) {
              // Only trigger when transitioning from Unauthenticated/AuthLoading to Authenticated
              final wasUnauthenticated = previous is Unauthenticated || previous is AuthLoading;
              final isNowAuthenticated = current is AuthenticatedPatient || current is AuthenticatedDoctor;
              
              print('AuthCubit listener check: wasUnauthenticated=$wasUnauthenticated, isNowAuthenticated=$isNowAuthenticated');
              
              return wasUnauthenticated && isNowAuthenticated;
            },
            listener: (context, state) {
              // Check if we're on login screen (LoginCubit has a user from recent login)
              final loginCubit = context.read<LoginCubit>();
              final loginState = loginCubit.state;
              
              // Only navigate if LoginCubit has a user (meaning we just logged in)
              if (loginState.user != null && !loginState.isLoading) {
                print('AuthCubit listener triggered! Navigating to RootScreen...');
                // Navigate to home screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const RootScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();

            return Container(
            decoration: gradientBackgroundDecoration,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: Icon(Icons.arrow_back_ios_new, color: greyColor),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.logIn, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context)!.niceToHaveYouBack),
                      const SizedBox(height: 20),
                      LabeledTextFormField(
                        label: AppLocalizations.of(context)!.email,
                        hint: AppLocalizations.of(context)!.enterYourEmail,
                        controller: _emailController,
                        errorText: getLocalizedError(state.emailError, context),
                      ),
                      const SizedBox(height: 12),
                      LabeledTextFormField(
                        label: AppLocalizations.of(context)!.password,
                        hint: AppLocalizations.of(context)!.enterYourPassword,
                        isPassword: true,
                        controller: _passwordController,
                        errorText: getLocalizedError(state.passwordError, context),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(AppLocalizations.of(context)!.forgotPassword, style: greenLink),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => cubit.login(_emailController.text, _passwordController.text),
                        style: greenButtonStyle,
                        child: state.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(AppLocalizations.of(context)!.logIn, style: whiteButtonText),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.areYouNewHere),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => const CreateAccountScreen(),
                                ),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.createAccount, style: greenLink),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          },
        ),
      ),
    );
  }
}
