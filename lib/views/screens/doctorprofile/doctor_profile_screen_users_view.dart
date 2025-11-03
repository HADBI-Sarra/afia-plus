import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/doctor_about_tab.dart';
import 'package:afia_plus_app/views/widgets/doctor_book_tab.dart';
import 'package:afia_plus_app/views/widgets/doctor_reviews_tab.dart';

class DoctorProfileScreen extends StatefulWidget {
  final doctorName = "Yousfi Slimane";
  final doctorSpeciality = "Gynecologist";
  final rating = "4.9";
  static const routename = "/userViewDoctorProfile";
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int selectedTab = 0; // 0 = Book, 1 = About, 2 = Reviews

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Doctor Profile",
            style: TextStyle(
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
                // --- Header: Name + Specialty + Rating + Image ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Dr.${widget.doctorName}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.doctorSpeciality,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: greyColor),
                          ),
                          const SizedBox(height: 15),
                          // Rating
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.grade_rounded, color: greenColor, size: 16),
                                const SizedBox(width: 4),
                                Text(widget.rating,
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/yousfi.jpg',
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // --- Tabs ---
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTab = 0),
                        child: Column(
                          children: [
                            Text(
                              "Book",
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: selectedTab == 0 ? darkGreenColor : blackColor),
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
                            "About",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: selectedTab == 1 ? darkGreenColor : blackColor),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTab = 2),
                        child: Center(
                          child: Text(
                            "Reviews",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: selectedTab == 2 ? darkGreenColor : blackColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // --- Scrollable Content ---
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (selectedTab == 0)
                          const DoctorBookTab(), // build your Book tab content here
                        if (selectedTab == 1)
                          const DoctorAboutTab(), // About tab content
                        if (selectedTab == 2)
                          const DoctorReviewsTab(), // Reviews tab content
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Book Appointment Button (always visible) ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Book appointment",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
