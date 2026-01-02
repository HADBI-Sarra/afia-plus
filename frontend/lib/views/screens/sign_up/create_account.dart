import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';
import 'package:afia_plus_app/views/widgets/password_error_text.dart';

import '../../../logic/cubits/signup/signup_cubit.dart';
import '../../../logic/cubits/signup/signup_state.dart';

import 'package:afia_plus_app/views/screens/login/login.dart';
import 'package:afia_plus_app/views/screens/sign_up/patient/patient_personal_data.dart';
import 'package:afia_plus_app/views/screens/sign_up/doctor/doctor_personal_data.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    // Ensure the step is set to account when this screen is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignupCubit>().setCurrentStep(SignupStep.account);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (prev, curr) =>
          prev.currentStep != curr.currentStep || prev.message != curr.message,
      listener: (context, state) {
        // Show snackbar for error messages (except email already in use, which shows as errorText)
        if (state.message.isNotEmpty &&
            state.message != 'Success' &&
            state.message != 'NextStep' &&
            state.message != 'Email already in use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        // Navigate automatically based on step
        if (state.currentStep == SignupStep.personal) {
          if (state.isPatient) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PatientPersonalDataScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DoctorPersonalDataScreen(),
              ),
            );
          }
        }
      },
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) {
          final cubit = context.read<SignupCubit>();

          // Keep controllers synced with state
          _emailController.value = _emailController.value.copyWith(
            text: state.email,
          );
          _passwordController.value = _passwordController.value.copyWith(
            text: state.password,
          );
          _confirmPasswordController.value = _confirmPasswordController.value
              .copyWith(text: state.confirmPassword);

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
                      Text(
                        'Create an account',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      const Text('Excited to have you on board!'),
                      const SizedBox(height: 20),

                      /// ROLE SELECTOR
                      Text(
                        'Register as',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: state.isPatient
                                  ? whiteButtonStyle
                                  : greenButtonStyle,
                              onPressed: () => cubit.setRole(false),
                              child: Text(
                                'Doctor',
                                style: state.isPatient
                                    ? greyButtonText
                                    : whiteButtonText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              style: state.isPatient
                                  ? greenButtonStyle
                                  : whiteButtonStyle,
                              onPressed: () => cubit.setRole(true),
                              child: Text(
                                'Patient',
                                style: state.isPatient
                                    ? whiteButtonText
                                    : greyButtonText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      /// EMAIL
                      LabeledTextFormField(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: _emailController,
                        onChanged: cubit.setEmail,
                        errorText: state.emailError,
                      ),
                      const SizedBox(height: 12),

                      /// PASSWORD
                      LabeledTextFormField(
                        label: 'Password',
                        hint: 'Create password',
                        isPassword: true,
                        controller: _passwordController,
                        onChanged: cubit.setPassword,
                        // Never show an error when the password is strong.
                        errorText: state.strongPassword
                            ? null
                            : state.passwordError,
                      ),
                      // Show criteria once the user has attempted the password at least once.
                      // They remain visible (weak or strong) until the user presses "Next"
                      // with a strong password, at which point validateAccountStep
                      // will reset firstTry and hide them.
                      if (!state.firstTry) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 24, top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Summary line: only show a green "Strong password" when all criteria are met.
                              // For weak passwords we rely on the field's errorText ("Weak password")
                              // to avoid showing two weak-password messages.
                              if (state.strongPassword) ...[
                                Text(
                                  'Strong password',
                                  style: TextStyle(
                                    color: greenColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              PasswordErrorText(
                                text: 'Min 8 characters length',
                                control: state.long,
                              ),
                              PasswordErrorText(
                                text: 'Min 1 lowercase letter',
                                control: state.hasLowercase,
                              ),
                              PasswordErrorText(
                                text: 'Min 1 uppercase letter',
                                control: state.hasUppercase,
                              ),
                              PasswordErrorText(
                                text: 'Min 1 digit',
                                control: state.hasNumber,
                              ),
                              PasswordErrorText(
                                text: 'Min 1 special character',
                                control: state.hasSpecial,
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),

                      /// CONFIRM PASSWORD
                      LabeledTextFormField(
                        label: 'Confirm Password',
                        hint: 'Repeat password',
                        isPassword: true,
                        controller: _confirmPasswordController,
                        onChanged: cubit.setConfirmPassword,
                        errorText: state.confirmPasswordError,
                      ),
                      const SizedBox(height: 30),

                      /// NEXT BUTTON
                      ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                // Push latest controller values into Cubit, then validate/submit
                                cubit.setEmail(_emailController.text);
                                cubit.setPassword(_passwordController.text);
                                cubit.setConfirmPassword(
                                  _confirmPasswordController.text,
                                );
                                cubit.submitPersonalData();
                              },
                        style: greenButtonStyle,
                        child: state.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('Next', style: whiteButtonText),
                      ),

                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            ),
                            child: Text('Log in', style: greenLink),
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
