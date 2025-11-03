import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

class DoctorAboutTab extends StatelessWidget {
  const DoctorAboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        AboutItem(
          icon: Icons.info,
          title: "General Information",
          description:
              "Dr. Yousfi is an experienced gynecologist. He specializes in women's reproductive health, hormonal disorders, pregnancy care (prenatal and postnatal), and screening for cancers with a patient-focused approach. He delivers personalized, high-quality care.",
        ),
        AboutItem(
          icon: Icons.location_on,
          title: "Current Working Place",
          description: "141 Cite Daksi Abdesselem Constantine",
        ),
        AboutItem(
          icon: Icons.school,
          title: "Education",
          description: "Doctor of Medicine (MD), AIX Marseille University",
        ),
        AboutItem(
          icon: Icons.card_membership,
          title: "Certification",
          description:
              "Board Certification in Obstetrics and Gynecology by Marseille University",
        ),
        AboutItem(
          icon: Icons.medical_services,
          title: "Training",
          description: "Completed residency and advanced gynecology fellowship",
        ),
        AboutItem(
          icon: Icons.verified,
          title: "Licensure",
          description:
              "Fully licensed to practice medicine and gynecology, adhering to the latest professional standards",
        ),
        AboutItem(
          icon: Icons.history,
          title: "Experience",
          description:
              "Over 30 years of clinical practice, specializing in women's reproductive health from complex gynecologic conditions to fertility care and high-risk pregnancies",
        ),
      ],
    );
  }
}

class AboutItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AboutItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: darkGreenColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: greyColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
