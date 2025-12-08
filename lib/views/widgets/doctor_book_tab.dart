import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/logic/cubits/availability cubit/availability_cubit.dart';
import 'calendar.dart';

class DoctorBookTab extends StatefulWidget {
  final int doctorId;
  
  const DoctorBookTab({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorBookTab> createState() => _DoctorBookTabState();
}

class _DoctorBookTabState extends State<DoctorBookTab> {
  DateTime? selectedDay;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    // Load availability for this doctor
    context.read<AvailabilityCubit>().loadAvailabilityForDoctor(widget.doctorId);
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

        final availability = state.availability;
        final availableDates = availability.map((e) => e.date).toList();

        // If no selected day yet, pick first available day
        if (selectedDay == null && availableDates.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedDay = availableDates.first;
            });
          });
        }

        final timesForSelected = selectedDay != null
            ? (() {
                final selectedDate = DateTime(selectedDay!.year, selectedDay!.month, selectedDay!.day);
                final matching = availability.firstWhere(
                  (e) {
                    final availableDate = DateTime(e.date.year, e.date.month, e.date.day);
                    return selectedDate.isAtSameMomentAs(availableDate);
                  },
                  orElse: () => AvailabilityModel(date: DateTime.now(), times: []),
                );
                return matching.times;
              })()
            : [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PRICE
            Text("Price",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18)),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("1 hour consultation",
                    style: Theme.of(context).textTheme.bodyMedium),
                Text("1000 DZD",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
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
              },
            ),

            const SizedBox(height: 25),
            Divider(color: greyColor),

            /// TIME SELECTION
            Text("Select time",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18)),
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
