import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';
import 'package:afia_plus_app/views/widgets/password_error_text.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool firstTry = true;
  bool strongPassword = false;
  bool long = true;
  bool hasLowercase = true;
  bool hasUppercase = true;
  bool hasNumber = true;
  bool hasSpecial = true;

  bool isPatient = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.arrow_back_ios_new,
            color: greyColor,
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create an account',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            const Text('Excited to have you on board!'),
                            const SizedBox(height: 20),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Register as',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: isPatient ? whiteButtonStyle : greenButtonStyle,
                                          onPressed: () {
                                            setState(() {
                                              isPatient = false;
                                            });
                                          },
                                          child: Text(
                                            'Doctor',
                                            style: isPatient ? greyButtonText : whiteButtonText,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: isPatient ? greenButtonStyle : whiteButtonStyle,
                                          onPressed: () {
                                            setState(() {
                                              isPatient = true;
                                            });
                                          },
                                          child: Text(
                                            'Patient',
                                            style: isPatient? whiteButtonText : greyButtonText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  LabeledTextFormField(
                                    label: 'Email',
                                    hint: 'Enter your email',
                                    controller: _emailController,
                                    validator: _validateEmail,
                                  ),
                                  const SizedBox(height: 12),
                                  LabeledTextFormField(
                                    label: 'Password',
                                    hint: 'Create password',
                                    isPassword: true,
                                    controller: _passwordController,
                                    validator: _validatePassword,
                                    onChanged: checkPasswordStrength,
                                  ),
                                  Visibility(
                                    visible: !firstTry && !strongPassword,
                                    child: Padding(
                                      padding: EdgeInsetsGeometry.fromLTRB(24, 0, 0, 0),
                                      child: Column(
                                        children: [
                                          PasswordErrorText(
                                            text: 'Min 8 characters length', 
                                            control: long
                                          ),
                                          PasswordErrorText(
                                            text: 'Min 1 lowercase letter',
                                            control: hasLowercase
                                          ),
                                          PasswordErrorText(
                                            text: 'Min 1 uppercase letter',
                                            control: hasUppercase
                                          ),
                                          PasswordErrorText(
                                            text: 'Min 1 digit',
                                            control: hasNumber
                                          ),
                                          PasswordErrorText(
                                            text: 'Min 1 special character',
                                            control: hasSpecial
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  LabeledTextFormField(
                                    label: 'Confirm Password',
                                    hint: 'Repeate password',
                                    isPassword: true,
                                    controller: _confirmPasswordController,
                                    validator: _validateConfirmPassword,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Form is valid, submit
                                }
                              },
                              style: greenButtonStyle,
                              child: Text(
                                'Next',
                                style: whiteButtonText,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account? '),
                                Text(
                                  'Log in',
                                  style: greenLink,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (!strongPassword) {
      firstTry = false;
      return 'Weak password';
    } else {
      return null;
    }
  }

  void checkPasswordStrength(String value) {
    long = value.length >= 8;
    hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    hasNumber = RegExp(r'[0-9]').hasMatch(value);
    hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);
    strongPassword = long && hasLowercase && hasUppercase && hasNumber && hasSpecial;

    setState(() {});
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password confirmation cannot be empty';
    } else if (_passwordController.text != value) {
      return 'Incorrect Value';
    } else {
      return null;
    }
  }

}