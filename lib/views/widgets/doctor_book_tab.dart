import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'calendar.dart';

class DoctorBookTab extends StatelessWidget {
  const DoctorBookTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price Section
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 25),
        Divider(color: greyColor),

        // Calendar Section
        const CalendarGrid(),

        const SizedBox(height: 25),
        Divider(color: greyColor),

        // Time Selection
        Text("Select time",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 18)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final t in [
              "10:00",
              "11:00",
              "12:00",
              "13:00",
              "15:00",
              "16:00",
              "17:00",
              "18:00"
            ])
              ChoiceChip(
                label: Text(t),
                selected: t == "16:00",
                selectedColor: darkGreenColor,
                backgroundColor: whiteColor,
                labelStyle: TextStyle(
                  color: t == "16:00" ? whiteColor : blackColor,
                  fontWeight: FontWeight.w500,
                ),
                onSelected: (_) {},
              ),
          ],
        ),
      ],
    );
  }
}
