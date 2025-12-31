class DoctorModel {
  final int doctorId;
  final int specialityId;
  final String bio;
  final String locationOfWork;
  final String degree;
  final String university;
  final String certification;
  final String institution;
  final String residency;
  final String licenseNumber;
  final String licenseDescription;
  final int yearsExperience;
  final String areasOfExpertise;
  final int pricePerHour;
  final double averageRating;
  final int reviewsCount;

  DoctorModel({
    required this.doctorId,
    required this.specialityId,
    required this.bio,
    required this.locationOfWork,
    required this.degree,
    required this.university,
    required this.certification,
    required this.institution,
    required this.residency,
    required this.licenseNumber,
    required this.licenseDescription,
    required this.yearsExperience,
    required this.areasOfExpertise,
    required this.pricePerHour,
    required this.averageRating,
    required this.reviewsCount,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) => DoctorModel(
        doctorId: map['doctor_id'],
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
        averageRating: (map['average_rating'] as num).toDouble(),
        reviewsCount: map['reviews_count'],
      );

  Map<String, dynamic> toMap() => {
        'doctor_id': doctorId,
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
