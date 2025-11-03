import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/search_text_fields.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';
import 'package:afia_plus_app/views/widgets/doctor_card.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  final String name = "Mohamed";

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  Widget sectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(child: Container()),
        Text(
          'See all',
          style: greenLink,
        ),
      ],
    );
  }

  Widget _buildConsultationCard({
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
      trailing: ElevatedButton(
        onPressed: () {
          // open WhatsApp or navigate to chat
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreenColor,
          minimumSize: const Size(140, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'WhatsApp',
          style: TextStyle(color: whiteColor, fontSize: 14),
        ),
      ),
    ),
  );
}

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
        trailing: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: whiteColor,
                ),
                label: const Text(
                  'Accept',
                  style: TextStyle(color: whiteColor, fontSize: 12),
                ),
                style: greenButtonStyle.copyWith(
                  minimumSize: WidgetStateProperty.all(const Size(140, 30)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: darkGreenColor,
                ),
                label: const Text(
                  'Reject',
                  style: TextStyle(color: darkGreenColor, fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: darkGreenColor),
                  minimumSize: const Size(140, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget specialityLink(String name, String number) {
    return ElevatedButton(
      onPressed: () {},
      style: whiteButtonStyle,
      child: Row(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Expanded(child: Container()),
          Text(
            number,
            style: TextStyle(color: greyColor),
          )
        ],
      ),
    );
  }

  Widget seviceLink(String name) {
    return ElevatedButton(
      onPressed: () {},
      style: whiteButtonStyle,
      child: Row(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Expanded(child: Container()),
          Icon(Icons.arrow_outward_rounded),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.arrow_back_ios_new,
            color: greyColor,
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick overview',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        specialityLink('Today', '2 appointments'),
                        const SizedBox(height: 10),
                        specialityLink('Pending Requests', '1 request'),
                        const SizedBox(height: 10),
                        specialityLink('Total patients', '48 patients'),
                        const SizedBox(height: 20),
                        sectionTitle('Coming consultations'),
                        const SizedBox(height: 20),
                        _buildConsultationCard(
                          name: 'Sakri Yasser',
                          time: '10:00 - 10:30',
                          date: '22 Oct 2025',
                        ),
                        const SizedBox(height: 20),
                        sectionTitle('Pending consultations'),
                        const SizedBox(height: 20),
                        _buildAppointmentCard(
                          name: 'Sakri Yasser',
                          time: '10:00 - 10:30',
                          date: '22 Oct 2025',
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Services',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        seviceLink('Appointments'),
                        const SizedBox(height: 10),
                        seviceLink('Availability'),
                        const SizedBox(height: 10),
                        seviceLink('FAQ'),
                        const SizedBox(height: 20),
                        UserFooter(currentIndex: 0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}
