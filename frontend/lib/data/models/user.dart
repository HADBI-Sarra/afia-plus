class User {
  final int? userId;
  final String role;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String phoneNumber;
  final String nin;
  final String? profilePicture;

  User({
    this.userId,
    required this.role,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.nin,
    this.profilePicture,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'],
      role: map['role'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '', // Password not stored in DB, use empty string
      phoneNumber: map['phone_number'] ?? '',
      nin: map['nin'] ?? '',
      profilePicture: map['profile_picture'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'role': role,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'nin': nin,
      'profile_picture': profilePicture,
    };
  }
}
