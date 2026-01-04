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
        setState(() {
          _loadingSpecialities = false;
          _specialityError = 'Failed to load specialities';
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
      listenWhen: (prev, curr) => prev.message != curr.message,
      listener: (context, state) async {
        // Show snackbar for error messages only (exclude success messages and email already in use)
        if (state.message.isNotEmpty && 
            state.message != 'Success' && 
            state.message != 'Signup successful' &&
            state.message != 'Email already in use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state.message == 'Success' || state.message == 'Signup successful') {
          final authCubit = context.read<AuthCubit>();
          await authCubit.checkLoginStatus();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
            (route) => false,
          );
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
                              Text('Professional info',
                                  style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 10),
                              const Text(
                                'Provide your professional details to help patients learn about your qualifications and expertise.',
                              ),
                              const SizedBox(height: 20),

                              // ========== SPECIALITY DROPDOWN ==========
                              IconTitle(Icons.local_hospital, 'Main speciality', context),
                              const SizedBox(height: 9),

                              if (_loadingSpecialities)
                                const Center(child: CircularProgressIndicator())

                              else if (_dbSpecialities.isEmpty)
                                const Text('No specialities found')

                              else
                                LabeledDropdownFormField<Speciality>(
                                  label: 'Speciality',
                                  greyLabel: true,
                                  hint: 'Select your speciality',
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
                                  errorText: state.specialityError,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconTitle(Icons.info, 'General information', context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: 'Bio / Specialization',
          greyLabel: true,
          hint:
              'Describe your medical background, specialties, and philosophy of care',
          controller: _bioController,
          errorText: state.bioError,
          minlines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.location_on, 'Current working place', context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: 'Name / Address',
          greyLabel: true,
          hint: 'e.g. Nour Clinic, Hydra, Algiers',
          controller: _workingPlaceController,
          errorText: state.workingPlaceError,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.school, 'Education', context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: 'Degree',
          greyLabel: true,
          hint: 'e.g. Doctor of Medicine (MD)',
          controller: _degreeController,
          errorText: state.degreeError,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        LabeledTextFormField(
          label: 'University',
          greyLabel: true,
          hint: 'e.g. University of Algiers 1',
          controller: _universityController,
          errorText: state.universityError,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.card_membership, 'Certification', context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: 'Certification (Optional)',
          greyLabel: true,
          hint: 'e.g. Specialist in Cardiology',
          controller: _certificationController,
          errorText: state.certificationError,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        LabeledTextFormField(
          label: 'Institution (Optional)',
          greyLabel: true,
          hint: 'e.g. University of Oran 1',
          controller: _certificationInstitutionController,
          errorText: state.certificationInstitutionError,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.medical_services, 'Training', context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: 'Residency / Fellowship details (Optional)',
          greyLabel: true,
          hint:
              'e.g. Residency in internal Medicine, Fellowship in Cardiology',
          controller: _trainingController,
          errorText: state.trainingError,
          minlines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.verified, 'Licensure', context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: 'License number',
          greyLabel: true,
          hint: 'e.g. 12345',
          controller: _licenceNumberController,
          errorText: state.licenceNumberError,
        ),
        const SizedBox(height: 12),
        LabeledTextFormField(
          label: 'Description (Optional)',
          greyLabel: true,
          hint: 'e.g. Authorized to practice medicine in Algeria',
          controller: _licenceDescController,
          errorText: state.licenceDescError,
          minlines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.history, 'Experience', context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: 'Years of practice',
          greyLabel: true,
          hint: 'e.g. 16',
          controller: _yearsOfExperienceController,
          errorText: state.yearsOfExperienceError,
        ),
        const SizedBox(height: 12),
        LabeledTextFormField(
          label: 'Specific areas of expertise',
          greyLabel: true,
          hint:
              'e.g. Cardiac imaging, hypertension, heart failure management',
          controller: _areasOfExperienceController,
          errorText: state.areasOfExperienceError,
          minlines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),

        IconTitle(Icons.payments, 'Consultation fees', context),
        const SizedBox(height: 9),
        LabeledTextFormField(
          label: 'Price for 1-hour consultation',
          greyLabel: true,
          hint: 'e.g. 1000 DA',
          controller: _consultationPriceController,
          errorText: state.consultationPriceError,
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
                'I agree to the Terms and Conditions',
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
              : Text('Create an account', style: whiteButtonText),
        ),
      ],
    );
  }
}
