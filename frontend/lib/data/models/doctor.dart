import 'user.dart';

class Doctor extends User {
  final int? specialityId;
  final String? bio;
  final String? locationOfWork;
  final String? degree;
  final String? university;
  final String? certification;
  final String? institution;
  final String? residency;
  final String? licenseNumber;
  final String? licenseDescription;
  final int? yearsExperience;
  final String? areasOfExpertise;
  final int? pricePerHour;
  final double averageRating;
  final int reviewsCount;

  Doctor({
    int? userId,
    required String role,
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String phoneNumber,
    required String nin,
    String? profilePicture,
    this.specialityId,
    this.bio,
    this.locationOfWork,
    this.degree,
    this.university,
    this.certification,
    this.institution,
    this.residency,
    this.licenseNumber,
    this.licenseDescription,
    this.yearsExperience,
    this.areasOfExpertise,
    this.pricePerHour,
    this.averageRating = 0,
    this.reviewsCount = 0,
  }) : super(
    userId: userId,
    role: role,
    firstname: firstname,
    lastname: lastname,
    email: email,
    password: password,
    phoneNumber: phoneNumber,
    nin: nin,
    profilePicture: profilePicture,
  );

  factory Doctor.fromMap(Map<String, dynamic> map) {
    // Handle speciality_id conversion - it might come as int, string, or null
    int? parseSpecialityId(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed != null && parsed > 0 ? parsed : null;
      }
      return null;
    }

    // Handle years_experience conversion
    int? parseYearsExperience(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    // Handle price_per_hour conversion
    int? parsePricePerHour(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Doctor(
      userId: map['user_id'],
      role: map['role'] ?? 'doctor',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      // Password is not returned by backend for safety; keep empty string if missing
      password: map['password'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      nin: map['nin'] ?? '',
      profilePicture: map['profile_picture'],
      specialityId: parseSpecialityId(map['speciality_id']),
      bio: map['bio'],
      locationOfWork: map['location_of_work'],
      degree: map['degree'],
      university: map['university'],
      certification: map['certification'],
      institution: map['institution'],
      residency: map['residency'],
      licenseNumber: map['license_number'],
      licenseDescription: map['license_description'],
      yearsExperience: parseYearsExperience(map['years_experience']),
      areasOfExpertise: map['areas_of_expertise'],
      pricePerHour: parsePricePerHour(map['price_per_hour']),
      averageRating: (map['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: map['reviews_count'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'speciality_id': specialityId,
      'bio': bio,
      'location_of_work': locationOfWork,
      'degree': degree,
      'university': university,
      'certification': certification,
      'institution': institution,
      'residency': residency,
      'license_number': licenseNumber,
      'license_description': licenseDescription,
      'years_experience': yearsExperience,
      'areas_of_expertise': areasOfExpertise,
      'price_per_hour': pricePerHour,
      'average_rating': averageRating,
      'reviews_count': reviewsCount,
    };
  }
}