import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final List<String> _specialities = [
    'Cardiology',
    'Dermatology',
    'Neurology',
    'Pediatrics',
    'Orthopedics',
    'General Surgery',
    'Ophthalmology',
    'Psychiatry',
  ];

  late final TextEditingController _bioController;
  late final TextEditingController _workingPlaceController;
  late final TextEditingController _degreeController;
  late final TextEditingController _universityController;
  late final TextEditingController _certificationController;
  late final TextEditingController _certificationInstitutionController;
  late final TextEditingController _trainingController;
  late final TextEditingController _licenceNumberController;
  late final TextEditingController _licenceDescController;
  late final TextEditingController _yearsOfExperienceController;
  late final TextEditingController _areasOfExperienceController;
  late final TextEditingController _consultationPriceController;

  @override
  void initState() {
    super.initState();
    final state = context.read<SignupCubit>().state;

    _bioController = TextEditingController(text: state.bio);
    _workingPlaceController = TextEditingController(text: state.workingPlace);
    _degreeController = TextEditingController(text: state.degree);
    _universityController = TextEditingController(text: state.university);
    _certificationController = TextEditingController(text: state.certification);
    _certificationInstitutionController = TextEditingController(text: state.certificationInstitution);
    _trainingController = TextEditingController(text: state.training);
    _licenceNumberController = TextEditingController(text: state.licenceNumber);
    _licenceDescController = TextEditingController(text: state.licenceDesc);
    _yearsOfExperienceController = TextEditingController(text: state.yearsOfExperience);
    _areasOfExperienceController = TextEditingController(text: state.areasOfExperience);
    _consultationPriceController = TextEditingController(text: state.consultationPrice);
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
        if (state.message == 'Success') {
          // Make sure the AuthCubit fetches the current user
          final authCubit = context.read<AuthCubit>();
          await authCubit.checkLoginStatus();

          // Navigate to the home screen after AuthCubit is updated
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
            (route) => false,
          );
        }
      },
      child: BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Container(
          decoration: gradientBackgroundDecoration,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: Icon(Icons.arrow_back_ios_new, color: greyColor),
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Professional info', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 10),
                            const Text(
                              'Provide your professional details to help patients learn about your qualifications and expertise.',
                            ),
                            const SizedBox(height: 20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconTitle(Icons.info, 'General information', context),
                                const SizedBox(height: 9),
                                LabeledTextFormField(
                                  label: 'Bio / Specialization',
                                  greyLabel: true,
                                  hint: 'Describe your medical background, specialties, and philosophy of care',
                                  controller: _bioController,
                                  errorText: state.bioError,
                                  onChanged: cubit.setBio,
                                  minlines: 3,
                                ),
                                const SizedBox(height: 20),

                                IconTitle(Icons.local_hospital, 'Main speciality', context),
                                const SizedBox(height: 9),
                                LabeledDropdownFormField<String>(
                                  label: 'Speciality',
                                  greyLabel: true,
                                  hint: 'Select your speciality',
                                  items: _specialities,
                                  value: state.speciality.isNotEmpty ? state.speciality : null,
                                  onChanged: cubit.setSpeciality,
                                  errorText: state.specialityError,
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
                                  onChanged: cubit.setWorkingPlace,
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
                                  onChanged: cubit.setDegree,
                                ),
                                const SizedBox(height: 12),
                                LabeledTextFormField(
                                  label: 'University',
                                  greyLabel: true,
                                  hint: 'e.g. University of Algiers 1',
                                  controller: _universityController,
                                  errorText: state.universityError,
                                  onChanged: cubit.setUniversity,
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
                                  onChanged: cubit.setCertification,
                                ),
                                const SizedBox(height: 20),
                                LabeledTextFormField(
                                  label: 'Institution (Optional)',
                                  greyLabel: true,
                                  hint: 'e.g. University of Oran 1',
                                  controller: _certificationInstitutionController,
                                  errorText: state.certificationInstitutionError,
                                  onChanged: cubit.setCertificationInstitution,
                                ),
                                const SizedBox(height: 20),

                                IconTitle(Icons.medical_services, 'Training', context),
                                const SizedBox(height: 9),
                                LabeledTextFormField(
                                  label: 'Residency / Fellowship details (Optional)',
                                  greyLabel: true,
                                  hint: 'e.g. Residency in internal Medicine, Fellowship in Cardiology',
                                  controller: _trainingController,
                                  errorText: state.trainingError,
                                  onChanged: cubit.setTraining,
                                  minlines: 2,
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
                                  onChanged: cubit.setLicenceNumber,
                                ),
                                const SizedBox(height: 12),
                                LabeledTextFormField(
                                  label: 'Description (Optional)',
                                  greyLabel: true,
                                  hint: 'e.g. Authorized to practice medicine in Algeria',
                                  controller: _licenceDescController,
                                  errorText: state.licenceDescError,
                                  onChanged: cubit.setLicenceDesc,
                                  minlines: 2,
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
                                  onChanged: cubit.setYearsOfExperience,
                                ),
                                const SizedBox(height: 12),
                                LabeledTextFormField(
                                  label: 'Specific areas of expertise',
                                  greyLabel: true,
                                  hint: 'e.g. Cardiac imaging, hypertension, heart failure management',
                                  controller: _areasOfExperienceController,
                                  errorText: state.areasOfExperienceError,
                                  onChanged: cubit.setAreasOfExperience,
                                  minlines: 2,
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
                                  onChanged: cubit.setConsultationPrice,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),

                            const SizedBox(height: 3),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: cubit.toggleProfessionalAgreeBox,
                                  icon: Icon(
                                    state.professionalAgreeBoxChecked
                                        ? Icons.check_box_rounded
                                        : Icons.check_box_outline_blank_rounded,
                                    color: state.professionalRedCheckBox ? redColor : darkGreenColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text('I agree to the Terms and Conditions'),
                              ],
                            ),
                            const SizedBox(height: 13),

                            ElevatedButton(
                              onPressed: state.isLoading ? null : cubit.submitProfessionalData,
                              style: greenButtonStyle,
                              child: state.isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text('Create an account', style: whiteButtonText),
                            ),

                            if (state.message.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(state.message, style: const TextStyle(color: Colors.red)),
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
        },
      )
    );
  }
}
