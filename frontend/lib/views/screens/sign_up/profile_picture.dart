import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import '../../../../logic/cubits/signup/signup_cubit.dart';
import '../../../../logic/cubits/signup/signup_state.dart';
import '../../../../logic/cubits/auth/auth_cubit.dart';
import '../homescreen/doctor_home_screen.dart';
import '../homescreen/patient_home_screen.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Ensure the step is set to profilePicture when this screen is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignupCubit>().setCurrentStep(SignupStep.profilePicture);
    });
  }

  Future<void> _showImageSourceModal() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'More options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library, color: darkGreenColor),
                title: const Text('Upload from Gallery'),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: darkGreenColor),
                title: const Text('Take photo'),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: redColor),
                title: const Text(
                  'Cancel',
                  style: TextStyle(color: redColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _skipProfilePicture() {
    _completeSignup();
  }

  void _completeSignup() {
    final cubit = context.read<SignupCubit>();
    final state = cubit.state;
    
    // For now, just complete the signup without uploading the image
    // The image will be handled later when backend integration is added
    if (state.isPatient) {
      // Patient signup was already completed in patient_personal_data.dart
      // Just navigate to home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
        (route) => false,
      );
    } else {
      // Doctor signup was already completed in professional_info.dart
      // Just navigate to home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    final state = cubit.state;
    final isPatient = state.isPatient;

    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (prev, curr) => prev.currentStep != curr.currentStep,
      listener: (context, state) {
        // Handle navigation back if step changes
        if (state.currentStep == SignupStep.professional) {
          Navigator.pop(context);
        } else if (state.currentStep == SignupStep.personal) {
          // Pop twice: profilePicture -> professional -> personal
          if (Navigator.canPop(context)) Navigator.pop(context);
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      },
      child: Container(
        decoration: gradientBackgroundDecoration,
        child: WillPopScope(
          onWillPop: () async {
            // Revert cubit step when user navigates back
            if (isPatient) {
              cubit.setCurrentStep(SignupStep.personal);
            } else {
              cubit.setCurrentStep(SignupStep.professional);
            }
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
                  if (isPatient) {
                    cubit.setCurrentStep(SignupStep.personal);
                  } else {
                    cubit.setCurrentStep(SignupStep.professional);
                  }
                  Navigator.pop(context);
                },
              ),
              actions: [
                TextButton(
                  onPressed: _skipProfilePicture,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Title and subtitle at top
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Profile picture',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        // Subtitle - changes based on role
                        Text(
                          isPatient
                              ? 'Help people recognize you with a professional headshot.'
                              : 'Help patients recognize you with a professional headshot.',
                        ),
                      ],
                    ),
                  ),
                  // Vertically centered avatar
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: darkGreenColor.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 120,
                                color: greyColor.withOpacity(0.4),
                              ),
                      ),
                    ),
                  ),
                  // Fixed button at bottom
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        if (_selectedImage != null) ...[
                          ElevatedButton(
                            onPressed: _completeSignup,
                            style: greenButtonStyle,
                            child: Text('Continue', style: whiteButtonText),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: Text(
                              'Change photo',
                              style: TextStyle(
                                color: darkGreenColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ] else
                          ElevatedButton(
                            onPressed: _showImageSourceModal,
                            style: greenButtonStyle,
                            child: Text('Add a profile picture', style: whiteButtonText),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

