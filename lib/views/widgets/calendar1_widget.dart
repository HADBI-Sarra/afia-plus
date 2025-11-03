import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

class AvailabilityCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const AvailabilityCalendar({
    super.key,
    required this.selectedDate,
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
    final daysInMonth = List.generate(
      DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month),
      (index) => DateTime(_focusedMonth.year, _focusedMonth.month, index + 1),
    );

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
                (d) => Text(
                  d,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 6),

        // 🔹 Calendar Days Grid
        Wrap(
          alignment: WrapAlignment.center,
          children: daysInMonth.map((day) {
            final bool isSelected =
                widget.selectedDate.day == day.day &&
                widget.selectedDate.month == day.month &&
                widget.selectedDate.year == day.year;

            return GestureDetector(
              onTap: () => widget.onDateSelected(day),
              child: Container(
                margin: const EdgeInsets.all(4),
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? darkGreenColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? darkGreenColor
                        : greyColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  "${day.day}",
                  style: TextStyle(
                    color: isSelected ? whiteColor : blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
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
