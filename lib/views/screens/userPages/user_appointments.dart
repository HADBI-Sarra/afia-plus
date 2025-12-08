import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';
import 'package:afia_plus_app/cubits/user_appointments_cubit.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/utils/whatsapp_service.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';

class UpcomingAppointmentsPage extends StatelessWidget {
  const UpcomingAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authState is! AuthenticatedPatient) {
          return const Scaffold(
            body: Center(child: Text('Please log in as a patient to view appointments.')),
          );
        }

        final patientId = authState.patient.userId!;

        return BlocProvider(
          create: (context) => UserAppointmentsCubit()..loadAppointments(patientId),
          child: _UpcomingAppointmentsPageView(patientId: patientId),
        );
      },
    );
  }
}

class _UpcomingAppointmentsPageView extends StatelessWidget {
  final int patientId;
  const _UpcomingAppointmentsPageView({required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: gradientBackgroundDecoration,
        child: SafeArea(
          child: BlocBuilder<UserAppointmentsCubit, UserAppointmentsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.error}: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<UserAppointmentsCubit>().refreshAppointments(patientId);
                        },
                        child: Text(AppLocalizations.of(context)!.retry),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
                        Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.myAppointments,
                              style: const TextStyle(
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
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<UserAppointmentsCubit>().refreshAppointments(patientId);
                          await Future.delayed(const Duration(milliseconds: 500));
                        },
                        color: darkGreenColor,
                        child: ListView(
                          children: [
                            // Confirmed Appointments Section
                            if (state.confirmedAppointments.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  AppLocalizations.of(context)!.confirmedAppointments,
                                  style: const TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ...state.confirmedAppointments.map(
                                (consultation) => _buildDoctorCard(
                                  consultation: consultation,
                                  context: context,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Not Confirmed Appointments Section
                            if (state.notConfirmedAppointments.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  AppLocalizations.of(context)!.notConfirmedAppointments,
                                  style: const TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ...state.notConfirmedAppointments.map(
                                (consultation) => _buildDoctorCard(
                                  consultation: consultation,
                                  context: context,
                                ),
                              ),
                            ],

                            if (state.confirmedAppointments.isEmpty &&
                                state.notConfirmedAppointments.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.noAppointmentsFound,
                                    style: const TextStyle(
                                      color: greyColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const UserFooter(currentIndex: 1),
    );
  }

  Widget _buildDoctorCard({
    required ConsultationWithDetails consultation,
    required BuildContext context,
  }) {
    // Default image path - you can enhance this with actual doctor image from DB
    String imagePath = 'assets/images/doctorBrahimi.png';
    if (consultation.doctorImagePath != null) {
      imagePath = consultation.doctorImagePath!;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
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
                      'Dr. ${consultation.doctorFullName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      consultation.doctorSpecialty ?? AppLocalizations.of(context)!.specialist,
                      style: const TextStyle(color: greyColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              BlocBuilder<UserAppointmentsCubit, UserAppointmentsState>(
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
                            if (consultation.consultation.consultationId !=
                                null) {
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
                  consultation.formattedDate,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final phoneNumber = consultation.doctorPhoneNumber;
                  if (phoneNumber != null && phoneNumber.isNotEmpty) {
                    final success = await WhatsAppService.openWhatsApp(
                      phoneNumber: phoneNumber,
                      message: AppLocalizations.of(context)!.whatsappMessageDoctor(
                        consultation.doctorFullName,
                        consultation.formattedDate,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                  context.read<UserAppointmentsCubit>().deleteAppointment(
                    consultation.consultation.consultationId!,
                    patientId,
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
