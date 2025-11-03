import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';

class ProfessionalInfoScreen extends StatefulWidget {
  const ProfessionalInfoScreen({super.key});

  @override
  State<ProfessionalInfoScreen> createState() => _ProfessionalInfoScreenState();
}

class _ProfessionalInfoScreenState extends State<ProfessionalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _workingPlaceController = TextEditingController();
  final _degreeController = TextEditingController();
  final _universityController = TextEditingController();
  final _certificationController = TextEditingController();
  final _certificationInstitutionController = TextEditingController();
  final _trainingController = TextEditingController();
  final _licenceNumberController = TextEditingController();
  final _licenceDescController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _areasOfExperienceController = TextEditingController();

  bool agreeBoxChecked = false;
  bool redCheckBox = false;

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
    super.dispose();
  }

  Widget IconTitle (IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: darkGreenColor,
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
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
                      children: [
                        Text(
                          'Professional info',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        const Text('Provide your professional details to help patients learn about your qualifications and expertise.'),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconTitle(Icons.info, 'General information'),
                              const SizedBox(height: 9),
                              LabeledTextFormField(
                                label: 'Bio / Specialization',
                                greyLabel: true,
                                hint: 'Describe your medical background, specialties, and philosophy of care',
                                controller: _bioController,
                                validator: _validateLongInput,
                                minlines: 3,
                              ),
                              const SizedBox(height: 20),
                              IconTitle(Icons.location_on, 'Current working place'),
                              const SizedBox(height: 9),
                              LabeledTextFormField(
                                label: 'Name / Address',
                                greyLabel: true,
                                hint: 'e.g. Nour Clinic, Hydra, Algiers',
                                controller: _workingPlaceController,
                                validator: _validateShortInput,
                              ),
                              const SizedBox(height: 20),
                              IconTitle(Icons.school, 'Education'),
                              const SizedBox(height: 9),
                              LabeledTextFormField(
                                label: 'Degree',
                                greyLabel: true,
                                hint: 'e.g. Doctor of Medicine (MD)',
                                controller: _degreeController,
                                validator: _validateShortInput,
                              ),
                              const SizedBox(height: 12),
                              LabeledTextFormField(
                                label: 'University',
                                greyLabel: true,
                                hint: 'e.g. University of Algiers 1',
                                controller: _universityController,
                                validator: _validateShortInput,
                              ),
                              const SizedBox(height: 20),
                              IconTitle(Icons.card_membership, 'Certification'),
                              const SizedBox(height: 9),
                              LabeledTextFormField(
                                label: 'Board certification (Optional)',
                                greyLabel: true,
                                hint: 'e.g. Specialist in Cardiology',
                                controller: _certificationController,
                                validator: _validateShortOptionalInput,
                              ),
                              const SizedBox(height: 20),
                              LabeledTextFormField(
                                label: 'Institution (Optional)',
                                greyLabel: true,
                                hint: 'e.g. University of Oran 1',
                                controller: _certificationInstitutionController,
                                validator: _validateShortOptionalInput,
                              ),
                              const SizedBox(height: 20),
                              IconTitle(Icons.medical_services, 'Training'),
                              const SizedBox(height: 9),
                              LabeledTextFormField(
                                label: 'Residency / Fellowship details (Optional)',
                                greyLabel: true,
                                hint: 'e.g. Residency in internal Medicine, Fellowship in Cardiology',
                                controller: _trainingController,
                                validator: _validateMediumOptionalInput,
                                minlines: 2,
                              ),
                              const SizedBox(height: 20),
                              IconTitle(Icons.verified, 'Licensure'),
                              const SizedBox(height: 9),
                              LabeledTextFormField(
                                label: 'License number',
                                greyLabel: true,
                                hint: 'e.g. 12345',
                                controller: _licenceNumberController,
                                validator: _validateLicenceNumber,
                              ),
                              const SizedBox(height: 12),
                              LabeledTextFormField(
                                label: 'Description (Optiona)',
                                greyLabel: true,
                                hint: 'e.g. Authorized to practice medicine in Algeria',
                                controller: _licenceDescController,
                                validator: _validateMediumOptionalInput,
                                minlines: 2,
                              ),
                              const SizedBox(height: 20),
                              IconTitle(Icons.history, 'Experience'),
                              const SizedBox(height: 9),
                              LabeledTextFormField(
                                label: 'Years of practice',
                                greyLabel: true,
                                hint: 'e.g. 16',
                                controller: _yearsOfExperienceController,
                                validator: _validateYearsOfExperience,
                              ),
                              const SizedBox(height: 12),
                              LabeledTextFormField(
                                label: 'Specific areas of expertise',
                                greyLabel: true,
                                hint: 'e.g. Cardiac imaging, hypertension, heart failure management',
                                controller: _areasOfExperienceController,
                                validator: _validateMediumInput,
                                minlines: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  agreeBoxChecked = agreeBoxChecked ? false : true;
                                });
                              },
                              icon: Icon(
                                agreeBoxChecked? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                color: redCheckBox ? redColor : darkGreenColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('I agree to the Terms and Conditions'),
                          ],
                        ),
                        const SizedBox(height: 13),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              redCheckBox = agreeBoxChecked ? false : true;
                            });
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, process data
                            }
                          },
                          style: greenButtonStyle,
                          child: Text(
                            'Create an account',
                            style: whiteButtonText,
                          ),
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

  String? _validateLongInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else if (value.length < 15) {
      return 'Enter at least 15 characters';
    } else {
      return null;
    }
  }

  String? _validateMediumInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else if (value.length < 10) {
      return 'Enter at least 15 characters';
    } else {
      return null;
    }
  }

  String? _validateMediumOptionalInput(String? value) {
    if (value != null && value.isEmpty && value.length < 10) {
      return 'Enter at least 5 characters';
    } else {
      return null;
    }
  }

  String? _validateShortInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else if (value.length < 5) {
      return 'Enter at least 5 characters';
    } else {
      return null;
    }
  }

  String? _validateShortOptionalInput(String? value) {
    if (value != null && value.isEmpty && value.length < 5) {
      return 'Enter at least 5 characters';
    } else {
      return null;
    }
  }

  String? _validateLicenceNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else if (!RegExp(r'^\d{4,6}$').hasMatch(value)) {
      return 'Enter a valid licence number';
    } else {
      return null;
    }
  }

  String? _validateYearsOfExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    } else if (!RegExp(r'^\d{0,2}$').hasMatch(value) && int.parse(value) <= 60) {
      return 'Enter a valid number of years';
    } else {
      return null;
    }
  }

}
