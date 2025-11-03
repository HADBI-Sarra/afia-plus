import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/screens/homescreen/home_screen.dart';
import 'package:afia_plus_app/views/screens/userPages/user_appointments';
import 'package:afia_plus_app/views/screens/userPages/prescription.dart';

class UserFooter extends StatelessWidget {
  final int currentIndex;

  const UserFooter({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return; 

    Widget nextPage;

    switch (index) {
      case 0:
        nextPage = const HomeScreen();
        break;
      case 1:
        nextPage = const UpcomingAppointmentsPage();
        break;
      case 2:
        nextPage = const PrescriptionPage();
      //   break;
      // case 3:
      //   nextPage = const ProfileScreen();
      //   break;
      default:
        nextPage = const HomeScreen();
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
        elevation: 10,
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
                icon: Icons.description,
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
