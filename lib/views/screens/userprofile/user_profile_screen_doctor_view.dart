import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';

class DoctorViewUserProfileScreen extends StatefulWidget {
  static const routename = "/doctorViewUserProfile";
  const DoctorViewUserProfileScreen({super.key});

  @override
  State<DoctorViewUserProfileScreen> createState() =>
      _DoctorViewUserProfileScreenState();
}

class _DoctorViewUserProfileScreenState
    extends State<DoctorViewUserProfileScreen> {
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
          centerTitle: true,
          title: const Text(
            "Patient Profile",
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: blackColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Boukenouche Besmala",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "20 y.o. (11 Oct 2005)",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: greyColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/besmala.jpg',
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          title: "Email",
                          value: "besmala@gmail.com",
                        ),
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          title: "Phone",
                          value: "+213 123 456 789",
                        ),
                        _buildInfoRow(
                          icon: Icons.location_on_outlined,
                          title: "Address",
                          value: "Jijel, Algeria",
                        ),
                        _buildInfoRow(
                          icon: Icons.health_and_safety_outlined,
                          title: "Health Info",
                          value: "Blood Type: O+ | Allergies: None | Chronic Conditions: None",
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Send Message",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      {required IconData icon, required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: darkGreenColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
