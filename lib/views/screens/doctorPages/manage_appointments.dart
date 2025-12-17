import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_doctor.dart';
import 'package:afia_plus_app/cubits/doctor_appointments_cubit.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/utils/whatsapp_service.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (authState is! AuthenticatedDoctor) {
          return const Scaffold(
            body: Center(
              child: Text('Please log in as a doctor to view appointments.'),
            ),
          );
        }

        final doctorId = authState.doctor.userId!;

        return BlocProvider(
          create: (context) =>
              DoctorAppointmentsCubit()..loadAppointments(doctorId),
          child: _SchedulePageView(doctorId: doctorId),
        );
      },
    );
  }
}

class _SchedulePageView extends StatelessWidget {
  final int doctorId;
  const _SchedulePageView({required this.doctorId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: gradientBackgroundDecoration,
        child: SafeArea(
          child: BlocBuilder<DoctorAppointmentsCubit, DoctorAppointmentsState>(
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
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<DoctorAppointmentsCubit>()
                              .refreshAppointments(doctorId);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DoctorAppointmentsCubit>().refreshAppointments(
                    doctorId,
                  );
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                color: darkGreenColor,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    10,
                    16,
                    kBottomNavigationBarHeight + 16,
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
                                AppLocalizations.of(
                                  context,
                                )!.upcomingAppointments,
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
                      const SizedBox(height: 24),
                      if (state.upcomingAppointments.isNotEmpty) ...[
                        Text(
                          AppLocalizations.of(context)!.upcomingAppointments,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkGreenColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...state.upcomingAppointments.map(
                          (consultation) => _buildAppointmentCard(
                            consultation: consultation,
                            context: context,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (state.pastAppointments.isNotEmpty) ...[
                        Text(
                          AppLocalizations.of(context)!.pastAppointments,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkGreenColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...state.pastAppointments.map(
                          (consultation) => _buildPastAppointmentCard(
                            consultation: consultation,
                            context: context,
                          ),
                        ),
                      ],
                      if (state.upcomingAppointments.isEmpty &&
                          state.pastAppointments.isEmpty)
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
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const DoctorFooter(currentIndex: 1),
    );
  }

  Widget _buildAppointmentCard({
    required ConsultationWithDetails consultation,
    required BuildContext context,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: darkGreenColor,
            radius: 24,
            child: Icon(Icons.person, color: whiteColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  consultation.patientFullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  consultation.consultation.startTime,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
                Text(
                  consultation.consultation.consultationDate,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<DoctorAppointmentsCubit, DoctorAppointmentsState>(
            builder: (context, state) {
              final isProcessing =
                  consultation.consultation.consultationId != null &&
                  state.processingConsultationIds.contains(
                    consultation.consultation.consultationId,
                  );
              final phoneNumber = consultation.patientPhoneNumber;
              final isPending = consultation.consultation.status == 'pending';
              final isAccepted = consultation.consultation.status == 'scheduled';

              if (isAccepted && phoneNumber != null && phoneNumber.isNotEmpty) {
                return ElevatedButton(
                  onPressed: () async {
                    final success = await WhatsAppService.openWhatsApp(
                      phoneNumber: phoneNumber,
                      message:
                          'Hello ${consultation.patientFullName}, this is your doctor.',
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.whatsappError,
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreenColor,
                    minimumSize: const Size(120, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'WhatsApp',
                    style: TextStyle(color: whiteColor, fontSize: 12),
                  ),
                );
              }

              if (isPending) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isProcessing
                          ? null
                          : () {
                              if (consultation.consultation.consultationId !=
                                  null) {
                                _showAcceptConfirmationDialog(
                                  context: context,
                                  consultation: consultation,
                                );
                              }
                            },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: whiteColor,
                      ),
                      label: isProcessing
                          ? const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  whiteColor,
                                ),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.accept,
                              style: const TextStyle(
                                color: whiteColor,
                                fontSize: 12,
                              ),
                            ),
                      style: greenButtonStyle.copyWith(
                        minimumSize: WidgetStateProperty.all(
                          const Size(120, 32),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      onPressed: isProcessing
                          ? null
                          : () {
                              if (consultation.consultation.consultationId !=
                                  null) {
                                _showRejectConfirmationDialog(
                                  context: context,
                                  consultation: consultation,
                                );
                              }
                            },
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: darkGreenColor,
                      ),
                      label: isProcessing
                          ? const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  darkGreenColor,
                                ),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.reject,
                              style: const TextStyle(
                                color: darkGreenColor,
                                fontSize: 12,
                              ),
                            ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isProcessing ? greyColor : darkGreenColor,
                        ),
                        minimumSize: const Size(120, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPastAppointmentCard({
    required ConsultationWithDetails consultation,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: blueGreenColor,
            radius: 24,
            child: Icon(Icons.person, color: whiteColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  consultation.patientFullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  consultation.consultation.startTime,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
                Text(
                  consultation.consultation.consultationDate,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Check database for existing prescription PDF
          consultation.consultation.prescription == null ||
                  consultation.consultation.prescription!.isEmpty
              ? ElevatedButton.icon(
                  onPressed: () async {
                    if (consultation.consultation.consultationId == null)
                      return;

                    // Pick PDF file
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                    if (result != null && result.files.single.path != null) {
                      final file = File(result.files.single.path!);

                      // Upload PDF (path will be stored in prescription field)
                      if (context.mounted) {
                        context
                            .read<DoctorAppointmentsCubit>()
                            .uploadPrescriptionPDF(
                              consultation.consultation.consultationId!,
                              file,
                              '', // Empty string as we're storing path, not text
                            );
                      }

                      // Show success message
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.pdfUploadedSuccess,
                            ),
                            backgroundColor: darkGreenColor,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.upload_file,
                    size: 18,
                    color: whiteColor,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.uploadPdf,
                    style: const TextStyle(fontSize: 12, color: whiteColor),
                  ),
                  style: greenButtonStyle.copyWith(
                    backgroundColor: WidgetStateProperty.all(blueGreenColor),
                    minimumSize: WidgetStateProperty.all(const Size(100, 36)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: darkGreenColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: darkGreenColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.pdfUploaded,
                        style: const TextStyle(
                          fontSize: 12,
                          color: darkGreenColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  void _showAcceptConfirmationDialog({
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
                  color: darkGreenColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: darkGreenColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.confirmAccept,
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
                AppLocalizations.of(context)!.confirmAcceptMessage,
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
                            consultation.patientFullName,
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
                          '${consultation.consultation.consultationDate} at ${consultation.consultation.startTime}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancel,
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
                  context.read<DoctorAppointmentsCubit>().acceptAppointment(
                    consultation.consultation.consultationId!,
                    doctorId,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.appointmentAccepted,
                        ),
                        backgroundColor: darkGreenColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreenColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.accept,
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

  void _showRejectConfirmationDialog({
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
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.confirmReject,
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
                AppLocalizations.of(context)!.confirmRejectMessage,
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
                            consultation.patientFullName,
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
                          '${consultation.consultation.consultationDate} at ${consultation.consultation.startTime}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'The patient will be notified of the rejection.',
                style: TextStyle(
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
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(
                  color: greyColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final consultationId = consultation.consultation.consultationId;
                if (consultationId == null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error: Consultation ID is null'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  return;
                }

                if (context.mounted) {
                  print('🔴 UI: Rejecting consultation ID: $consultationId');
                  try {
                    await context
                        .read<DoctorAppointmentsCubit>()
                        .rejectAppointment(consultationId, doctorId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.appointmentRejected,
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  } catch (e) {
                    print('❌ UI Error: $e');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error rejecting appointment: ${e.toString()}',
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
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
              child: const Text(
                'Reject',
                style: TextStyle(
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
