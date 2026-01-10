import 'user.dart';

class Patient extends User {
  final String? emailConfirmedAt;
  final String dateOfBirth;

  Patient({
    int? userId,
    required String role,
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String phoneNumber,
    required String nin,
    String? profilePicture,
    required this.dateOfBirth,
    this.emailConfirmedAt,
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

  factory Patient.fromMap(Map<String, dynamic> map) {
    // Supports Supabase's email_confirmed_at key, might be null or String ISO8601
    return Patient(
      userId: map['user_id'],
      role: map['role'] ?? 'patient',
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phone_number'],
      nin: map['nin'],
      profilePicture: map['profile_picture'],
      dateOfBirth: map['date_of_birth'] ?? '',
      emailConfirmedAt: map['email_confirmed_at']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'date_of_birth': dateOfBirth,
    };
  }

  /// Returns true if email is verified (email_confirmed_at is not null)
  bool get isEmailVerified => emailConfirmedAt != null && emailConfirmedAt!.isNotEmpty;

  Patient copyWith({
    int? userId,
    String? role,
    String? firstname,
    String? lastname,
    String? email,
    String? password,
    String? phoneNumber,
    String? nin,
    String? profilePicture,
    String? dateOfBirth,
    String? emailConfirmedAt,
  }) {
    return Patient(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nin: nin ?? this.nin,
      profilePicture: profilePicture ?? this.profilePicture,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emailConfirmedAt: emailConfirmedAt ?? this.emailConfirmedAt,
    );
  }
}