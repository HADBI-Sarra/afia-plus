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
          _specialityError = 'Failed to load specialities';
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
                  if (doctor.profilePicture != null && doctor.profilePicture!.isNotEmpty) {
                    profilePic = CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(doctor.profilePicture!),
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
                          _specialityError!,
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
                context.read<AuthCubit>().logout();
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