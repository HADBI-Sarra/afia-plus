import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_doctor.dart';

class DoctorViewDoctorProfileScreen extends StatefulWidget {
  static const routename = "/doctorViewDoctorrProfile";
  const DoctorViewDoctorProfileScreen({super.key});

  @override
  State<DoctorViewDoctorProfileScreen> createState() => _DoctorViewDoctorProfileScreenState();
}

class _DoctorViewDoctorProfileScreenState extends State<DoctorViewDoctorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackgroundDecoration, // gradient background
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
          child: Column(
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
                      
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/ouadi.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Name and subtitle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Dr.Ouadi Mehdi",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Dentist",
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

              // Menu items
              Expanded(
                child: ListView(
                  children: [
                    _buildMenuItem(icon: Icons.calendar_today_outlined, title: "Booked appointments"),
                    _buildMenuItem(icon: Icons.notifications_outlined, title: "Notification settings"),
                    _buildMenuItem(icon: Icons.policy_outlined, title: "Policies"),
                    _buildMenuItem(icon: Icons.email_outlined, title: "Change email"),
                    _buildMenuItem(icon: Icons.security_outlined, title: "Security settings"),
                    _buildMenuItem(icon: Icons.badge_outlined, title: "About me"),
                    _buildMenuItem(icon: Icons.logout_outlined, title: "Logout", showTrailing: false),

                    // Footer placeholder
                    const SizedBox(height: 20),
                    const DoctorFooter(currentIndex: 3)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, bool showTrailing = true}) {
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
            onTap: () {},
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