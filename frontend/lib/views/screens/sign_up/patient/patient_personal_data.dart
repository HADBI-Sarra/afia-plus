import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';
import '../../../../logic/cubits/signup/signup_cubit.dart';
import '../../../../logic/cubits/signup/signup_state.dart';
import '../../../../logic/cubits/auth/auth_cubit.dart';
import '../../homescreen/patient_home_screen.dart';
import '../profile_picture.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:afia_plus_app/utils/localization_helper.dart';

class PatientPersonalDataScreen extends StatefulWidget {
  const PatientPersonalDataScreen({super.key});

  @override
  State<PatientPersonalDataScreen> createState() =>
      _PatientPersonalDataScreenState();
}

class _PatientPersonalDataScreenState extends State<PatientPersonalDataScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _dobController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _ninController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SignupCubit>();

    _firstNameController = TextEditingController(text: cubit.state.firstName);
    _lastNameController = TextEditingController(text: cubit.state.lastName);
    _dobController = TextEditingController(text: cubit.state.dob);
    _phoneNumberController =
        TextEditingController(text: cubit.state.phoneNumber);
    _ninController = TextEditingController(text: cubit.state.nin);
    // Ensure the step is set to personal when this screen is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.setCurrentStep(SignupStep.personal);
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneNumberController.dispose();
    _ninController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (prev, curr) => prev.message != curr.message || prev.currentStep != curr.currentStep,
      listener: (context, state) async {
        // Navigate back to account screen if step changes to account (e.g., email error)
        if (state.currentStep == SignupStep.account) {
          // Show error snackbar before navigating back
          if (state.message.isNotEmpty && state.message != 'Success') {
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
        if (state.message.isNotEmpty && state.message != 'Success' && state.message != 'errorEmailTaken') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(getLocalizedError(state.message, context) ?? state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state.message == 'Success') {
          // Make sure the AuthCubit fetches the current user
          final authCubit = context.read<AuthCubit>();
          await authCubit.checkLoginStatus();

          // Navigate to profile picture screen instead of directly to home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePictureScreen()),
          );
        }
      },
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) {
          final cubit = context.read<SignupCubit>();

          // Keep controllers synced if state changes
          _firstNameController.value =
              _firstNameController.value.copyWith(text: state.firstName);
          _lastNameController.value =
              _lastNameController.value.copyWith(text: state.lastName);
          _dobController.value =
              _dobController.value.copyWith(text: state.dob);
          _phoneNumberController.value =
              _phoneNumberController.value.copyWith(text: state.phoneNumber);
          _ninController.value =
              _ninController.value.copyWith(text: state.nin);

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
                      // Revert cubit step to account when user taps the back arrow
                      cubit.setCurrentStep(SignupStep.account);
                      Navigator.pop(context);
                    },
                  ),
                ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.personalData,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.providePersonalData,
                      ),
                      const SizedBox(height: 20),

                      LabeledTextFormField(
                        label: AppLocalizations.of(context)!.firstName,
                        hint: AppLocalizations.of(context)!.enterYourFirstName,
                        controller: _firstNameController,
                        onChanged: cubit.setFirstName,
                        errorText: getLocalizedError(state.firstNameError, context),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),

                      LabeledTextFormField(
                        label: AppLocalizations.of(context)!.lastName,
                        hint: AppLocalizations.of(context)!.enterYourLastName,
                        controller: _lastNameController,
                        onChanged: cubit.setLastName,
                        errorText: getLocalizedError(state.lastNameError, context),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),

                      LabeledTextFormField(
                        label: AppLocalizations.of(context)!.dateOfBirth,
                        hint: AppLocalizations.of(context)!.dateFormatHint,
                        controller: _dobController,
                        isDate: true,
                        onChanged: cubit.setDob,
                        errorText: getLocalizedError(state.dobError, context),
                      ),
                      const SizedBox(height: 12),

                      LabeledTextFormField(
                        label: AppLocalizations.of(context)!.phoneNumber,
                        hint: AppLocalizations.of(context)!.phoneNumberExample,
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        onChanged: cubit.setPhoneNumber,
                        errorText: getLocalizedError(state.phoneError, context),
                      ),
                      const SizedBox(height: 12),

                      LabeledTextFormField(
                        label: AppLocalizations.of(context)!.nationalIdentificationNumber,
                        hint: AppLocalizations.of(context)!.ninExample,
                        controller: _ninController,
                        keyboardType: TextInputType.number,
                        onChanged: cubit.setNin,
                        errorText: getLocalizedError(state.ninError, context),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: cubit.toggleAgreeBox,
                            icon: Icon(
                              state.agreeBoxChecked
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: state.redCheckBox
                                  ? redColor
                                  : darkGreenColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!.iAgreeToTermsAndConditions,
                              style: Theme.of(context).textTheme.bodyMedium,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: state.isLoading 
                            ? null 
                            : () {
                                // Push latest controller values into Cubit, then validate/submit
                                cubit.setFirstName(_firstNameController.text);
                                cubit.setLastName(_lastNameController.text);
                                cubit.setDob(_dobController.text);
                                cubit.setPhoneNumber(_phoneNumberController.text);
                                cubit.setNin(_ninController.text);
                                cubit.submitPatientPersonalData();
                              },
                        style: greenButtonStyle,
                        child: state.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(AppLocalizations.of(context)!.createAnAccount, style: whiteButtonText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
