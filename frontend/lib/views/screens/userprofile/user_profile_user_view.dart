import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';
import '../../../../logic/cubits/auth/auth_cubit.dart';
import '../../../../logic/cubits/signup/signup_cubit.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';

class UserProfileScreen extends StatefulWidget {
  static const routename = "/UserViewUserProfile";
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _imageError = false;
  String? _lastProfilePictureUrl;

  // Show logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            l10n.logout,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: darkGreenColor,
            ),
          ),
          content: Text(
            l10n.logoutConfirmation,
            style: const TextStyle(
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
              child: Text(
                l10n.cancel,
                style: const TextStyle(
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
              child: Text(
                l10n.logout,
                style: const TextStyle(
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
            AppLocalizations.of(context)!.profile,
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
              builder: (context, authState) {
                String fullName = "User";
                String subtitle = "";
                Widget profilePic = CircleAvatar(
                  radius: 50,
                  backgroundColor: greyColor.withOpacity(0.3),
                  child: const Icon(Icons.person, size: 50, color: whiteColor),
                );

                if (authState is AuthenticatedPatient) {
                  final l10n = AppLocalizations.of(context)!;
                  final patient = authState.patient;
                  fullName = "${patient.firstname} ${patient.lastname}";
                  subtitle = patient.dateOfBirth.isNotEmpty
                      ? patient.dateOfBirth
                      : l10n.dobNotSet;

                  // Display profile picture if available
                  final profilePictureUrl = patient.profilePicture;
                  
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
                            Column(
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
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: darkGreenColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildMenuItem(icon: Icons.favorite_outline, title: AppLocalizations.of(context)!.favoriteDoctors),
                          _buildMenuItem(icon: Icons.calendar_today_outlined, title: AppLocalizations.of(context)!.bookedAppointments),
                          _buildMenuItem(icon: Icons.notifications_outlined, title: AppLocalizations.of(context)!.notificationSettings),
                          _buildMenuItem(icon: Icons.policy_outlined, title: AppLocalizations.of(context)!.policies),
                          _buildMenuItem(icon: Icons.email_outlined, title: AppLocalizations.of(context)!.changeEmail),
                          _buildMenuItem(icon: Icons.security_outlined, title: AppLocalizations.of(context)!.securitySettings),
                          _buildMenuItem(icon: Icons.badge_outlined, title: AppLocalizations.of(context)!.aboutMe),
                          _buildMenuItem(icon: Icons.logout_outlined, title: AppLocalizations.of(context)!.logout, showTrailing: false),
                          const SizedBox(height: 20),
                          const UserFooter(currentIndex: 3),
                          const SizedBox(height: 10),
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool showTrailing = true,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: Icon(icon, color: darkGreenColor, size: 28),
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
            ),
            trailing: showTrailing
                ? const Icon(
                    Icons.arrow_forward_ios,
                    color: darkGreenColor,
                    size: 18,
                  )
                : null,
            onTap: () {
              final l10n = AppLocalizations.of(context)!;
              if (title == l10n.logout) {
                _showLogoutConfirmationDialog(context);
              } else {
                // Other menu actions
              }
            },
          ),
        ),
        const Divider(
          height: 1,
          color: lightGreyColor,
          thickness: 0.5,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}