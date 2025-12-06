import 'doctors_abstract.dart';

class DoctorsDummy implements DoctorsRepo {
  List<Map<String, dynamic>> doctors = [
    {
      'doctor_id': 1,
      'speciality_id': 1,
      'bio': 'General practitioner with 5 years experience',
      'location_of_work': 'Algiers',
      'degree': 'MD',
      'university': 'USTHB',
      'certification': 'General Medicine',
      'institution': 'CHU Mustapha',
      'residency': 'Family Medicine',
      'license_number': 'DOC123',
      'license_description': 'Approved medical practitioner',
      'years_experience': 5,
      'areas_of_expertise': 'Primary care, consultations',
      'price_per_hour': 2500,
      'average_rating': 4.5,
      'reviews_count': 27
    },
    {
      'doctor_id': 2,
      'speciality_id': 2,
      'bio': 'Cardiologist specialized in heart diseases',
      'location_of_work': 'Oran',
      'degree': 'MD',
      'university': 'University of Oran',
      'certification': 'Cardiology',
      'institution': 'EHU Oran',
      'residency': 'Cardiology residency',
      'license_number': 'DOC789',
      'license_description': 'Certified cardiologist',
      'years_experience': 12,
      'areas_of_expertise': 'Heart surgery, monitoring',
      'price_per_hour': 4500,
      'average_rating': 4.8,
      'reviews_count': 54
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getDoctors() async {
    return doctors;
  }

  @override
  Future<int> addDoctor(Map<String, dynamic> data) async {
    data['doctor_id'] = doctors.length + 1;
    doctors.add(data);
    return 1;
  }

  @override
  Future<int> updateDoctor(int id, Map<String, dynamic> data) async {
    final index = doctors.indexWhere((e) => e['doctor_id'] == id);
    if (index != -1) {
      doctors[index] = {...doctors[index], ...data};
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteDoctor(int id) async {
    doctors.removeWhere((e) => e['doctor_id'] == id);
    return 1;
  }

  @override
  Future<Map<String, dynamic>?> getDoctorById(int id) async {
    return doctors.firstWhere(
      (d) => d['doctor_id'] == id,
      orElse: () => {},
    );
  }
}
