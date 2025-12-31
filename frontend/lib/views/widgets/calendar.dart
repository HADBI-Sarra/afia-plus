import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

class CalendarGrid extends StatefulWidget {
  final List<DateTime> availableDates;
  final DateTime? selectedDay;
  final Function(DateTime) onSelect;

  const CalendarGrid({
    super.key,
    required this.availableDates,
    required this.selectedDay,
    required this.onSelect,
  });

  @override
  State<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.selectedDay ?? DateTime.now();
  }

  @override
  void didUpdateWidget(CalendarGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update focused month if selected day changes to a different month
    if (widget.selectedDay != null &&
        (widget.selectedDay!.year != _focusedMonth.year ||
         widget.selectedDay!.month != _focusedMonth.month)) {
      _focusedMonth = widget.selectedDay!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthStart = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    // Get the weekday of the first day (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
    final firstWeekday = monthStart.weekday % 7;

    List<Widget> rows = [];

    /// MONTH NAME WITH NAVIGATION
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18, color: greyColor),
            onPressed: () {
              setState(() {
                _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "${_monthName(_focusedMonth.month)} ${_focusedMonth.year}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18, color: greyColor),
            onPressed: () {
              setState(() {
                _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
              });
            },
          ),
        ],
      ),
    );

    /// WEEKDAY LABELS
    const weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    rows.add(
      Row(
        children: weekdays
            .map(
              (d) => Expanded(
                child: Center(
                  child: Text(d,
                      style: Theme.of(context).textTheme.labelMedium),
                ),
              ),
            )
            .toList(),
      ),
    );

    /// CALENDAR GRID - Build proper grid with correct alignment
    List<Widget> calendarDays = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      calendarDays.add(
        Expanded(
          child: Container(
            height: 40,
            margin: const EdgeInsets.all(6),
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

      final isSelected = widget.selectedDay != null &&
          widget.selectedDay!.year == thisDate.year &&
          widget.selectedDay!.month == thisDate.month &&
          widget.selectedDay!.day == thisDate.day;

      calendarDays.add(
        Expanded(
          child: GestureDetector(
            onTap: isAvailable
                ? () {
                    widget.onSelect(thisDate);
                  }
                : null,
            child: Container(
              height: 40,
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? darkGreenColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? darkGreenColor
                      : isAvailable
                          ? blackColor
                          : greyColor.withOpacity(0.5),
                  width: isSelected ? 0 : 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  "$day",
                  style: TextStyle(
                    color: isSelected
                        ? whiteColor
                        : isAvailable
                            ? blackColor
                            : greyColor.withOpacity(0.7),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
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
              margin: const EdgeInsets.all(6),
            ),
          ),
        );
      }
    }
    
    // Group days into weeks (rows of 7)
    for (int i = 0; i < calendarDays.length; i += 7) {
      rows.add(
        Row(
          children: calendarDays.sublist(
            i,
            i + 7 > calendarDays.length ? calendarDays.length : i + 7,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  String _monthName(int m) {
    const names = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return names[m - 1];
  }
}
