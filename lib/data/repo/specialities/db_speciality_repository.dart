import 'package:afia_plus_app/data/db_helper.dart';
import '../../models/speciality.dart';
import 'speciality_repository.dart';

class DBSpecialityRepository implements SpecialityRepository {

  @override
  Future<List<Speciality>> getAllSpecialities() async {
    try {
      print('Getting database connection...');
      final db = await DBHelper.getDatabase();
      print('Database connection successful');
      
      print('Querying specialities table...');
      final results = await db.query(
        'specialities',
        orderBy: 'speciality_name',
      );
      
      print('Query returned ${results.length} rows');
      
      final specialities = results.map((e) {
        print('Mapping row: $e');
        return Speciality.fromMap(e);
      }).toList();
      
      print('Mapped ${specialities.length} specialities');
      return specialities;
    } catch (e, stackTrace) {
      print('Error in getAllSpecialities: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  @override
  Future<Speciality?> getSpecialityById(int id) async {
    try {
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
    } catch (e) {
      print('Error in getSpecialityById: $e');
      return null;
    }
  }
}