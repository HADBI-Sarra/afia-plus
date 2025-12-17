import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

class AvailabilityCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final List<DateTime> availableDates;
  final Function(DateTime) onDateSelected;

  const AvailabilityCalendar({
    super.key,
    required this.selectedDate,
    required this.availableDates,
    required this.onDateSelected,
  });

  @override
  State<AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final monthStart = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstWeekday = monthStart.weekday % 7; // 0 = Sunday, 1 = Monday, etc.

    return Column(
      children: [
        // 🔹 Month Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: greyColor,
              ),
              onPressed: () {
                setState(
                  () => _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month - 1,
                  ),
                );
              },
            ),
            Text(
              "${_monthName(_focusedMonth.month)} ${_focusedMonth.year}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: blackColor,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: greyColor,
              ),
              onPressed: () {
                setState(
                  () => _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month + 1,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 🔹 Weekday labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: const TextStyle(color: greyColor, fontSize: 13),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 6),

        // 🔹 Calendar Days Grid - Properly aligned
        Builder(
          builder: (context) {
            List<Widget> calendarDays = [];
            
            // Add empty cells for days before the first day of the month
            for (int i = 0; i < firstWeekday; i++) {
              calendarDays.add(
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(4),
                  ),
                ),
              );
            }
            
            // Add cells for each day of the month
            for (int day = 1; day <= daysInMonth; day++) {
              final thisDate = DateTime(_focusedMonth.year, _focusedMonth.month, day);
              final isAvailable = widget.availableDates.any((d) =>
                  d.year == thisDate.year &&
                  d.month == thisDate.month &&
                  d.day == thisDate.day);
              
              final bool isSelected =
                  widget.selectedDate.day == day &&
                  widget.selectedDate.month == _focusedMonth.month &&
                  widget.selectedDate.year == _focusedMonth.year;

              calendarDays.add(
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onDateSelected(thisDate),
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? darkGreenColor : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? darkGreenColor
                              : isAvailable
                                  ? blackColor
                                  : greyColor.withOpacity(0.5),
                          width: isSelected ? 0 : 1.5,
                        ),
                      ),
                      child: Text(
                        "$day",
                        style: TextStyle(
                          color: isSelected
                              ? whiteColor
                              : isAvailable
                                  ? blackColor
                                  : greyColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            
            // Add empty cells for remaining days in the last week
            final totalCells = calendarDays.length;
            final remainingCells = 7 - (totalCells % 7);
            if (remainingCells < 7) {
              for (int i = 0; i < remainingCells; i++) {
                calendarDays.add(
                  Expanded(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(4),
                    ),
                  ),
                );
              }
            }
            
            // Group days into weeks (rows of 7)
            List<Widget> weekRows = [];
            for (int i = 0; i < calendarDays.length; i += 7) {
              weekRows.add(
                Row(
                  children: calendarDays.sublist(
                    i,
                    i + 7 > calendarDays.length ? calendarDays.length : i + 7,
                  ),
                ),
              );
            }
            
            return Column(children: weekRows);
          },
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
