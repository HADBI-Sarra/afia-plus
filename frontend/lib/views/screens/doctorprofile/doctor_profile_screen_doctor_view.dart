import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:afia_plus_app/data/repo/specialities/speciality_repository.dart';
import 'package:afia_plus_app/data/models/speciality.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_doctor.dart';
import '../../../../logic/cubits/auth/auth_cubit.dart';
import '../../../../logic/cubits/signup/signup_cubit.dart';
import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:afia_plus_app/utils/localization_helper.dart';

class DoctorViewDoctorProfileScreen extends StatefulWidget {
  static const routename = "/doctorViewDoctorProfile";
  const DoctorViewDoctorProfileScreen({super.key});

  @override
  State<DoctorViewDoctorProfileScreen> createState() =>
      _DoctorViewDoctorProfileScreenState();
}

class _DoctorViewDoctorProfileScreenState
    extends State<DoctorViewDoctorProfileScreen> {
  // Loaded specialities from DB
  List<Speciality> _dbSpecialities = [];
  bool _loadingSpecialities = true;
  String? _specialityError;
  bool _imageError = false;
  String? _lastProfilePictureUrl;

  @override
  void initState() {
    super.initState();
    // Load specialities after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSpecialities();
    });
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
      print('Error loading specialities: $e');
      if (mounted) {
        setState(() {
          _loadingSpecialities = false;
          _specialityError = 'failedToLoadSpecialities';
        });
      }
    }
  }

  // Helper method to get speciality name by ID
  String _getSpecialityNameById(int? specialityId) {
    if (specialityId == null || specialityId == 0) {
      return "Specialty not set";
    }
    
    try {
      final speciality = _dbSpecialities.firstWhere(
        (s) => s.id == specialityId,
        orElse: () => Speciality(id: 0, name: "Loading..."),
      );
      return speciality.name;
    } catch (e) {
      return "Unknown Specialty";
    }
  }

  // Show logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            "Logout",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: darkGreenColor,
            ),
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(
              fontSize: 16,
              color: blackColor,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  color: darkGreenColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                context.read<AuthCubit>().logout(); // Perform logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreenColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                  color: whiteColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Text(
            "Profile",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: blackColor),
          ),
        ),
        body: SafeArea(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                context.read<SignupCubit>().reset();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
                  (route) => false,
                );
              }
            },
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                String fullName = "Doctor";
                String subtitle = "Specialty not set";
                Widget profilePic = CircleAvatar(
                  radius: 50,
                  backgroundColor: greyColor.withOpacity(0.3),
                  child: const Icon(Icons.person, size: 50, color: whiteColor),
                );

                if (state is AuthenticatedDoctor) {
                  final doctor = state.doctor;
                  fullName = "${doctor.firstname} ${doctor.lastname}";

                  // Get speciality name
                  if (_loadingSpecialities) {
                    subtitle = "Loading specialty...";
                  } else {
                    subtitle = _getSpecialityNameById(doctor.specialityId);
                  }

                  // Display profile picture if available
                  final profilePictureUrl = doctor.profilePicture;
                  
                  // Reset error state if profile picture URL changes
                  if (_lastProfilePictureUrl != profilePictureUrl) {
                    _imageError = false;
                    _lastProfilePictureUrl = profilePictureUrl;
                  }
                  
                  if (profilePictureUrl != null && 
                      profilePictureUrl.isNotEmpty &&
                      profilePictureUrl.trim().isNotEmpty &&
                      !_imageError) {
                    try {
                      profilePic = CircleAvatar(
                        radius: 50,
                        backgroundColor: greyColor.withOpacity(0.3),
                        backgroundImage: NetworkImage(profilePictureUrl),
                        onBackgroundImageError: (exception, stackTrace) {
                          // If image fails to load, use default icon
                          if (mounted && _lastProfilePictureUrl == profilePictureUrl) {
                            setState(() {
                              _imageError = true;
                            });
                          }
                        },
                      );
                    } catch (e) {
                      // If there's an error creating the NetworkImage, use default
                      profilePic = CircleAvatar(
                        radius: 50,
                        backgroundColor: greyColor.withOpacity(0.3),
                        child: const Icon(Icons.person, size: 50, color: whiteColor),
                      );
                    }
                  } else {
                    profilePic = CircleAvatar(
                      radius: 50,
                      backgroundColor: greyColor.withOpacity(0.3),
                      child: const Icon(Icons.person, size: 50, color: whiteColor),
                    );
                  }
                }

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            profilePic,
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    fullName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 18),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    subtitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: darkGreenColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Show loading/error state for specialities if needed
                    if (_specialityError != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          getLocalizedError(_specialityError, context) ?? '',
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildMenuItem(
                              icon: Icons.calendar_today_outlined,
                              title: "Booked appointments"),
                          _buildMenuItem(
                              icon: Icons.person_outline, title: "My patients"),
                          _buildMenuItem(
                              icon: Icons.av_timer_outlined, title: "Availability"),
                          _buildMenuItem(
                              icon: Icons.notifications_outlined,
                              title: "Notification settings"),
                          _buildMenuItem(
                              icon: Icons.policy_outlined, title: "Policies"),
                          _buildMenuItem(
                              icon: Icons.email_outlined, title: "Change email"),
                          _buildMenuItem(
                              icon: Icons.security_outlined, title: "Security settings"),
                          _buildMenuItem(
                              icon: Icons.badge_outlined, title: "About me"),
                          _buildMenuItem(
                              icon: Icons.logout_outlined,
                              title: "Logout",
                              showTrailing: false),

                          const SizedBox(height: 20),
                          const DoctorFooter(currentIndex: 3),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon, required String title, bool showTrailing = true}) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: Icon(icon, color: darkGreenColor, size: 28),
            title: Text(
              title,
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
            ),
            trailing: showTrailing
                ? const Icon(
                    Icons.arrow_forward_ios,
                    color: darkGreenColor,
                    size: 18,
                  )
                : null,
            onTap: () {
              // Handle menu actions
              if (title == "Logout") {
                _showLogoutConfirmationDialog(context);
              } else {
                // Navigate to other screens
              }
            },
          ),
        ),
        const Divider(
          height: 1,
          color: lightGreyColor,
          thickness: 0.5,
        ),
      ],
    );
  }
}