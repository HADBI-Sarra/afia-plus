import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

class CalendarGrid extends StatelessWidget {
  final int selectedDay;
  final String month;
  final int firstWeekday; // 0=Sun, 1=Mon ...
  final int daysInMonth;

  const CalendarGrid({
    super.key,
    this.selectedDay = 17,
    this.month = "October 2025",
    this.firstWeekday = 3,
    this.daysInMonth = 31,
  });

  @override
  Widget build(BuildContext context) {
    final weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    List<Widget> rows = [];

    // Month Title
    rows.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        month,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontSize: 18),
      ),
    ));

    // Weekdays header
    rows.add(Row(
      children: weekdays
          .map((d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ))
          .toList(),
    ));

    int day = 1;
    while (day <= daysInMonth) {
      List<Widget> week = [];
      for (int i = 0; i < 7; i++) {
        if ((rows.length == 2 && i < firstWeekday) || day > daysInMonth) {
          week.add(const Expanded(child: SizedBox(height: 40)));
        } else {
          final isSelected = day == selectedDay;
          week.add(
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: CircleAvatar(
                  backgroundColor: isSelected ? darkGreenColor : whiteColor,
                  radius: 18,
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: isSelected ? whiteColor : blackColor,
                    ),
                  ),
                ),
              ),
            ),
          );
          day++;
        }
      }
      rows.add(Row(children: week));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
