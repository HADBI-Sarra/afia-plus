import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/search_text_fields.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';
import 'package:afia_plus_app/data/db_helper.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_users_view.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}


class _PatientHomeScreenState extends State<PatientHomeScreen> {
  List<Map<String, dynamic>> topSpecialities = [];
  bool showAllSpecialities = false;
  List<Map<String, dynamic>> allSpecialities = [];
  List<Map<String, dynamic>> doctorsForSpeciality = [];
  String? selectedSpecialityName;

  @override
  void initState() {
    super.initState();
    _loadSpecialities();
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
  
  Future<void> _loadSpecialities() async {
    final db = DBHelper();
    final top = await db.getTopSpecialities(4); // first 4 default
    final all = await db.getSpecialitiesWithDoctorCount(); // all specialities

    setState(() {
      topSpecialities = top;
      allSpecialities = all;
    });
  }

  List<Map<String, dynamic>> get remainingSpecialities {
    if (topSpecialities.isEmpty) return [];
    final topIds = topSpecialities.map((s) => s['speciality_id'] as int).toSet();
    return allSpecialities.where((s) => !topIds.contains(s['speciality_id'])).toList();
  }

  Future<void> _loadDoctorsForSpeciality(int specialityId, String specialityName) async {
    final db = DBHelper();
    final docs = await db.getDoctorsBySpeciality(specialityId);
    setState(() {
      doctorsForSpeciality = docs;
      selectedSpecialityName = specialityName;
    });
  }

  IconData _getSpecialityIcon(String specialityName) {
    switch (specialityName.toLowerCase()) {
      case 'dentist':
        return Icons.medical_services;
      case 'pulmonologist':
        return Icons.air;
      case 'gastroenterologist':
        return Icons.food_bank;
      case 'cardiologist':
        return Icons.favorite;
      default:
        return Icons.local_hospital;
    }
  }

  Widget sectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text('See all', style: greenLink),
          ),
      ],
    );
  }

  Widget specialityLink(Map<String, dynamic> speciality) {
    final String name = speciality['speciality_name'];
    final int doctorCount = speciality['doctor_count'] ?? 0;
    final int specialityId = speciality['speciality_id'];

    return ElevatedButton(
      onPressed: () {
        _loadDoctorsForSpeciality(specialityId, name);
      },
      style: whiteButtonStyle,
      child: Row(
        children: [
          Icon(_getSpecialityIcon(name), size: 20, color: darkGreenColor),
          const SizedBox(width: 10),
          Text(name, style: Theme.of(context).textTheme.labelMedium),
          const Spacer(),
          Text("$doctorCount doctors", style: const TextStyle(color: greyColor)),
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
          Text(name, style: Theme.of(context).textTheme.labelMedium),
          const Spacer(),
          const Icon(Icons.arrow_outward_rounded),
        ],
      ),
    );
  }

  Widget _buildDoctorsCardOverlay() {
    if (doctorsForSpeciality.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: greyColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header with return button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: greyColor.withOpacity(0.2)),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: darkGreenColor),
                        onPressed: () {
                          setState(() {
                            doctorsForSpeciality = [];
                            selectedSpecialityName = null;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Doctors - $selectedSpecialityName',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Doctors list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: doctorsForSpeciality.map((doctor) {
                      final String firstName = doctor['firstname'] ?? '';
                      final String lastName = doctor['lastname'] ?? '';
                      final String fullName = '$firstName $lastName';
                      final String address = doctor['location_of_work'] ?? 'Address not available';
                      final int doctorId = doctor['doctor_id'];
                      final String specialty = doctor['speciality_name'] ?? selectedSpecialityName ?? '';
                      final double rating = (doctor['average_rating'] as num?)?.toDouble() ?? 0.0;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorProfileScreen(
                                doctorId: doctorId,
                                doctorName: fullName,
                                doctorSpeciality: specialty,
                                rating: rating > 0 ? rating.toStringAsFixed(1) : '0.0',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: greyColor.withOpacity(0.2)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dr. $fullName',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: blackColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16, color: greyColor),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            address,
                                            style: const TextStyle(
                                              color: greyColor,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: greyColor),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          leading: const Icon(Icons.arrow_back_ios_new, color: greyColor),
        ),
        body: SafeArea(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (authState is AuthenticatedPatient) {
                final patient = authState.patient;
                final patientName =
                    (patient.firstname.isNotEmpty) ? patient.firstname : 'Patient';

                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hello $patientName!', style: Theme.of(context).textTheme.titleLarge),
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
                            sectionTitle(
                              'Popular specializations',
                              onSeeAll: showAllSpecialities ? null : () {
                                setState(() {
                                  showAllSpecialities = true;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            // Show first 4 specialities
                            ...topSpecialities.map((s) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: specialityLink(s),
                                )),
                            // Show remaining specialities when "See all" is clicked
                            if (showAllSpecialities)
                              ...remainingSpecialities.map((s) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: specialityLink(s),
                                  )),
                            const SizedBox(height: 20),
                            sectionTitle('Popular doctors'),
                            const SizedBox(height: 20),
                            // Your popular doctors layout remains the same
                            // ...
                            Text('Services', style: Theme.of(context).textTheme.titleMedium),
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
                    // Overlay doctors card on top
                    _buildDoctorsCardOverlay(),
                  ],
                );
              } else {
                return const Center(child: Text('User not logged in'));
              }
            },
          ),
        ),
      ),
    );
  }
}
