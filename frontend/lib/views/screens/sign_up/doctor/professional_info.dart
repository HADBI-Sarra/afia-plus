import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:afia_plus_app/data/repo/specialities/speciality_repository.dart';
import 'package:afia_plus_app/data/models/speciality.dart';

import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';
import 'package:afia_plus_app/views/widgets/labeled_dropdown_form_field.dart';

import '../../../../logic/cubits/signup/signup_cubit.dart';
import '../../../../logic/cubits/signup/signup_state.dart';
import '../../../../logic/cubits/auth/auth_cubit.dart';
import '../../homescreen/doctor_home_screen.dart';
import '../profile_picture.dart';
import '../../auth/otp_verification_screen.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:afia_plus_app/utils/localization_helper.dart';

class ProfessionalInfoScreen extends StatefulWidget {
  const ProfessionalInfoScreen({super.key});

  @override
  State<ProfessionalInfoScreen> createState() => _ProfessionalInfoScreenState();
}

class _ProfessionalInfoScreenState extends State<ProfessionalInfoScreen> {
  // Loaded specialities from DB
  List<Speciality> _dbSpecialities = [];
  bool _loadingSpecialities = true;
  String? _specialityError;

  // Controllers
  late TextEditingController _bioController;
  late TextEditingController _workingPlaceController;
  late TextEditingController _degreeController;
  late TextEditingController _universityController;
  late TextEditingController _certificationController;
  late TextEditingController _certificationInstitutionController;
  late TextEditingController _trainingController;
  late TextEditingController _licenceNumberController;
  late TextEditingController _licenceDescController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _areasOfExperienceController;
  late TextEditingController _consultationPriceController;

  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with empty controllers first
    _initializeEmptyControllers();
    
