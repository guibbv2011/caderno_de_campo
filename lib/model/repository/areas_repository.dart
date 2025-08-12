import 'package:caderno_do_campo/model/areas_model.dart';
import 'package:caderno_do_campo/model/service/database/areas_db.dart';
import 'package:result_dart/result_dart.dart';

class AreasRepository {
  final AreasServiceDatabase databaseService;

  AreasRepository({required this.databaseService});

  AsyncResult<List<AreasModel>> fetchAreas() async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final areas = await databaseService.getAllAreas();
    await databaseService.close();

    return areas.fold((areas) => Success(areas), (error) => Failure(error));
  }

  AsyncResult<bool> insertArea(AreasModel area) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.insertArea(area);
    await databaseService.close();

    return result.fold((success) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> updateArea(AreasModel area) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }
    final result = await databaseService.updateArea(area);
    await databaseService.close();

    return result.fold((success) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> deleteArea(int id) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }
    final result = await databaseService.deleteArea(id);
    await databaseService.close();

    return result.fold((success) => Success(true), (error) => Failure(error));
  }
}
