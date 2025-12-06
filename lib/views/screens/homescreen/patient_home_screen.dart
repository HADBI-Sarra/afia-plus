import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/search_text_fields.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';
import 'package:afia_plus_app/views/widgets/doctor_card.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  Widget sectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Text(
          'See all',
          style: greenLink,
        ),
      ],
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required String date,
    required String imagePath,
  }) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: greyColor,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: blackColor)),
                    Text(specialty,
                        style: const TextStyle(color: greyColor, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: greyColor),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 18, color: darkGreenColor),
              const SizedBox(width: 6),
              Text(date,
                  style: const TextStyle(color: greyColor, fontSize: 13)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: const Size(95, 42),
                ),
                child: const Text('WhatsApp',
                    style: TextStyle(color: whiteColor, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget specialityLink(String name, int number) {
    return ElevatedButton(
      onPressed: () {},
      style: whiteButtonStyle,
      child: Row(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Spacer(),
          Text(
            "$number doctors",
            style: TextStyle(color: greyColor),
          )
        ],
      ),
    );
  }

  Widget seviceLink(String name) {
    return ElevatedButton(
      onPressed: () {},
      style: whiteButtonStyle,
      child: Row(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Spacer(),
          const Icon(Icons.arrow_outward_rounded),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const Icon(
            Icons.arrow_back_ios_new,
            color: greyColor,
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              // Show loading until the patient data is fully loaded
              if (authState is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (authState is AuthenticatedPatient) {
                final patient = authState.patient;
                final patientName =
                    (patient.firstname.isNotEmpty) ? patient.firstname : 'Patient';

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello $patientName!',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 20),
                              SearchTextField(hint: 'Start typing'),
                              const SizedBox(height: 20),
                              sectionTitle('Coming consultations'),
                              const SizedBox(height: 20),
                              _buildDoctorCard(
                                name: 'Dr. Mohamed Brahimi',
                                specialty: 'Cardiologist',
                                date: '12 Nov, 12:00 - 12:45',
                                imagePath: 'assets/images/doctorBrahimi.png',
                              ),
                              const SizedBox(height: 20),
                              sectionTitle('Popular specializations'),
                              const SizedBox(height: 20),
                              specialityLink('Dentist', 21),
                              const SizedBox(height: 10),
                              specialityLink('Pulmonologist', 19),
                              const SizedBox(height: 10),
                              specialityLink('Gastroenterologist', 8),
                              const SizedBox(height: 10),
                              specialityLink('Cardiologist', 15),
                              const SizedBox(height: 20),
                              sectionTitle('Popular doctors'),
                              const SizedBox(height: 20),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DoctorCard(
                                          imagePath: null,
                                          name: 'Dr. Yousfi Slimane',
                                          specialty: 'Gynecologyst',
                                          rating: 0.0,
                                          onTap: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: DoctorCard(
                                          imagePath: null,
                                          name: 'Dr. Foudad Riad',
                                          specialty: 'Urologist',
                                          rating: 0.0,
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DoctorCard(
                                          imagePath: null,
                                          name: 'Dr. Maryam Akli',
                                          specialty: 'Dermatologist',
                                          rating: 0.0,
                                          onTap: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: DoctorCard(
                                          imagePath: null,
                                          name: 'Dr. Kaouache Antr',
                                          specialty: 'Dentist',
                                          rating: 0.0,
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Services',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 20),
                              seviceLink('Appointments'),
                              const SizedBox(height: 10),
                              seviceLink('Prescriptions'),
                              const SizedBox(height: 10),
                              seviceLink('FAQ'),
                              const SizedBox(height: 20),
                              const UserFooter(currentIndex: 0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Not authenticated
                return const Center(child: Text('User not logged in'));
              }
            },
          ),
        ),
      ),
    );
  }
}
