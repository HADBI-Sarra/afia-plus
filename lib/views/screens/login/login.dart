import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart'; // <-- added
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';
import '../../../data/repo/auth/auth_repository.dart';
import '../../../logic/cubits/login/login_cubit.dart';
import '../../../logic/cubits/login/login_state.dart';
import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';

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
      create: (_) => LoginCubit(GetIt.instance<AuthRepository>()), // <-- FIXED DI
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
                      Text('Log in', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      const Text('Nice to have you back!'),
                      const SizedBox(height: 20),
                      LabeledTextFormField(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: _emailController,
                        errorText: state.emailError,
                        onChanged: cubit.validateEmail,
                      ),
                      const SizedBox(height: 12),
                      LabeledTextFormField(
                        label: 'Password',
                        hint: 'Enter your password',
                        isPassword: true,
                        controller: _passwordController,
                        errorText: state.passwordError,
                        onChanged: cubit.validatePassword,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('Forgot password?', style: greenLink),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => cubit.login(_emailController.text, _passwordController.text),
                        style: greenButtonStyle,
                        child: state.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text('Log in', style: whiteButtonText),
                      ),
                      if (state.message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(state.message, style: const TextStyle(color: Colors.red)),
                        ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Are you new here? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => const CreateAccountScreen(),
                                ),
                              );
                            },
                            child: Text('Create account', style: greenLink),
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
    );
  }
}
