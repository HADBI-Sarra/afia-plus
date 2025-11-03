import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/widgets/calendar1_widget.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_doctor.dart';

class ScheduleAvailabilityPage extends StatefulWidget {
  const ScheduleAvailabilityPage({super.key});

  @override
  State<ScheduleAvailabilityPage> createState() =>
      _ScheduleAvailabilityPageState();
}

class _ScheduleAvailabilityPageState extends State<ScheduleAvailabilityPage> {
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, String>> availableSlots = [
    {"time": "09:00 AM - 09:30 AM"},
    {"time": "10:00 AM - 10:30 AM"},
  ];

  @override
  Widget build(BuildContext context) {
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
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: darkGreenColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Availability',
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
                const SizedBox(height: 8),

                AvailabilityCalendar(
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() => _selectedDate = date);
                  },
                ),

                const SizedBox(height: 12),
                Text(
                  "Available slots for ${_selectedDate.toString().substring(0, 10)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: darkGreenColor,
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: ListView.builder(
                    itemCount: availableSlots.length,
                    itemBuilder: (context, index) {
                      final slot = availableSlots[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.alarm,
                                  color: Color.fromARGB(255, 32, 255, 81),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  slot["time"]!,
                                  style: const TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delete_outline,
                                color: redColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: darkGreenColor,
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.add, color: whiteColor),
      ),

      bottomNavigationBar: const DoctorFooter(currentIndex: 2),
    );
  }
}
