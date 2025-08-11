import 'package:caderno_do_campo/model/cultures_model.dart';
import 'package:caderno_do_campo/model/service/database/culture_db.dart';

import 'package:result_dart/result_dart.dart';

class CulturesRepository {
  final CultureServiceDatabase databaseService;

  CulturesRepository({required this.databaseService});

  AsyncResult<List<CulturesModel>> fetchCultures() async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final cultures = await databaseService.getAllCultures();
    await databaseService.close();

    return cultures.fold(
      (cultures) => Success(cultures),
      (error) => Failure(error),
    );
  }

  AsyncResult<bool> insertCulture(CulturesModel culture) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.insertCulture(culture);
    await databaseService.close();

    return result.fold((success) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> updateCulture(CulturesModel culture) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }
    final result = await databaseService.updateCulture(culture);
    await databaseService.close();

    return result.fold((success) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> deleteCulture(int id) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }
    final result = await databaseService.deleteCulture(id);
    await databaseService.close();

    return result.fold((success) => Success(true), (error) => Failure(error));
  }
}
