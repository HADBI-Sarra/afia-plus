class Review {
  final int? reviewId;
  final int doctorId;
  final int patientId;
  final int rating;
  final String? comment;
  final String? createdAt;
  final String? patientName; // Optional: for display purposes

  Review({
    this.reviewId,
    required this.doctorId,
    required this.patientId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.patientName,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewId: map['review_id'],
      doctorId: map['doctor_id'],
      patientId: map['patient_id'],
      rating: map['rating'],
      comment: map['comment'],
      createdAt: map['created_at'],
      patientName: map['patient_name'], // If joined with patients table
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'review_id': reviewId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
    };
  }
}
