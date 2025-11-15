import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/screens/homescreen/doctor_home_screen.dart';
import 'package:afia_plus_app/views/screens/doctorPages/manage_appointments.dart';
import 'package:afia_plus_app/views/screens/doctorPages/doctor_availability.dart';
import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_doctor_view.dart';
// Import other pages when ready:
// import 'package:afia_plus_app/views/screens/notifications/notifications_screen.dart';
// import 'package:afia_plus_app/views/screens/profile/profile_screen.dart';

class DoctorFooter extends StatelessWidget {
  final int currentIndex;

  const DoctorFooter({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget nextPage;

    switch (index) {
      case 0:
        nextPage = const DoctorHomeScreen();
        break;
      case 1:
        nextPage = const SchedulePage();
        break;
      case 2:
        nextPage = const ScheduleAvailabilityPage();
        break;
      case 3:
        nextPage = const DoctorViewDoctorProfileScreen();
        break;
      default:
        nextPage = const DoctorHomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: BottomAppBar(
        color: whiteColor,
        elevation: 6,
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(
                icon: Icons.home_outlined,
                index: 0,
                currentIndex: currentIndex,
                context: context,
              ),
              _buildNavIcon(
                icon: Icons.folder,
                index: 1,
                currentIndex: currentIndex,
                context: context,
              ),
              _buildNavIcon(
                icon: Icons.access_time,
                index: 2,
                currentIndex: currentIndex,
                context: context,
              ),
              _buildNavIcon(
                icon: Icons.person_outline,
                index: 3,
                currentIndex: currentIndex,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon({
    required IconData icon,
    required int index,
    required int currentIndex,
    required BuildContext context,
  }) {
    final bool isSelected = index == currentIndex;

    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? darkGreenColor : greyColor,
        size: isSelected ? 30 : 26,
      ),
      onPressed: () => _onItemTapped(context, index),
    );
  }
}
