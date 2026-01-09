import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/doctor_about_tab.dart';
import 'package:afia_plus_app/views/widgets/doctor_book_tab.dart';
import 'package:afia_plus_app/views/widgets/doctor_reviews_tab.dart';
import 'package:afia_plus_app/logic/cubits/doctors/doctors_cubit.dart';
import 'package:afia_plus_app/data/models/doctor.dart';
import 'package:afia_plus_app/data/models/speciality.dart';
import 'package:afia_plus_app/data/repo/specialities/speciality_repository.dart';
import 'package:afia_plus_app/logic/cubits/availability cubit/availability_cubit.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/logic/cubits/booking/booking_cubit.dart';
import 'package:afia_plus_app/views/screens/homescreen/patient_home_screen.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';

// inside class DoctorProfileScreen:
class DoctorProfileScreen extends StatefulWidget {
  final int doctorId;
  static const routename = "/userViewDoctorProfile";
  const DoctorProfileScreen({Key? key, required this.doctorId})
    : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  Doctor? doctor;
  Speciality? speciality;
  bool loading = true;
  String? error;
  int selectedTab = 0;
  DateTime? selectedBookDay;
  String? selectedBookTime;

  @override
  void initState() {
    super.initState();
    _loadDoctor();
  }

  Future<void> _loadDoctor() async {
    final cubit = context.read<DoctorsCubit>();
    final result = await cubit.getDoctorById(widget.doctorId);
    if (result.state && result.data != null) {
      setState(() {
        doctor = result.data;
        loading = false;
      });
      if (doctor?.specialityId != null && doctor!.specialityId != 0) {
        final specialityRepo = GetIt.I<SpecialityRepository>();
        final fetched = await specialityRepo.getSpecialityById(
          doctor!.specialityId!,
        );
        setState(() => speciality = fetched);
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (loading)
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null) return Scaffold(body: Center(child: Text(error!)));
    if (doctor == null)
      return Scaffold(body: Center(child: Text(l10n.doctorNotFound)));

    return BlocProvider<BookingCubit>(
      create: (_) => BookingCubit(),
      child: Container(
        decoration: gradientBackgroundDecoration,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              l10n.doctorProfile,
              style: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, color: blackColor),
              onPressed: () => Navigator.pop(context),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.favorite_border, color: blackColor),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Dr.${doctor!.firstname} ${doctor!.lastname}",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: blackColor),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              speciality?.name ?? l10n.specialist,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: greyColor),
                            ),
                            const SizedBox(height: 15),
                            // Rating
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.grade_rounded,
                                    color: greenColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    doctor!.averageRating.toStringAsFixed(1),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:
                            doctor!.profilePicture != null &&
                                doctor!.profilePicture!.isNotEmpty
                            ? Image.network(
                                doctor!.profilePicture!,
                                width: 120,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 120,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: greyColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 60,
                                      color: greyColor,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 120,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: greyColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: greyColor,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Tabs
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedTab = 0),
                          child: Column(
                            children: [
                              Text(
                                l10n.book,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: selectedTab == 0
                                          ? darkGreenColor
                                          : blackColor,
                                    ),
                              ),
                              if (selectedTab == 0)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  height: 2,
                                  width: double.infinity,
                                  color: darkGreenColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedTab = 1),
                          child: Center(
                            child: Text(
                              l10n.about,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: selectedTab == 1
                                        ? darkGreenColor
                                        : blackColor,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedTab = 2),
                          child: Center(
                            child: Text(
                              l10n.reviews,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: selectedTab == 2
                                        ? darkGreenColor
                                        : blackColor,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (selectedTab == 0)
                            DoctorBookTab(
                              doctorId: widget.doctorId,
                              onDaySelected: (day) {
                                setState(() {
                                  selectedBookDay = day;
                                });
                              },
                              onTimeSelected: (time) {
                                setState(() {
                                  selectedBookTime = time;
                                });
                              },
                            ),
                          if (selectedTab == 1)
                            DoctorAboutTab(
                              doctor: doctor!,
                              speciality: speciality,
                            ),
                          if (selectedTab == 2)
                            DoctorReviewsTab(doctor: doctor!),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<BookingCubit, BookingState>(
                    listener: (context, state) {
                      if (state is BookingSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.bookingSuccessMessage,
                            ),
                            backgroundColor: darkGreenColor,
                          ),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => PatientHomeScreen(),
                            ),
                            (route) => false,
                          );
                        });
                      } else if (state is BookingFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, bookingState) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreenColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            if (selectedBookDay == null ||
                                selectedBookTime == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.pleaseSelectTime,
                                  ),
                                ),
                              );
                              return;
                            }

                            // Check if selected date is in the past
                            final today = DateTime.now();
                            final todayOnly = DateTime(
                              today.year,
                              today.month,
                              today.day,
                            );
                            final selectedDateOnly = DateTime(
                              selectedBookDay!.year,
                              selectedBookDay!.month,
                              selectedBookDay!.day,
                            );

                            if (selectedDateOnly.isBefore(todayOnly)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.cannotBookPastDate,
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                              return;
                            }

                            // Check if selected time is in the past (for today)
                            if (selectedDateOnly.isAtSameMomentAs(todayOnly)) {
                              final currentTime = TimeOfDay.now();
                              final currentMinutes =
                                  currentTime.hour * 60 + currentTime.minute;

                              // Parse selected time (e.g., "18:00")
                              final timeParts = selectedBookTime!.split(':');
                              if (timeParts.length == 2) {
                                final hour = int.tryParse(timeParts[0]) ?? 0;
                                final minute = int.tryParse(timeParts[1]) ?? 0;
                                final selectedMinutes = hour * 60 + minute;

                                if (selectedMinutes <= currentMinutes) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.cannotBookPastTime,
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }
                              }
                            }

                            // Find availabilityId for selected date/time:
                            final availCubit = context
                                .read<AvailabilityCubit>();
                            final state = availCubit.state;
                            int? availabilityId;
                            if (state is AvailabilityLoaded) {
                              for (final avail
                                  in state.doctorAvailabilityList) {
                                if (avail.availableDate ==
                                        selectedBookDay!
                                            .toIso8601String()
                                            .split('T')[0] &&
                                    avail.startTime == selectedBookTime) {
                                  availabilityId = avail.availabilityId;
                                  break;
                                }
                              }
                            }
                            if (availabilityId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.noAvailableSlot,
                                  ),
                                ),
                              );
                              return;
                            }
                            // Get patientId from AuthCubit
                            final authState = context.read<AuthCubit>().state;
                            int? patientId;
                            if (authState is AuthenticatedPatient) {
                              patientId = authState.patient.userId;
                            }
                            if (patientId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.mustBeLoggedInAsPatient,
                                  ),
                                ),
                              );
                              return;
                            }
                            // Book
                            final bookingCubit = context.read<BookingCubit>();
                            bookingCubit.book(
                              patientId: patientId,
                              doctorId: doctor!.userId!,
                              availabilityId: availabilityId,
                              consultationDate: selectedBookDay!
                                  .toIso8601String()
                                  .split('T')[0],
                              startTime: selectedBookTime!,
                            );

                            // Refresh patient home after booking
                            Future.delayed(const Duration(milliseconds: 500), () {
                              if (context.mounted) {
                                final authState = context
                                    .read<AuthCubit>()
                                    .state;
                                if (authState is AuthenticatedPatient) {
                                  // Trigger reload of patient appointments if available
                                  print(
                                    '🔄 Booking complete, data should refresh automatically',
                                  );
                                }
                              }
                            });
                          },
                          child: bookingState is BookingInProgress
                              ? const CircularProgressIndicator(
                                  color: whiteColor,
                                )
                              : Text(
                                  l10n.bookAppointment,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
