import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/data/models/doctor.dart';
import 'package:afia_plus_app/data/models/speciality.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';

class DoctorAboutTab extends StatelessWidget {
  final Doctor doctor;
  final Speciality? speciality;

  const DoctorAboutTab({Key? key, required this.doctor, this.speciality}) : super(key: key);

  String _formatEducation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parts = <String>[];
    if (doctor.degree != null && doctor.degree!.isNotEmpty) {
      parts.add(doctor.degree!);
    }
    if (doctor.university != null && doctor.university!.isNotEmpty) {
      parts.add(doctor.university!);
    }
    return parts.isEmpty ? l10n.notSpecified : parts.join(", ");
  }

  String _formatCertification(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parts = <String>[];
    if (doctor.certification != null && doctor.certification!.isNotEmpty) {
      parts.add(doctor.certification!);
    }
    if (doctor.institution != null && doctor.institution!.isNotEmpty) {
      parts.add(doctor.institution!);
    }
    return parts.isEmpty ? l10n.notSpecified : parts.join(", ");
  }

  String _formatLicensure(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parts = <String>[];
    if (doctor.licenseDescription != null && doctor.licenseDescription!.isNotEmpty) {
      parts.add(doctor.licenseDescription!);
    }
    if (doctor.licenseNumber != null && doctor.licenseNumber!.isNotEmpty) {
      parts.add("${l10n.licenseNumber} ${doctor.licenseNumber!}");
    }
    return parts.isEmpty ? l10n.notSpecified : parts.join(". ");
  }

  String _formatExperience(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parts = <String>[];
    if (doctor.yearsExperience != null) {
      final yearText = doctor.yearsExperience == 1 ? l10n.year : l10n.years;
      parts.add("${l10n.over} ${doctor.yearsExperience} $yearText ${l10n.ofExperience}");
    }
    if (doctor.areasOfExpertise != null && doctor.areasOfExpertise!.isNotEmpty) {
      parts.add("${l10n.specializingIn} ${doctor.areasOfExpertise!}");
    }
    return parts.isEmpty ? l10n.notSpecified : parts.join(", ");
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = <Widget>[];

    // General Information (required)
    if (doctor.bio != null && doctor.bio!.isNotEmpty) {
      items.add(AboutItem(
        icon: Icons.info,
        title: l10n.generalInformation,
        description: doctor.bio!,
      ));
    }

    // Current Working Place (required)
    if (doctor.locationOfWork != null && doctor.locationOfWork!.isNotEmpty) {
      items.add(AboutItem(
        icon: Icons.location_on,
        title: l10n.currentWorkingPlace,
        description: doctor.locationOfWork!,
      ));
    }

    // Education (required fields)
    items.add(AboutItem(
      icon: Icons.school,
      title: l10n.education,
      description: _formatEducation(context),
    ));

    // Certification (optional)
    items.add(AboutItem(
      icon: Icons.card_membership,
      title: l10n.certification,
      description: _formatCertification(context),
    ));

    // Training (optional)
    if (doctor.residency != null && doctor.residency!.isNotEmpty) {
      items.add(AboutItem(
        icon: Icons.medical_services,
        title: l10n.training,
        description: doctor.residency!,
      ));
    }

    // Licensure (license number is required, but description is optional)
    items.add(AboutItem(
      icon: Icons.verified,
      title: l10n.licensure,
      description: _formatLicensure(context),
    ));

    // Experience (required fields)
    items.add(AboutItem(
      icon: Icons.history,
      title: l10n.experience,
      description: _formatExperience(context),
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
