import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_doctor.dart';
import 'package:afia_plus_app/cubits/doctor_home_cubit.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/utils/whatsapp_service.dart';
import 'package:afia_plus_app/views/widgets/language_switcher.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  final String name = "Mohamed";

  Widget sectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.seeAll,
          style: greenLink,
        ),
      ],
    );
  }

  Widget _buildConsultationCardFromData({
    required ConsultationWithDetails consultation,
    required BuildContext context,
  }) {
    return _buildConsultationCard(
      name: consultation.patientFullName,
      time: consultation.consultation.startTime,
      date: consultation.consultation.consultationDate,
      phoneNumber: consultation.patientPhoneNumber,
      context: context,
    );
  }

  Widget _buildConsultationCard({
    required String name,
    required String time,
    required String date,
    String? phoneNumber,
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
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
                Text(
                  date,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              if (phoneNumber != null && phoneNumber.isNotEmpty) {
                final success = await WhatsAppService.openWhatsApp(
                  phoneNumber: phoneNumber,
                  message: AppLocalizations.of(context)!.whatsappMessageDoctorToPatient(AppLocalizations.of(context)!.atTime(date, time)),
                );
                  if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.whatsappErrorDoctor),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.phoneNumberNotAvailableDoctor),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreenColor,
              minimumSize: const Size(100, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
                            AppLocalizations.of(context)!.whatsapp,
                            style: const TextStyle(color: whiteColor, fontSize: 13),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCardFromData({
    required ConsultationWithDetails consultation,
    required BuildContext context,
    required int doctorId,
  }) {
    return _buildAppointmentCard(
      name: consultation.patientFullName,
      time: consultation.consultation.startTime,
      date: consultation.consultation.consultationDate,
      consultationId: consultation.consultation.consultationId,
      context: context,
      doctorId: doctorId,
    );
  }

  Widget _buildAppointmentCard({
    required String name,
    required String time,
    required String date,
    required int? consultationId,
    required BuildContext context,
    required int doctorId,
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
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
                Text(
                  date,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
            builder: (context, state) {
              final isProcessing = consultationId != null &&
                  state.processingConsultationIds.contains(consultationId);
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: isProcessing ? null : () {
                      if (consultationId != null) {
                        _showAcceptConfirmationDialog(
                          context: context,
                          consultationId: consultationId,
                          patientName: name,
                          date: date,
                          time: time,
                          doctorId: doctorId,
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
                              valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.accept,
                            style: const TextStyle(color: whiteColor, fontSize: 12),
                          ),
                    style: greenButtonStyle.copyWith(
                      minimumSize: WidgetStateProperty.all(const Size(120, 32)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  OutlinedButton.icon(
                    onPressed: isProcessing ? null : () {
                      if (consultationId != null) {
                        _showRejectConfirmationDialog(
                          context: context,
                          consultationId: consultationId,
                          patientName: name,
                          date: date,
                          time: time,
                          doctorId: doctorId,
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
                              valueColor: AlwaysStoppedAnimation<Color>(darkGreenColor),
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.reject,
                            style: const TextStyle(color: darkGreenColor, fontSize: 12),
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
            },
          ),
        ],
      ),
    );
  }

  Widget specialityLink(BuildContext context, String name, String number) {
    return ElevatedButton(
      onPressed: () {},
      style: whiteButtonStyle,
      child: Row(
        children: [
          Text(name, style: Theme.of(context).textTheme.labelMedium),
          Expanded(child: Container()),
          Text(number, style: TextStyle(color: greyColor)),
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
          Text(name, style: Theme.of(context).textTheme.labelMedium),
          Expanded(child: Container()),
          Icon(Icons.arrow_outward_rounded),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (authState is! AuthenticatedDoctor) {
          return Scaffold(
            body: Center(child: Text(AppLocalizations.of(context)!.pleaseLogInAsDoctor)),
          );
        }

        final doctorId = authState.doctor.userId!;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
          create: (context) => DoctorHomeCubit()..loadConsultations(doctorId),
            ),
          ],
          child: Container(
            decoration: gradientBackgroundDecoration,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: const Icon(Icons.arrow_back_ios_new, color: greyColor),
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
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                        Text(
                          AppLocalizations.of(context)!.helloDoctor(authState.doctor.lastname),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.quickOverview,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
                                          builder: (context, state) {
                                            if (state.isLoading) {
                                              return Column(
                                                children: [
                                                  specialityLink(context, AppLocalizations.of(context)!.today, AppLocalizations.of(context)!.loading),
                                                  const SizedBox(height: 10),
                                                  specialityLink(context, AppLocalizations.of(context)!.pendingRequests, AppLocalizations.of(context)!.loading),
                                                  const SizedBox(height: 10),
                                                  specialityLink(context, AppLocalizations.of(context)!.totalPatients, AppLocalizations.of(context)!.loading),
                                                ],
                                              );
                                            }
                            
                                            return Column(
                                              children: [
                                                specialityLink(context, AppLocalizations.of(context)!.today, AppLocalizations.of(context)!.appointmentsCount(state.todayConsultations)),
                                                const SizedBox(height: 10),
                                                specialityLink(context, AppLocalizations.of(context)!.pendingRequests, state.pendingConsultationsCount != 1 
                                                    ? AppLocalizations.of(context)!.requestsCountPlural(state.pendingConsultationsCount)
                                                    : AppLocalizations.of(context)!.requestsCount(state.pendingConsultationsCount)),
                                                const SizedBox(height: 10),
                                                specialityLink(context, AppLocalizations.of(context)!.totalPatients, AppLocalizations.of(context)!.patientsCount(state.totalPatients)),
                                              ],
                                            );
                                          },
                                        ),
                        const SizedBox(height: 20),
                        sectionTitle(context, AppLocalizations.of(context)!.comingConsultations),
                        const SizedBox(height: 20),
                        BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
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
                                  AppLocalizations.of(context)!.errorLoadingConsultations,
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            if (state.comingConsultations.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  AppLocalizations.of(context)!.noUpcomingConsultations,
                                  style: const TextStyle(color: greyColor),
                                ),
                              );
                            }

                            // Display coming consultations from database
                            return Column(
                              children: state.comingConsultations
                                  .map((consultation) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: _buildConsultationCardFromData(
                                          consultation: consultation,
                                          context: context,
                                        ),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        sectionTitle(context, AppLocalizations.of(context)!.pendingConsultations),
                        const SizedBox(height: 20),
                        BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
                          builder: (context, state) {
                            if (state.pendingConsultations.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  AppLocalizations.of(context)!.noPendingConsultations,
                                  style: const TextStyle(color: greyColor),
                                ),
                              );
                            }

                            return Column(
                              children: state.pendingConsultations
                                  .map((consultation) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: _buildAppointmentCardFromData(
                                          consultation: consultation,
                                          context: context,
                                            doctorId: doctorId,
                                        ),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.services,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        seviceLink(context, AppLocalizations.of(context)!.appointments),
                        const SizedBox(height: 10),
                        seviceLink(context, AppLocalizations.of(context)!.availability),
                        const SizedBox(height: 10),
                        seviceLink(context, AppLocalizations.of(context)!.faq),
                        const SizedBox(height: 20),
                        DoctorFooter(currentIndex: 0),
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
  });
}

  void _showAcceptConfirmationDialog({
    required BuildContext context,
    required int consultationId,
    required String patientName,
    required String date,
    required String time,
    required int doctorId,
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
                        const Icon(Icons.person, size: 18, color: darkGreenColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            patientName,
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
                        const Icon(Icons.calendar_today, size: 18, color: darkGreenColor),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.atTime(date, time),
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
                context.read<DoctorHomeCubit>().acceptConsultation(
                      consultationId,
                      doctorId,
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.appointmentAcceptedSuccessfully),
                    backgroundColor: darkGreenColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreenColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
    required int consultationId,
    required String patientName,
    required String date,
    required String time,
    required int doctorId,
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
                AppLocalizations.of(context)!.areYouSureRejectAppointment,
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
                        const Icon(Icons.person, size: 18, color: darkGreenColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            patientName,
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
                        const Icon(Icons.calendar_today, size: 18, color: darkGreenColor),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.atTime(date, time),
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
              Text(
                AppLocalizations.of(context)!.patientWillBeNotified,
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
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                if (context.mounted) {
                  print('🔴 UI: Rejecting consultation ID: $consultationId');
                  try {
                    await context.read<DoctorHomeCubit>().rejectConsultation(
                          consultationId,
                          doctorId,
                        );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.appointmentRejectedSuccessfully),
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
                          content: Text(AppLocalizations.of(context)!.errorOccurred(e.toString())),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                AppLocalizations.of(context)!.reject,
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