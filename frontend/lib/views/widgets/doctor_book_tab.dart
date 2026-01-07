import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/logic/cubits/availability cubit/availability_cubit.dart';
import 'calendar.dart';

class DoctorBookTab extends StatefulWidget {
  final int doctorId;
  final void Function(DateTime?)? onDaySelected;
  final void Function(String?)? onTimeSelected;

  const DoctorBookTab({
    super.key,
    required this.doctorId,
    this.onDaySelected,
    this.onTimeSelected,
  });

  @override
  State<DoctorBookTab> createState() => _DoctorBookTabState();
}

class _DoctorBookTabState extends State<DoctorBookTab> {
  DateTime? selectedDay;
  String? selectedTime;

  DateTime? get getSelectedDay => selectedDay;
  String? get getSelectedTime => selectedTime;

  @override
  void initState() {
    super.initState();
    // Load availability for this doctor
    context.read<AvailabilityCubit>().loadAvailabilityForDoctor(
      widget.doctorId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailabilityCubit, AvailabilityState>(
      builder: (context, state) {
        if (state is AvailabilityLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is! AvailabilityLoaded) {
          return const Text("No availability");
        }

        // Get current date without time
        final today = DateTime.now();
        final todayOnly = DateTime(today.year, today.month, today.day);

        // Filter out past dates - only show today and future dates
        final availability = state.availability.where((avail) {
          final availDate = DateTime(
            avail.date.year,
            avail.date.month,
            avail.date.day,
          );
          return !availDate.isBefore(todayOnly);
        }).toList();

        final availableDates = availability.map((e) => e.date).toList();

        // Show message if no future dates available
        if (availableDates.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "No upcoming availability. This doctor has no available time slots for booking.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // If no selected day yet, pick first available day (from future dates only)
        if (selectedDay == null && availableDates.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedDay = availableDates.first;
            });
          });
        }

        final timesForSelected = selectedDay != null
            ? (() {
                final selectedDate = DateTime(
                  selectedDay!.year,
                  selectedDay!.month,
                  selectedDay!.day,
                );
                final matching = availability.firstWhere(
                  (e) {
                    final availableDate = DateTime(
                      e.date.year,
                      e.date.month,
                      e.date.day,
                    );
                    return selectedDate.isAtSameMomentAs(availableDate);
                  },
                  orElse: () =>
                      AvailabilityModel(date: DateTime.now(), times: []),
                );

                // Filter out past time slots if the selected day is today
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final isToday = selectedDate.isAtSameMomentAs(today);

                if (isToday) {
                  // Filter out times that have already passed
                  return matching.times.where((timeString) {
                    try {
                      // Parse time string (format: "HH:MM" or "H:MM")
                      final timeParts = timeString.split(':');
                      if (timeParts.length != 2)
                        return true; // Keep if format is unexpected

                      final hour = int.tryParse(timeParts[0]);
                      final minute = int.tryParse(timeParts[1]);

                      if (hour == null || minute == null)
                        return true; // Keep if parsing fails

                      // Create DateTime for the slot time today
                      final slotTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        hour,
                        minute,
                      );

                      // Keep only if slot time is in the future (not in the past)
                      // If it's exactly the current time, we remove it as the slot has started
                      return slotTime.isAfter(now);
                    } catch (e) {
                      // If parsing fails, keep the time slot
                      return true;
                    }
                  }).toList();
                }

                return matching.times;
              })()
            : [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PRICE
            Text(
              "Price",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "1 hour consultation",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  "1000 DZD",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 25),
            Divider(color: greyColor),

            /// CALENDAR
            CalendarGrid(
              availableDates: availableDates,
              selectedDay: selectedDay,
              onSelect: (day) {
                setState(() {
                  selectedDay = day;
                  selectedTime = null;
                });
                if (widget.onDaySelected != null) {
                  widget.onDaySelected!(day);
                }
                if (widget.onTimeSelected != null) {
                  widget.onTimeSelected!(null);
                }
              },
            ),

            const SizedBox(height: 25),
            Divider(color: greyColor),

            /// TIME SELECTION
            Text(
              "Select time",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10),

            if (timesForSelected.isEmpty)
              const Text("No available times for this day"),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final t in timesForSelected)
                  ChoiceChip(
                    label: Text(t),
                    selected: selectedTime == t,
                    selectedColor: darkGreenColor,
                    backgroundColor: whiteColor,
                    labelStyle: TextStyle(
                      color: selectedTime == t ? whiteColor : blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                    onSelected: (_) {
                      setState(() {
                        selectedTime = t;
                      });
                      if (widget.onTimeSelected != null) {
                        widget.onTimeSelected!(t);
                      }
                    },
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
