import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/search_text_fields.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';
import 'package:afia_plus_app/views/widgets/doctor_card.dart';
import 'package:afia_plus_app/cubits/patient_home_cubit.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/utils/whatsapp_service.dart';
import 'package:afia_plus_app/views/widgets/language_switcher.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  final String name = "Besmala";
  // TODO: Replace with actual patient ID from authentication/session
  static const int patientId = 1;

  Widget sectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Text(
          'See all',
          style: greenLink,
        ),
      ],
    );
  }

  Widget _buildDoctorCardFromConsultation(BuildContext context, {
    required ConsultationWithDetails consultation,
  }) {
    // Default image path - you can enhance this with actual doctor image from DB
    String imagePath = 'assets/images/doctorBrahimi.png';
    if (consultation.doctorImagePath != null) {
      imagePath = consultation.doctorImagePath!;
    }

    return _buildDoctorCard(
      context: context,
      consultation: consultation,
      name: 'Dr. ${consultation.doctorFullName}',
      specialty: consultation.doctorSpecialty ?? AppLocalizations.of(context)!.specialist,
      date: consultation.formattedDate,
      imagePath: imagePath,
      phoneNumber: consultation.doctorPhoneNumber,
    );
  }

  Widget _buildDoctorCard({
    required BuildContext context,
    required ConsultationWithDetails consultation,
    required String name,
    required String specialty,
    required String date,
    required String imagePath,
    String? phoneNumber,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: const TextStyle(color: greyColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              BlocBuilder<PatientHomeCubit, PatientHomeState>(
                builder: (context, state) {
                  final isDeleting =
                      consultation.consultation.consultationId != null &&
                      state.deletingConsultationIds.contains(
                        consultation.consultation.consultationId,
                      );

                  return isDeleting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              darkGreenColor,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: greyColor,
                            size: 24,
                          ),
                          onPressed: () {
                            if (consultation.consultation.consultationId != null) {
                              _showDeleteConfirmationDialog(
                                context: context,
                                consultation: consultation,
                              );
                            }
                          },
                        );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: darkGreenColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  if (phoneNumber != null && phoneNumber.isNotEmpty) {
                    final success = await WhatsAppService.openWhatsApp(
                      phoneNumber: phoneNumber,
                      message: AppLocalizations.of(context)!.whatsappMessageDoctor(
                        consultation.doctorFullName,
                        date,
                      ),
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.whatsappError),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.doctorPhoneNumberNotAvailable),
                          backgroundColor: Colors.orange,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: const Size(100, 36),
                ),
                child: Text(
                  AppLocalizations.of(context)!.whatsapp,
                  style: const TextStyle(color: whiteColor, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget specialityLink(BuildContext context, String name, int number) {
    return ElevatedButton(
      onPressed: () {},
      style: whiteButtonStyle,
      child: Row(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Spacer(),
          Text(
            "$number doctors",
            style: TextStyle(color: greyColor),
          )
        ],
      ),
    );
  }

  Widget seviceLink(BuildContext context, String name) {
    return ElevatedButton(
      onPressed: () {},
      style: whiteButtonStyle,
      child: Row(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Spacer(),
          const Icon(Icons.arrow_outward_rounded),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientHomeCubit()..loadUpcomingConsultations(PatientHomeScreen.patientId),
      child: Container(
        decoration: gradientBackgroundDecoration,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Icon(
              Icons.arrow_back_ios_new,
              color: greyColor,
            ),
            actions: const [
              LanguageSwitcher(),
              SizedBox(width: 8),
            ],
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
                          'Hello $name!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        SearchTextField(hint: 'Start typing'),
                        const SizedBox(height: 20),
                        sectionTitle(context, 'Coming consultations'),
                        const SizedBox(height: 20),
                        BlocBuilder<PatientHomeCubit, PatientHomeState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (state.error != null) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Error loading consultations',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            if (state.upcomingConsultations.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'No upcoming consultations',
                                  style: TextStyle(color: greyColor),
                                ),
                              );
                            }

                            return Column(
                              children: state.upcomingConsultations
                                  .map((consultation) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: _buildDoctorCardFromConsultation(
                                          context,
                                          consultation: consultation,
                                        ),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        sectionTitle(context, 'Popular specializations'),
                        const SizedBox(height: 20),
                        specialityLink(context, 'Dentist', 21),
                        const SizedBox(height: 10),
                        specialityLink(context, 'Pulmonologist', 19),
                        const SizedBox(height: 10),
                        specialityLink(context, 'Gastroenterologist', 8),
                        const SizedBox(height: 10),
                        specialityLink(context, 'Cardiologist', 15),
                        const SizedBox(height: 20),
                        sectionTitle(context, 'Popular doctors'),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DoctorCard(
                                    imagePath: 'assets/images/yousfi.jpg',
                                    name: 'Dr. Yousfi Slimane',
                                    specialty: 'Gynecologyst',
                                    rating: 5.0,
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DoctorCard(
                                    imagePath: 'assets/images/battahar-riad.jpg',
                                    name: 'Dr. Foudad Riad',
                                    specialty: 'Urologist',
                                    rating: 4.9,
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: DoctorCard(
                                    imagePath: 'assets/images/Maryam-El-Mokhtari.jpg',
                                    name: 'Dr. Maryam Akli',
                                    specialty: 'Dermatologist',
                                    rating: 4.9,
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DoctorCard(
                                    imagePath: 'assets/images/dentist.jpg',
                                    name: 'Dr. Kaouache Antr',
                                    specialty: 'Dentist',
                                    rating: 4.9,
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Services',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        seviceLink(context, 'Appointments'),
                        const SizedBox(height: 10),
                        seviceLink(context, 'Prescriptions'),
                        const SizedBox(height: 10),
                        seviceLink(context, 'FAQ'),
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
      ),
    );
  }

  void _showDeleteConfirmationDialog({
    required BuildContext context,
    required ConsultationWithDetails consultation,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.cancelAppointment,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.areYouSureCancelAppointment,
                style: const TextStyle(
                  fontSize: 16,
                  color: blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 18,
                          color: darkGreenColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dr. ${consultation.doctorFullName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: darkGreenColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          consultation.formattedDate,
                          style: const TextStyle(
                            fontSize: 14,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                    if (consultation.doctorSpecialty != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.medical_services,
                            size: 18,
                            color: darkGreenColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            consultation.doctorSpecialty!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.thisActionCannotBeUndone,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(context)!.keepAppointment,
                style: const TextStyle(
                  color: greyColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (consultation.consultation.consultationId != null) {
                  context.read<PatientHomeCubit>().deleteAppointment(
                    consultation.consultation.consultationId!,
                    PatientHomeScreen.patientId,
                  );
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.appointmentCancelled),
                      backgroundColor: darkGreenColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.cancelAppointment,
                style: const TextStyle(
                  color: whiteColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
