class SpecialityModel {
  final int? specialityId;
  final String specialityName;

  SpecialityModel({
    this.specialityId,
    required this.specialityName,
  });

  factory SpecialityModel.fromMap(Map<String, dynamic> map) => SpecialityModel(
        specialityId: map['speciality_id'],
        specialityName: map['speciality_name'],
      );

  Map<String, dynamic> toMap() => {
        'speciality_id': specialityId,
        'speciality_name': specialityName,
      };
}
