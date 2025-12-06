import 'package:afia_plus_app/views/screens/sign_up/create_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';
import '../../../../logic/cubits/auth/auth_cubit.dart';
import '../../../../logic/cubits/signup/signup_cubit.dart';

class UserProfileScreen extends StatefulWidget {
  static const routename = "/UserViewUserProfile";
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
              builder: (context, authState) {
                String fullName = "User";
                String subtitle = "";
                Widget profilePic = CircleAvatar(
                  radius: 50,
                  backgroundColor: greyColor.withOpacity(0.3),
                  child: const Icon(Icons.person, size: 50, color: whiteColor),
                );

                if (authState is AuthenticatedPatient) {
                  final patient = authState.patient;
                  fullName = "${patient.firstname} ${patient.lastname}";
                  subtitle = patient.dateOfBirth.isNotEmpty
                      ? patient.dateOfBirth
                      : "DOB not set";

                  if (patient.profilePicture != null &&
                      patient.profilePicture!.isNotEmpty) {
                    profilePic = CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(patient.profilePicture!),
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
                          _buildMenuItem(icon: Icons.favorite_outline, title: "Favorite doctors"),
                          _buildMenuItem(icon: Icons.calendar_today_outlined, title: "Booked appointments"),
                          _buildMenuItem(icon: Icons.notifications_outlined, title: "Notification settings"),
                          _buildMenuItem(icon: Icons.policy_outlined, title: "Policies"),
                          _buildMenuItem(icon: Icons.email_outlined, title: "Change email"),
                          _buildMenuItem(icon: Icons.security_outlined, title: "Security settings"),
                          _buildMenuItem(icon: Icons.badge_outlined, title: "About me"),
                          _buildMenuItem(icon: Icons.logout_outlined, title: "Logout", showTrailing: false),
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
              if (title == "Logout") {
                context.read<AuthCubit>().logout();
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