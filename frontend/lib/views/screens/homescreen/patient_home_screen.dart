import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/search_text_fields.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';
import 'package:afia_plus_app/data/db_helper.dart';
import 'package:afia_plus_app/data/api/api_client.dart';
import 'dart:convert';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/views/screens/doctorprofile/doctor_profile_screen_users_view.dart';
import 'package:afia_plus_app/views/widgets/doctor_card.dart';
import 'package:afia_plus_app/cubits/patient_home_cubit.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/utils/whatsapp_service.dart';
import 'package:afia_plus_app/views/widgets/language_switcher.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  // optional display name used in part of UI
  final String name = "Besmala";

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  // Local UI state (specialities overlay etc.)
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

  // -----------------------
  // Data loading helpers
  // -----------------------
  Future<void> _loadSpecialities() async {
    try {
      // Call backend API to get top 4 specialities
      final response = await ApiClient.get('/doctors/specialities');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> specialities = data
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        if (!mounted) return;
        setState(() {
          topSpecialities = specialities;
        });

        // Load all specialities for "See all" functionality
        final allResponse = await ApiClient.get('/doctors/specialities?all=true');
        if (allResponse.statusCode == 200) {
          final List<dynamic> allData = jsonDecode(allResponse.body);
          final List<Map<String, dynamic>> allSpecialitiesList = allData
              .map((item) => Map<String, dynamic>.from(item))
              .toList();

          if (!mounted) return;
          setState(() {
            allSpecialities = allSpecialitiesList;
          });
        }
      } else {
        print('Error loading specialities: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error loading specialities: $e');
    }
  }

  List<Map<String, dynamic>> get remainingSpecialities {
    if (topSpecialities.isEmpty) return [];
    final topIds = topSpecialities
        .map((s) => s['speciality_id'] as int)
        .toSet();
    return allSpecialities
        .where((s) => !topIds.contains(s['speciality_id']))
        .toList();
  }

  Future<void> _loadDoctorsForSpeciality(
    int specialityId,
    String specialityName,
  ) async {
    try {
      // Call backend API to get doctors by speciality
      final response = await ApiClient.get('/doctors/by-speciality?speciality_id=$specialityId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> doctors = data
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        if (!mounted) return;
        setState(() {
          doctorsForSpeciality = doctors;
          selectedSpecialityName = specialityName;
        });
      } else {
        print('Error loading doctors: ${response.statusCode}');
        if (!mounted) return;
        setState(() {
          doctorsForSpeciality = [];
          selectedSpecialityName = specialityName;
        });
      }
    } catch (e) {
      print('Error loading doctors: $e');
      if (!mounted) return;
      setState(() {
        doctorsForSpeciality = [];
        selectedSpecialityName = specialityName;
      });
    }
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

  // -----------------------
  // UI building helpers
  // -----------------------
  Widget sectionTitle(
    BuildContext context,
    String title, {
    VoidCallback? onSeeAll,
  }) {
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

  // speciality button from DB map
  Widget specialityButtonFromMap(Map<String, dynamic> speciality) {
    final String name = speciality['speciality_name'] ?? '';
    final int doctorCount = (speciality['doctor_count'] as num?)?.toInt() ?? 0;
    final int specialityId = (speciality['speciality_id'] as num?)?.toInt() ?? 0;
    return specialityButton(name, doctorCount, specialityId: specialityId);
  }

  // Generic speciality button
  Widget specialityButton(String name, int number, {int? specialityId}) {
    return ElevatedButton(
      onPressed: () {
        if (specialityId != null) {
          _loadDoctorsForSpeciality(specialityId, name);
        } else {
          // If no id provided, do nothing or show all
          setState(() {
            showAllSpecialities = true;
          });
        }
      },
      style: whiteButtonStyle,
      child: Row(
        children: [
          Icon(_getSpecialityIcon(name), size: 20, color: darkGreenColor),
          const SizedBox(width: 10),
          Text(name, style: Theme.of(context).textTheme.labelMedium),
          const Spacer(),
          Text("$number doctors", style: const TextStyle(color: greyColor)),
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

  Widget _buildDoctorCardFromConsultation({
    required BuildContext context,
    required ConsultationWithDetails consultation,
    required int patientId,
  }) {
    // Default image path - you can enhance this with actual doctor image from DB
    String imagePath = 'assets/images/doctorBrahimi.png';
    if (consultation.doctorImagePath != null) {
      imagePath = consultation.doctorImagePath!;
    }

    return _buildDoctorCard(
      context: context,
      consultation: consultation,
      name: 'Dr. ${consultation.doctorFullName}',
      specialty:
          consultation.doctorSpecialty ??
          AppLocalizations.of(context)!.specialist,
      date: consultation.formattedDate,
      imagePath: imagePath,
      phoneNumber: consultation.doctorPhoneNumber,
      patientId: patientId,
    );
  }

  Widget _buildDoctorCard({
    required BuildContext context,
    required ConsultationWithDetails consultation,
    required String name,
    required String specialty,
    required String date,
    required String imagePath,
    String? phoneNumber,
    required int patientId,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 24, backgroundImage: AssetImage(imagePath)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: const TextStyle(color: greyColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Delete button with loading indication via PatientHomeCubit
              BlocBuilder<PatientHomeCubit, PatientHomeState>(
                builder: (context, state) {
                  final isDeleting =
                      consultation.consultation.consultationId != null &&
                      state.deletingConsultationIds.contains(
                        consultation.consultation.consultationId,
                      );

                  return isDeleting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              darkGreenColor,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: greyColor,
                            size: 24,
                          ),
                          onPressed: () {
                            if (consultation.consultation.consultationId !=
                                null) {
                              _showDeleteConfirmationDialog(
                                context: context,
                                consultation: consultation,
                                patientId: patientId,
                              );
                            }
                          },
                        );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: darkGreenColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  if (phoneNumber != null && phoneNumber.isNotEmpty) {
                    final success = await WhatsAppService.openWhatsApp(
                      phoneNumber: phoneNumber,
                      message: AppLocalizations.of(context)!
                          .whatsappMessageDoctor(
                            consultation.doctorFullName,
                            date,
                          ),
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.whatsappError,
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(
                              context,
                            )!.doctorPhoneNumberNotAvailable,
                          ),
                          backgroundColor: Colors.orange,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: const Size(100, 36),
                ),
                child: Text(
                  AppLocalizations.of(context)!.whatsapp,
                  style: const TextStyle(color: whiteColor, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // overlay panel that lists doctors for a chosen speciality
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
                        icon: const Icon(
                          Icons.arrow_back,
                          color: darkGreenColor,
                        ),
                        onPressed: () {
                          setState(() {
                            doctorsForSpeciality = [];
                            selectedSpecialityName = null;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Doctors - ${selectedSpecialityName ?? ''}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
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
                      final String address =
                          doctor['location_of_work'] ?? 'Address not available';
                      final int doctorId = doctor['doctor_id'];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorProfileScreen(doctorId: doctorId),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: greyColor.withOpacity(0.2),
                              ),
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
                                        const Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: greyColor,
                                        ),
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

  // -----------------------
  // Main build
  // -----------------------
  @override
  Widget build(BuildContext context) {
    // Provide PatientHomeCubit with the authenticated patientId
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthenticatedPatient) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }
    final patientId = authState.patient.userId!;

    return BlocProvider(
      create: (ctx) => PatientHomeCubit()..loadUpcomingConsultations(patientId),
      child: Container(
        decoration: gradientBackgroundDecoration,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: const Icon(Icons.arrow_back_ios_new, color: greyColor),
            actions: const [LanguageSwitcher(), SizedBox(width: 8)],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                // Main content listens to AuthCubit to decide which UI to show
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    if (authState is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (authState is AuthenticatedPatient) {
                      final patient = authState.patient;
                      final patientName = (patient.firstname.isNotEmpty)
                          ? patient.firstname
                          : 'Patient';

                      return SingleChildScrollView(
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
                              // Upcoming consultations (from PatientHomeCubit)
                              sectionTitle(context, 'Coming consultations'),
                              const SizedBox(height: 20),
                              BlocBuilder<PatientHomeCubit, PatientHomeState>(
                                builder: (context, state) {
                                  if (state.isLoading) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  if (state.error != null) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        'Error loading consultations',
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    );
                                  }

                                  if (state.upcomingConsultations.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Text(
                                        'No upcoming consultations',
                                        style: TextStyle(color: greyColor),
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: state.upcomingConsultations
                                        .map(
                                          (consultation) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                            ),
                                            child:
                                                _buildDoctorCardFromConsultation(
                                                  context: context,
                                                  consultation: consultation,
                                                  patientId: patientId,
                                                ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              sectionTitle(
                                context,
                                'Popular specializations',
                                onSeeAll: () {
                                  setState(() {
                                    showAllSpecialities = true;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              // Show first 4 specialities (or less)
                              ...topSpecialities.map(
                                (s) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: specialityButtonFromMap(s),
                                ),
                              ),
                              // Show remaining specialities when "See all" is clicked
                              if (showAllSpecialities)
                                ...remainingSpecialities.map(
                                  (s) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: specialityButtonFromMap(s),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              sectionTitle(context, 'Popular doctors'),
                              const SizedBox(height: 20),
                              // Example popular doctors layout (static cards)
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
                      );
                    } else {
                      return const Center(child: Text('User not logged in'));
                    }
                  },
                ),

                // doctors overlay (on top)
                _buildDoctorsCardOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------
  // Delete confirmation dialog
  // -----------------------
  void _showDeleteConfirmationDialog({
    required BuildContext context,
    required ConsultationWithDetails consultation,
    required int patientId,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.cancelAppointment,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.areYouSureCancelAppointment,
                style: const TextStyle(
                  fontSize: 16,
                  color: blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 18,
                          color: darkGreenColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dr. ${consultation.doctorFullName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: darkGreenColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          consultation.formattedDate,
                          style: const TextStyle(
                            fontSize: 14,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                    if (consultation.doctorSpecialty != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.medical_services,
                            size: 18,
                            color: darkGreenColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            consultation.doctorSpecialty!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.thisActionCannotBeUndone,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(context)!.keepAppointment,
                style: const TextStyle(
                  color: greyColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (consultation.consultation.consultationId != null) {
                  context.read<PatientHomeCubit>().deleteAppointment(
                    consultation.consultation.consultationId!,
                    patientId,
                  );
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.appointmentCancelled,
                      ),
                      backgroundColor: darkGreenColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.cancelAppointment,
                style: const TextStyle(
                  color: whiteColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
