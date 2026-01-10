import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';
import '../../../../logic/cubits/signup/signup_cubit.dart';
import '../../../../logic/cubits/signup/signup_state.dart';
import 'professional_info.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:afia_plus_app/utils/localization_helper.dart';

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
      listenWhen: (previous, current) => previous.message != current.message || previous.currentStep != current.currentStep,
      listener: (context, state) {
        // Navigate back to account screen if step changes to account (e.g., email error)
        if (state.currentStep == SignupStep.account) {
          // Show error snackbar before navigating back
          if (state.message.isNotEmpty && state.message != 'Success' && state.message != 'NextStep') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(getLocalizedError(state.message, context) ?? state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
          Navigator.pop(context);
          return;
        }
        
        // Show snackbar for error messages
        if (state.message.isNotEmpty && state.message != 'NextStep' && state.message != 'errorEmailTaken') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(getLocalizedError(state.message, context) ?? state.message),
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
                        Text(AppLocalizations.of(context)!.personalData, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)!.providePersonalDataDoctor,
                        ),
                        const SizedBox(height: 20),
                        LabeledTextFormField(
                          label: AppLocalizations.of(context)!.firstName,
                          hint: AppLocalizations.of(context)!.enterYourFirstName,
                          controller: _firstNameController,
                          errorText: getLocalizedError(state.firstNameError, context),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 12),
                        LabeledTextFormField(
                          label: AppLocalizations.of(context)!.lastName,
                          hint: AppLocalizations.of(context)!.enterYourLastName,
                          controller: _lastNameController,
                          errorText: getLocalizedError(state.lastNameError, context),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 12),
                        LabeledTextFormField(
                          label: AppLocalizations.of(context)!.phoneNumber,
                          hint: AppLocalizations.of(context)!.phoneNumberExample,
                          controller: _phoneNumberController,
                          errorText: getLocalizedError(state.phoneError, context),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        LabeledTextFormField(
                          label: AppLocalizations.of(context)!.nationalIdentificationNumber,
                          hint: AppLocalizations.of(context)!.ninExample,
                          controller: _ninController,
                          errorText: getLocalizedError(state.ninError, context),
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
                              : Text(AppLocalizations.of(context)!.next, style: whiteButtonText),
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
