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
import 'package:afia_plus_app/l10n/app_localizations.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context)!.moreOptions,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library, color: darkGreenColor),
                title: Text(AppLocalizations.of(context)!.uploadFromGallery),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: darkGreenColor),
                title: Text(AppLocalizations.of(context)!.takePhoto),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: redColor),
                title: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(color: redColor),
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
        // Store the path in cubit
        final cubit = context.read<SignupCubit>();
        cubit.setProfilePicture(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorPickingImage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _skipProfilePicture() {
    _completeSignup();
  }

  Future<void> _completeSignup() async {
    if (_isUploading) return; // Prevent multiple clicks

    final cubit = context.read<SignupCubit>();
    final state = cubit.state;

    // Upload profile picture if one was selected
    if (_selectedImage != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        // Use the actual file path from the selected image
        final imagePath = _selectedImage!.path;
        print('Uploading profile picture from path: $imagePath');

        final result = await cubit.uploadProfilePicture(imagePath);

        // Check if upload was successful
        if (result.state && result.data != null) {
          print('Profile picture uploaded successfully: ${result.data}');
          // Upload successful, proceed to home (no snackbar)
        } else {
          // Show error but still allow navigation
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        print('Exception during upload: $e');
        // Show error but still allow navigation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.errorUploadingProfilePicture(e.toString())),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }

    // Navigate to home screen
    if (state.isPatient) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
        (route) => false,
      );
    } else {
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
      listenWhen: (prev, curr) =>
          prev.currentStep != curr.currentStep ||
          (prev.message != curr.message && curr.message.isNotEmpty),
      listener: (context, state) {
        // Handle navigation back if step changes
        if (state.currentStep == SignupStep.professional) {
          Navigator.pop(context);
        } else if (state.currentStep == SignupStep.personal) {
          // Pop twice: profilePicture -> professional -> personal
          if (Navigator.canPop(context)) Navigator.pop(context);
          if (Navigator.canPop(context)) Navigator.pop(context);
        }

        // Suppress success messages - don't show snackbars for success
        // Success messages are handled silently (no snackbars)
        // Error messages are handled in _completeSignup method
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
                    AppLocalizations.of(context)!.skip,
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
                          AppLocalizations.of(context)!.profilePicture,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        // Subtitle - changes based on role
                        Text(
                          isPatient
                              ? AppLocalizations.of(context)!.helpPeopleRecognizeYou
                              : AppLocalizations.of(context)!.helpPatientsRecognizeYou,
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
                            onPressed: _isUploading ? null : _completeSignup,
                            style: greenButtonStyle,
                            child: _isUploading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(AppLocalizations.of(context)!.continueButton, style: whiteButtonText),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: Text(
                              AppLocalizations.of(context)!.changePhoto,
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
                            child: Text(AppLocalizations.of(context)!.addAProfilePicture, style: whiteButtonText),
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
