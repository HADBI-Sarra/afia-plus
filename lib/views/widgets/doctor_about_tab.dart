import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/data/models/doctor.dart';
import 'package:afia_plus_app/data/models/speciality.dart';

class DoctorAboutTab extends StatelessWidget {
  final Doctor doctor;
  final Speciality? speciality;

  const DoctorAboutTab({Key? key, required this.doctor, this.speciality}) : super(key: key);

  String _formatEducation() {
    final parts = <String>[];
    if (doctor.degree != null && doctor.degree!.isNotEmpty) {
      parts.add(doctor.degree!);
    }
    if (doctor.university != null && doctor.university!.isNotEmpty) {
      parts.add(doctor.university!);
    }
    return parts.isEmpty ? "Not specified" : parts.join(", ");
  }

  String _formatCertification() {
    final parts = <String>[];
    if (doctor.certification != null && doctor.certification!.isNotEmpty) {
      parts.add(doctor.certification!);
    }
    if (doctor.institution != null && doctor.institution!.isNotEmpty) {
      parts.add(doctor.institution!);
    }
    return parts.isEmpty ? "Not specified" : parts.join(", ");
  }

  String _formatLicensure() {
    final parts = <String>[];
    if (doctor.licenseDescription != null && doctor.licenseDescription!.isNotEmpty) {
      parts.add(doctor.licenseDescription!);
    }
    if (doctor.licenseNumber != null && doctor.licenseNumber!.isNotEmpty) {
      parts.add("License number: ${doctor.licenseNumber!}");
    }
    return parts.isEmpty ? "Not specified" : parts.join(". ");
  }

  String _formatExperience() {
    final parts = <String>[];
    if (doctor.yearsExperience != null) {
      parts.add("Over ${doctor.yearsExperience} year${doctor.yearsExperience == 1 ? '' : 's'} of experience");
    }
    if (doctor.areasOfExpertise != null && doctor.areasOfExpertise!.isNotEmpty) {
      parts.add("specializing in ${doctor.areasOfExpertise!}");
    }
    return parts.isEmpty ? "Not specified" : parts.join(", ");
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    // General Information (required)
    if (doctor.bio != null && doctor.bio!.isNotEmpty) {
      items.add(AboutItem(
        icon: Icons.info,
        title: "General Information",
        description: doctor.bio!,
      ));
    }

    // Current Working Place (required)
    if (doctor.locationOfWork != null && doctor.locationOfWork!.isNotEmpty) {
      items.add(AboutItem(
        icon: Icons.location_on,
        title: "Current Working Place",
        description: doctor.locationOfWork!,
      ));
    }

    // Education (required fields)
    items.add(AboutItem(
      icon: Icons.school,
      title: "Education",
      description: _formatEducation(),
    ));

    // Certification (optional)
    items.add(AboutItem(
      icon: Icons.card_membership,
      title: "Certification",
      description: _formatCertification(),
    ));

    // Training (optional)
    if (doctor.residency != null && doctor.residency!.isNotEmpty) {
      items.add(AboutItem(
        icon: Icons.medical_services,
        title: "Training",
        description: doctor.residency!,
      ));
    }

    // Licensure (license number is required, but description is optional)
    items.add(AboutItem(
      icon: Icons.verified,
      title: "Licensure",
      description: _formatLicensure(),
    ));

    // Experience (required fields)
    items.add(AboutItem(
      icon: Icons.history,
      title: "Experience",
      description: _formatExperience(),
    ));

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items,
    );
  }
}

class AboutItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AboutItem({Key? key, required this.icon, required this.title, required this.description}) : super(key: key);

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
                Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
