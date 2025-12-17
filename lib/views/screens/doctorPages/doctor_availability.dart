import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/widgets/calendar1_widget.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_doctor.dart';
import 'package:afia_plus_app/logic/cubits/availability cubit/availability_cubit.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/data/models/DoctorAvailabilityModel.dart';

class ScheduleAvailabilityPage extends StatefulWidget {
  const ScheduleAvailabilityPage({super.key});

  @override
  State<ScheduleAvailabilityPage> createState() => _ScheduleAvailabilityPageState();
}

class _ScheduleAvailabilityPageState extends State<ScheduleAvailabilityPage> {
  DateTime _selectedDate = DateTime.now();
  int? _doctorId;

  @override
  void initState() {
    super.initState();
    // Get the current logged-in doctor ID from AuthCubit
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthenticatedDoctor) {
      _doctorId = authState.doctor.userId;
      if (_doctorId != null) {
        context.read<AvailabilityCubit>().loadAvailabilityForDoctor(_doctorId!);
      }
    }
  }

  Future<void> _showAddTimesModal() async {
    final availableHours = List.generate(13, (i) => (8 + i).toString().padLeft(2, '0') + ":00");
    final Set<String> selectedHours = {};
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select available hours", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      for (final h in availableHours)
                        ChoiceChip(
                          label: Text(h),
                          selected: selectedHours.contains(h),
                          onSelected: (sel) {
                            setModal((){
                              sel ? selectedHours.add(h) : selectedHours.remove(h);
                            });
                          }
                        )
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreenColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: selectedHours.isEmpty || _doctorId == null ? null : () async {
                        await context.read<AvailabilityCubit>().addMultipleAvailabilities(
                          doctorId: _doctorId!,
                          date: _selectedDate.toIso8601String().substring(0, 10),
                          times: selectedHours.toList(),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text("Add times", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext ctx, int availabilityId) async {
    final bool? confirmed = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text("Delete slot?"),
        content: const Text("Are you sure you want to delete this time slot?"),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(ctx, false)),
          TextButton(child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );
    if (confirmed == true && _doctorId != null) {
      await context.read<AvailabilityCubit>().deleteAvailabilityById(availabilityId, _doctorId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailabilityCubit, AvailabilityState>(
      builder: (context, state) {
        final DateTime today = DateTime.now();
        final DateTime todayDateOnly = DateTime(today.year, today.month, today.day);
        final String dateKey = _selectedDate.toIso8601String().substring(0, 10);
        List<DoctorAvailabilityModel> slotsForDay = [];
        List<DateTime> availableDates = [];
        if (state is AvailabilityLoaded && _doctorId != null) {
          slotsForDay = state.doctorAvailabilityList
              .where((a) => a.availableDate == dateKey && a.doctorId == _doctorId && a.status == 'free')
              .toList();
          // Get all unique dates that have available slots for this doctor
          final datesWithSlots = state.doctorAvailabilityList
              .where((a) => a.doctorId == _doctorId && a.status == 'free')
              .map((a) => DateTime.parse(a.availableDate))
              .toSet();
          availableDates = datesWithSlots.toList();
        }

        return Scaffold(
          extendBody: true,
          body: Container(
            decoration: gradientBackgroundDecoration,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: darkGreenColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(child: Text('Availability', style: TextStyle(color: blackColor, fontWeight: FontWeight.w700, fontSize: 20))),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AvailabilityCalendar(
                      selectedDate: _selectedDate,
                      availableDates: availableDates,
                      onDateSelected: (date) {
                        final DateTime dateOnly = DateTime(date.year, date.month, date.day);
                        if (dateOnly.isBefore(todayDateOnly)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You cannot set availability in the past.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        setState(() => _selectedDate = dateOnly);
                      },
                    ),
                    const SizedBox(height: 12),
                    Text("Available slots for ${dateKey}",
                      style: const TextStyle(fontWeight: FontWeight.w600, color: darkGreenColor),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: (slotsForDay.isEmpty)
                        ? const Center(child: Text("No times for this day. Add some with + . "))
                        : ListView.builder(
                            itemCount: slotsForDay.length,
                            itemBuilder: (context, idx) {
                              final slot = slotsForDay[idx];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: whiteColor.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [BoxShadow(
                                    color: greyColor.withOpacity(0.15),
                                    blurRadius: 5, offset: const Offset(0, 2)
                                  )],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.alarm, color: Color.fromARGB(255, 32, 255, 81)),
                                        const SizedBox(width: 12),
                                        Text(slot.startTime, style: const TextStyle(color: blackColor, fontWeight: FontWeight.w500)),
                                      ]
                                    ),
                                    IconButton(
                                      onPressed: () => _confirmDelete(context, slot.availabilityId!),
                                      icon: const Icon(Icons.delete_outline, color: redColor),
                                    )
                                  ],
                                ),
                              );
                            })
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: darkGreenColor,
            onPressed: () {
              final DateTime dateOnly = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
              if (dateOnly.isBefore(todayDateOnly)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Select today or a future date to add availability.'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              _showAddTimesModal();
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: const Icon(Icons.add, color: whiteColor),
          ),
          bottomNavigationBar: const DoctorFooter(currentIndex: 2),
        );
      },
    );
  }
}
