import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  Widget _buildPrescriptionCard({
    required String doctor,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.80),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkGreenColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              doctor,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: blackColor,
              ),
            ),
            subtitle: Text(
              date,
              style: const TextStyle(fontSize: 14, color: greyColor),
            ),
            trailing: const Icon(Icons.more_vert, color: greyColor),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded, color: darkGreenColor),
              label: const Text(
                "Download Prescription",
                style: TextStyle(
                  color: darkGreenColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: darkGreenColor, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientBackgroundDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                          "My Prescriptions",
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 10),

                _buildPrescriptionCard(
                  doctor: "Dr. Brahimi Mohamed",
                  date: "18 September, 2025",
                ),
                _buildPrescriptionCard(
                  doctor: "Dr. Lakhal Amine",
                  date: "17 March, 2025",
                ),
                _buildPrescriptionCard(
                  doctor: "Dr. Moussaoui Samia",
                  date: "02 January, 2025",
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: const UserFooter(currentIndex: 2),
    );
  }
}
