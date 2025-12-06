import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_doctor.dart';
import 'package:afia_plus_app/cubits/doctor_appointments_cubit.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  // TODO: Replace with actual doctor ID from authentication/session
  static const int doctorId = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorAppointmentsCubit()..loadAppointments(doctorId),
      child: const _SchedulePageView(),
    );
  }
}

class _SchedulePageView extends StatelessWidget {
  const _SchedulePageView();
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
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
                          context.read<DoctorAppointmentsCubit>().refreshAppointments(SchedulePage.doctorId);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
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
                    const SizedBox(height: 24),
                    if (state.upcomingAppointments.isNotEmpty) ...[
                      const Text(
                        'Upcoming Appointments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkGreenColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...state.upcomingAppointments.map((consultation) => _buildAppointmentCard(
                            consultation: consultation,
                            context: context,
                          )),
                      const SizedBox(height: 24),
                    ],
                    if (state.pastAppointments.isNotEmpty) ...[
                      const Text(
                        'Past Appointments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkGreenColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...state.pastAppointments.map((consultation) => _buildPastAppointmentCard(
                            consultation: consultation,
                            context: context,
                          )),
                    ],
                    if (state.upcomingAppointments.isEmpty && state.pastAppointments.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Text(
                            'No appointments found',
                            style: TextStyle(color: greyColor, fontSize: 16),
                          ),
                        ),
                      ),
                    const SizedBox(height: 80),
                  ],
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
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: darkGreenColor,
          child: Icon(Icons.person, color: whiteColor),
        ),
        title: Text(
          consultation.patientFullName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
        subtitle: Text(
          '${consultation.consultation.startTime}\n${consultation.consultation.consultationDate}',
          style: const TextStyle(color: greyColor),
        ),
        trailing: consultation.consultation.status == 'pending'
            ? IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (consultation.consultation.consultationId != null) {
                          context.read<DoctorAppointmentsCubit>().acceptAppointment(
                                consultation.consultation.consultationId!,
                                SchedulePage.doctorId,
                              );
                        }
                      },
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
                    const SizedBox(height: 4),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (consultation.consultation.consultationId != null) {
                          context.read<DoctorAppointmentsCubit>().rejectAppointment(
                                consultation.consultation.consultationId!,
                                SchedulePage.doctorId,
                              );
                        }
                      },
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
              )
            : null,
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
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: blueGreenColor,
          child: Icon(Icons.person, color: whiteColor),
        ),
        title: Text(
          consultation.patientFullName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
        subtitle: Text(
          '${consultation.consultation.startTime}\n${consultation.consultation.consultationDate}',
          style: const TextStyle(color: greyColor),
        ),
        trailing: consultation.consultation.prescription == null || 
                  consultation.consultation.prescription!.isEmpty
            ? ElevatedButton.icon(
                onPressed: () async {
                  if (consultation.consultation.consultationId == null) return;

                  // Pick PDF file
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );

                  if (result != null && result.files.single.path != null) {
                    final file = File(result.files.single.path!);
                    
                    // Upload PDF (path will be stored in prescription field)
                    context.read<DoctorAppointmentsCubit>().uploadPrescriptionPDF(
                          consultation.consultation.consultationId!,
                          file,
                          '', // Empty string as we're storing path, not text
                        );
                    
                    // Show success message
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Prescription PDF uploaded successfully'),
                          backgroundColor: darkGreenColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.upload_file, size: 18, color: whiteColor),
                label: const Text(
                  'Upload PDF',
                  style: TextStyle(fontSize: 12, color: whiteColor),
                ),
                style: greenButtonStyle.copyWith(
                  backgroundColor: WidgetStateProperty.all(blueGreenColor),
                  minimumSize: WidgetStateProperty.all(const Size(90, 36)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: darkGreenColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: darkGreenColor),
                    SizedBox(width: 4),
                    Text(
                      'PDF Uploaded',
                      style: TextStyle(
                        fontSize: 12,
                        color: darkGreenColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
