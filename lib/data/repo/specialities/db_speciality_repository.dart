import 'package:afia_plus_app/data/db_helper.dart';
import '../../models/speciality.dart';
import 'speciality_repository.dart';

class DBSpecialityRepository implements SpecialityRepository {

  @override
  Future<List<Speciality>> getAllSpecialities() async {
    final db = await DBHelper.getDatabase();
    final results = await db.query(
      'specialities',
      orderBy: 'speciality_name',
    );

    return results.map((e) => Speciality.fromMap(e)).toList();
  }

  @override
  Future<Speciality?> getSpecialityById(int id) async {
    final db = await DBHelper.getDatabase();

    final result = await db.query(
      'specialities',
      where: 'speciality_id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Speciality.fromMap(result.first);
    }
    return null;
  }
}