    // Schedule initialization after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SignupCubit>();
      // Ensure the step is set to professional when this screen is displayed
      cubit.setCurrentStep(SignupStep.professional);
      _initControllers();
      _loadSpecialities();
    });
  }

  void _initializeEmptyControllers() {
    _bioController = TextEditingController();
    _workingPlaceController = TextEditingController();
    _degreeController = TextEditingController();
    _universityController = TextEditingController();
    _certificationController = TextEditingController();
    _certificationInstitutionController = TextEditingController();
    _trainingController = TextEditingController();
    _licenceNumberController = TextEditingController();
    _licenceDescController = TextEditingController();
    _yearsOfExperienceController = TextEditingController();
    _areasOfExperienceController = TextEditingController();
    _consultationPriceController = TextEditingController();
  }

  void _initControllers() {
    final cubit = context.read<SignupCubit>();
    final state = cubit.state;

    _bioController.text = state.bio;
    _workingPlaceController.text = state.workingPlace;
    _degreeController.text = state.degree;
    _universityController.text = state.university;
    _certificationController.text = state.certification;
    _certificationInstitutionController.text = state.certificationInstitution;
    _trainingController.text = state.training;
    _licenceNumberController.text = state.licenceNumber;
    _licenceDescController.text = state.licenceDesc;
    _yearsOfExperienceController.text = state.yearsOfExperience;
    _areasOfExperienceController.text = state.areasOfExperience;
    _consultationPriceController.text = state.consultationPrice;
    
    _controllersInitialized = true;
  }

  Future<void> _loadSpecialities() async {
    try {
      final repo = GetIt.instance<SpecialityRepository>();
      final list = await repo.getAllSpecialities();

      if (mounted) {
        setState(() {
          _dbSpecialities = list;
          _loadingSpecialities = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() {
          _loadingSpecialities = false;
          _specialityError = 'failedToLoadSpecialities';
        });
      }
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _workingPlaceController.dispose();
    _degreeController.dispose();
    _universityController.dispose();
    _certificationController.dispose();
    _certificationInstitutionController.dispose();
    _trainingController.dispose();
    _licenceNumberController.dispose();
    _licenceDescController.dispose();
    _yearsOfExperienceController.dispose();
    _areasOfExperienceController.dispose();
    _consultationPriceController.dispose();
    super.dispose();
  }

  Widget IconTitle(IconData icon, String title, BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: darkGreenColor),
        const SizedBox(width: 5),
        Text(title, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();

    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (prev, curr) => prev.message != curr.message || prev.currentStep != curr.currentStep,
      listener: (context, state) async {
        // Navigate back to account screen if step changes to account (e.g., email error)
        // For professional screen, we need to pop twice (professional -> personal -> account)
        if (state.currentStep == SignupStep.account) {
          // Show error snackbar before navigating back
          if (state.message.isNotEmpty && state.message != 'Success' && state.message != 'Signup successful') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(getLocalizedError(state.message, context) ?? state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
          // Pop twice to get back to account screen: professional -> personal -> account
          if (Navigator.canPop(context)) {
            Navigator.pop(context); // Pop professional -> personal
          }
          if (Navigator.canPop(context)) {
            Navigator.pop(context); // Pop personal -> account
          }
          return;
        }
        
        // Show snackbar for error messages only (exclude success messages)
        if (state.message.isNotEmpty && 
            state.message != 'Success' && 
            state.message != 'Signup successful') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(getLocalizedError(state.message, context) ?? state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state.message == 'Success' || state.message == 'Signup successful') {
          final authCubit = context.read<AuthCubit>();
          await authCubit.checkLoginStatus();

          // Check if email is verified
          final authState = authCubit.state;
          final bool isEmailVerified = (authState is AuthenticatedPatient && authState.patient.isEmailVerified) ||
              (authState is AuthenticatedDoctor && authState.doctor.isEmailVerified);

          if (!isEmailVerified) {
            // Email not verified - navigate to OTP verification screen
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => OtpVerificationScreen(email: state.email, password: state.password)),
                (route) => false,
              );
            }
          } else {
            // Email is verified - proceed to profile picture screen
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePictureScreen()),
              );
            }
          }
        }
      },
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) {
          // Update controllers if not initialized yet
          if (!_controllersInitialized && state is SignupState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _initControllers();
            });
          }

          return Container(
            decoration: gradientBackgroundDecoration,
            child: WillPopScope(
              onWillPop: () async {
                // Revert cubit step to personal when user navigates back (system back)
                cubit.setCurrentStep(SignupStep.personal);
                return true;
              },
              child: Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: greyColor),
                    onPressed: () {
                      cubit.setCurrentStep(SignupStep.personal);
                      Navigator.of(context).pop();
                    },
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
                            children: [
                              Text(AppLocalizations.of(context)!.professionalInfo,
                                  style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.provideProfessionalDetails,
                              ),
                              const SizedBox(height: 20),

                              // ========== SPECIALITY DROPDOWN ==========
                              IconTitle(Icons.local_hospital, AppLocalizations.of(context)!.mainSpeciality, context),
                              const SizedBox(height: 9),

                              if (_loadingSpecialities)
                                const Center(child: CircularProgressIndicator())

                              else if (_dbSpecialities.isEmpty)
                                Text(_specialityError != null 
                                    ? getLocalizedError(_specialityError, context) ?? AppLocalizations.of(context)!.noSpecialitiesFound
                                    : AppLocalizations.of(context)!.noSpecialitiesFound)

                              else
                                LabeledDropdownFormField<Speciality>(
                                  label: AppLocalizations.of(context)!.speciality,
                                  greyLabel: true,
                                  hint: AppLocalizations.of(context)!.selectYourSpeciality,
                                  items: _dbSpecialities,
                                  itemLabel: (s) => s.name,
                                  value: _dbSpecialities
                                    .cast<Speciality?>()
                                    .firstWhere(
                                      (s) => s?.id == state.specialityId,
                                      orElse: () => null,
                                    ),
                                  onChanged: (selected) {
                                    if (selected != null) {
                                      cubit.setSpecialityId(selected.id!);
                                      cubit.setSpecialityName(selected.name);
                                    }
                                  },
                                  errorText: getLocalizedError(state.specialityError, context),
                                ),

                              const SizedBox(height: 20),


                              // ========== ALL OTHER FIELDS ==========
                              _buildAllFields(context, state, cubit),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllFields(
      BuildContext context, SignupState state, SignupCubit cubit) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconTitle(Icons.info, l10n.generalInformation, context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: l10n.bioSpecialization,
          greyLabel: true,
          hint: l10n.describeMedicalBackground,
          controller: _bioController,
          errorText: getLocalizedError(state.bioError, context),
          minlines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.location_on, l10n.currentWorkingPlace, context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: l10n.nameAddress,
          greyLabel: true,
          hint: l10n.workingPlaceExample,
          controller: _workingPlaceController,
          errorText: getLocalizedError(state.workingPlaceError, context),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.school, l10n.education, context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: l10n.degree,
          greyLabel: true,
          hint: l10n.degreeExample,
          controller: _degreeController,
          errorText: getLocalizedError(state.degreeError, context),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        LabeledTextFormField(
          label: l10n.university,
          greyLabel: true,
          hint: l10n.universityExample,
          controller: _universityController,
          errorText: getLocalizedError(state.universityError, context),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.card_membership, l10n.certification, context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: l10n.certificationOptional,
          greyLabel: true,
          hint: l10n.certificationExample,
          controller: _certificationController,
          errorText: getLocalizedError(state.certificationError, context),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        LabeledTextFormField(
          label: l10n.institutionOptional,
          greyLabel: true,
          hint: l10n.institutionExample,
          controller: _certificationInstitutionController,
          errorText: getLocalizedError(state.certificationInstitutionError, context),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.medical_services, l10n.training, context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: l10n.residencyFellowshipOptional,
          greyLabel: true,
          hint: l10n.trainingExample,
          controller: _trainingController,
          errorText: getLocalizedError(state.trainingError, context),
          minlines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.verified, l10n.licensure, context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: l10n.licenseNumber,
          greyLabel: true,
          hint: l10n.licenseNumberExample,
          controller: _licenceNumberController,
          errorText: getLocalizedError(state.licenceNumberError, context),
        ),
        const SizedBox(height: 12),
        LabeledTextFormField(
          label: l10n.descriptionOptional,
          greyLabel: true,
          hint: l10n.licenseDescriptionExample,
          controller: _licenceDescController,
          errorText: getLocalizedError(state.licenceDescError, context),
          minlines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.history, l10n.experience, context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: l10n.yearsOfPractice,
          greyLabel: true,
          hint: l10n.yearsOfPracticeExample,
          controller: _yearsOfExperienceController,
          errorText: getLocalizedError(state.yearsOfExperienceError, context),
        ),
        const SizedBox(height: 12),
        LabeledTextFormField(
          label: l10n.specificAreasOfExpertise,
          greyLabel: true,
          hint: l10n.areasOfExpertiseExample,
          controller: _areasOfExperienceController,
          errorText: getLocalizedError(state.areasOfExperienceError, context),
          minlines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.payments, l10n.consultationFees, context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: l10n.priceForOneHourConsultation,
          greyLabel: true,
          hint: l10n.consultationPriceExample,
          controller: _consultationPriceController,
          errorText: getLocalizedError(state.consultationPriceError, context),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),

        // TERMS + BUTTON (wrap text to avoid overflow on small screens)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: cubit.toggleProfessionalAgreeBox,
              icon: Icon(
                state.professionalAgreeBoxChecked
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: state.professionalRedCheckBox
                    ? redColor
                    : darkGreenColor,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                l10n.iAgreeToTermsAndConditions,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),

        ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () {
                  // Push latest controller values into Cubit, then validate/submit
                  cubit.setBio(_bioController.text);
                  cubit.setWorkingPlace(_workingPlaceController.text);
                  cubit.setDegree(_degreeController.text);
                  cubit.setUniversity(_universityController.text);
                  cubit.setCertification(_certificationController.text);
                  cubit.setCertificationInstitution(_certificationInstitutionController.text);
                  cubit.setTraining(_trainingController.text);
                  cubit.setLicenceNumber(_licenceNumberController.text);
                  cubit.setLicenceDesc(_licenceDescController.text);
                  cubit.setYearsOfExperience(_yearsOfExperienceController.text);
                  cubit.setAreasOfExperience(_areasOfExperienceController.text);
                  cubit.setConsultationPrice(_consultationPriceController.text);
                  cubit.submitProfessionalData();
                },
          style: greenButtonStyle,
          child: state.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(l10n.createAnAccount, style: whiteButtonText),
        ),
      ],
    );
  }
}
