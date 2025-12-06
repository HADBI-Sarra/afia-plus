class Speciality {
  final int id;
  final String name;

  Speciality({required this.id, required this.name});

  factory Speciality.fromMap(Map<String, dynamic> map) {
    return Speciality(
      id: map['speciality_id'],
      name: map['speciality_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'speciality_id': id,
      'speciality_name': name,
    };
  }
}
