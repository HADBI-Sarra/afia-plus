import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';
import '../../../../logic/cubits/signup/signup_cubit.dart';
import '../../../../logic/cubits/signup/signup_state.dart';
import 'professional_info.dart';

class DoctorPersonalDataScreen extends StatefulWidget {
  const DoctorPersonalDataScreen({super.key});

  @override
  State<DoctorPersonalDataScreen> createState() => _DoctorPersonalDataScreenState();
}

class _DoctorPersonalDataScreenState extends State<DoctorPersonalDataScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _ninController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SignupCubit>();
    final state = cubit.state;

    _firstNameController = TextEditingController(text: state.firstName);
    _lastNameController = TextEditingController(text: state.lastName);
    _phoneNumberController = TextEditingController(text: state.phoneNumber);
    _ninController = TextEditingController(text: state.nin);
    // Ensure the step is set to personal when this screen is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.setCurrentStep(SignupStep.personal);
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _ninController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();

    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (previous, current) => previous.message != current.message,
      listener: (context, state) {
        // Show snackbar for error messages (except email already in use, which shows as field errorText)
        if (state.message.isNotEmpty && state.message != 'NextStep' && state.message != 'Email already in use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state.message == 'NextStep') {
          // Clear the message before navigating to avoid listener firing again
          cubit.clearMessage();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfessionalInfoScreen()),
          );
        }
      },
      child:BlocBuilder<SignupCubit, SignupState>(
          builder: (context, state) {
            return Container(
              decoration: gradientBackgroundDecoration,
              child: WillPopScope(
                onWillPop: () async {
                  // Ensure cubit step is reverted when user navigates back (system back)
                  cubit.setCurrentStep(SignupStep.account);
                  return true;
                },
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: greyColor),
                      onPressed: () {
                        cubit.setCurrentStep(SignupStep.account);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Personal data', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 10),
                        const Text(
                          'Provide your personal data to offer online consultations quickly and securely.',
                        ),
                        const SizedBox(height: 20),
                        LabeledTextFormField(
                          label: 'First name',
                          hint: 'Enter your first name',
                          controller: _firstNameController,
                          errorText: state.firstNameError,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 12),
                        LabeledTextFormField(
                          label: 'Last name',
                          hint: 'Enter your last name',
                          controller: _lastNameController,
                          errorText: state.lastNameError,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 12),
                        LabeledTextFormField(
                          label: 'Phone number',
                          hint: 'e.g. 05123 45 67 89',
                          controller: _phoneNumberController,
                          errorText: state.phoneError,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        LabeledTextFormField(
                          label: 'National Identification Number (NIN)',
                          hint: 'e.g. 198012345678901234',
                          controller: _ninController,
                          errorText: state.ninError,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  // Push latest controller values into Cubit, then validate/submit
                                  cubit.setFirstName(_firstNameController.text);
                                  cubit.setLastName(_lastNameController.text);
                                  cubit.setPhoneNumber(_phoneNumberController.text);
                                  cubit.setNin(_ninController.text);
                                  cubit.submitPersonalData();
                                },
                          style: greenButtonStyle,
                          child: state.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text('Next', style: whiteButtonText),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
          },
        )
      );
  }
}
