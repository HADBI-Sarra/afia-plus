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
    return Doctor(
      userId: map['user_id'],
      role: map['role'] ?? 'doctor',
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phone_number'],
      nin: map['nin'],
      profilePicture: map['profile_picture'],
      specialityId: map['speciality_id'],
      bio: map['bio'],
      locationOfWork: map['location_of_work'],
      degree: map['degree'],
      university: map['university'],
      certification: map['certification'],
      institution: map['institution'],
      residency: map['residency'],
      licenseNumber: map['license_number'],
      licenseDescription: map['license_description'],
      yearsExperience: map['years_experience'],
      areasOfExpertise: map['areas_of_expertise'],
      pricePerHour: map['price_per_hour'],
      averageRating: map['average_rating']?.toDouble() ?? 0.0,
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