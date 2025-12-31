class DoctorReviewModel {
  final int? reviewId;
  final int doctorId;
  final int patientId;
  final int rating;
  final String comment;
  final String createdAt;

  DoctorReviewModel({
    this.reviewId,
    required this.doctorId,
    required this.patientId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory DoctorReviewModel.fromMap(Map<String, dynamic> map) =>
      DoctorReviewModel(
        reviewId: map['review_id'],
        doctorId: map['doctor_id'],
        patientId: map['patient_id'],
        rating: map['rating'],
        comment: map['comment'],
        createdAt: map['created_at'],
      );

  Map<String, dynamic> toMap() => {
        'review_id': reviewId,
        'doctor_id': doctorId,
        'patient_id': patientId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt,
      };
}
