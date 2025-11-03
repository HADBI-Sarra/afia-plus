import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_doctor.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: gradientBackgroundDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: darkGreenColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Manage Appointments',
                          style: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 16),

                // 🩺 Doctor info card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: whiteColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: greyColor.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/doctor.png'),
                    ),
                    title: Text(
                      'Dr. Mohamed Brahimi',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    subtitle: Text(
                      'General Practitioner',
                      style: TextStyle(color: greyColor),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Upcoming Appointments
                const Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkGreenColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildAppointmentCard(
                  name: 'Sakri Yasser',
                  time: '10:00 AM - 10:30 AM',
                  date: '22 Oct 2025',
                ),
                _buildAppointmentCard(
                  name: 'Erriri Zahra',
                  time: '11:00 AM - 11:30 AM',
                  date: '22 Oct 2025',
                ),

                const SizedBox(height: 24),

                // Past Appointments
                const Text(
                  'Past Appointments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkGreenColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildPastAppointmentCard(
                  name: 'Merabet Lila',
                  time: '10:00 AM - 10:30 AM',
                  date: '17 Oct 2025',
                ),
                _buildPastAppointmentCard(
                  name: 'Hadj Allah Taline',
                  time: '10:00 AM - 10:30 AM',
                  date: '15 Oct 2025',
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const DoctorFooter(currentIndex: 1),
    );
  }

  // 🟢 Upcoming Appointment Card
  Widget _buildAppointmentCard({
    required String name,
    required String time,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: darkGreenColor,
          child: Icon(Icons.person, color: whiteColor),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
        subtitle: Text(
          '$time\n$date',
          style: const TextStyle(color: greyColor),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.check_circle_outline,
                size: 16,
                color: whiteColor,
              ),
              label: const Text(
                'Accept',
                style: TextStyle(color: whiteColor, fontSize: 12),
              ),
              style: loginButtonStyle.copyWith(
                minimumSize: WidgetStateProperty.all(const Size(90, 30)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.delete_outline,
                size: 16,
                color: darkGreenColor,
              ),
              label: const Text(
                'Reject',
                style: TextStyle(color: darkGreenColor, fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: darkGreenColor),
                minimumSize: const Size(90, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📄 Past Appointment Card
  Widget _buildPastAppointmentCard({
    required String name,
    required String time,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: blueGreenColor,
          child: Icon(Icons.person, color: whiteColor),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
        subtitle: Text(
          '$time\n$date',
          style: const TextStyle(color: greyColor),
        ),
        trailing: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.upload_file, size: 16, color: whiteColor),
          label: const Text(
            'Upload PDF',
            style: TextStyle(fontSize: 12, color: whiteColor),
          ),
          style: loginButtonStyle.copyWith(
            backgroundColor: WidgetStateProperty.all(blueGreenColor),
            minimumSize: WidgetStateProperty.all(const Size(100, 36)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }
}
