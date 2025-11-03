import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/labeled_text_form_field.dart';

class DoctorPersonalDataScreen extends StatefulWidget {
  const DoctorPersonalDataScreen({super.key});

  @override
  State<DoctorPersonalDataScreen> createState() => _DoctorPersonalDataScreenState();
}

class _DoctorPersonalDataScreenState extends State<DoctorPersonalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _ninController = TextEditingController();

  bool agreeBoxChecked = false;

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
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal data',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        const Text('Provide your personal data to offer online consultations quickly and securely.'),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LabeledTextFormField(
                                label: 'First name',
                                hint: 'Enter your first name',
                                controller: _firstNameController,
                                validator: _validateFirstName,
                              ),
                              const SizedBox(height: 12),
                              LabeledTextFormField(
                                label: 'Last name',
                                hint: 'Enter your last name',
                                controller: _lastNameController,
                                validator: _validateLastName,
                              ),
                              const SizedBox(height: 12),
                              LabeledTextFormField(
                                label: 'Date of birth',
                                hint: 'DD/MM/YYYY',
                                controller: _dobController,
                                validator: _validateDob,
                                isDate: true,
                              ),
                              const SizedBox(height: 12),
                              LabeledTextFormField(
                                label: 'Phone number',
                                hint: 'e.g. 05123 45 67 89',
                                controller: _phoneNumberController,
                                validator: _validatePhoneNumber,
                              ),
                              const SizedBox(height: 12),
                              LabeledTextFormField(
                                label: 'National Identification Number (NIN)',
                                hint: 'e.g. 198012345678901234',
                                controller: _ninController,
                                validator: _validateNin,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, process data
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name cannot be empty';
    } else if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) {
      return 'Enter a valid first name';
    } else {
      return null;
    }
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name cannot be empty';
    } else if (!RegExp(r"^[A-Za-z'-]{2,}$").hasMatch(value)) {
      return 'Enter a valid last name';
    } else {
      return null;
    }
  }

  String? _validateDob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of birth cannot be empty';
    } else if (int.parse(value.substring(6, 10)) >= 2008) {
      return 'You are to young to have an account';
    } else {
      return null;
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    } else if (!RegExp(r'^0[567][0-9]{8}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    } else {
      return null;
    }
  }

  String? _validateNin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name cannot be empty';
    } else if (!RegExp(r'^[0-9]{18}$').hasMatch(value)) {
      return 'Enter a valid NIN';
    } else {
      return null;
    }
  }

}
