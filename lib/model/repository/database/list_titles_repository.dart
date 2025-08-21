import 'package:caderno_do_campo/model/repository/database/areas_repository.dart';
import 'package:caderno_do_campo/model/repository/database/cultures_repository.dart';
import 'package:caderno_do_campo/model/service/database/areas_db.dart';
import 'package:caderno_do_campo/model/service/database/culture_db.dart';
import 'package:result_dart/result_dart.dart';

class ListTitlesRepository {
  AsyncResult<List<String>> getCulturesTitles() async {
    final CultureServiceDatabase cultureService = CultureServiceDatabase();
    final cultures = await CulturesRepository(
      databaseService: cultureService,
    ).fetchCultures();

    List<String> ct = <String>[];

    return cultures.fold((value) {
      for (var v in value) {
        ct.add(v.name!);
      }
      return Success(ct);
    }, (error) => Failure(Exception(error)));
  }

  AsyncResult<List<String>> getAreasTitles() async {
    final AreasServiceDatabase areaService = AreasServiceDatabase();
    final areas = await AreasRepository(
      databaseService: areaService,
    ).fetchAreas();

    List<String> at = <String>[];

    return areas.fold((value) {
      for (var v in value) {
        at.add(v.name!);
      }
      return Success(at);
    }, (error) => Failure(Exception(error)));
  }
}
