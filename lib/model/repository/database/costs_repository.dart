import 'package:caderno_do_campo/model/costs_model.dart';
import 'package:caderno_do_campo/model/service/database/costs_db.dart';
import 'package:result_dart/result_dart.dart';

class CostsRepository {
  final CostsServiceDatabase databaseService;

  CostsRepository({required this.databaseService});

  AsyncResult<List<CostsModel>> fetchCosts() async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final costs = await databaseService.getAllCosts();
    await databaseService.close();

    return costs.fold((costs) => Success(costs), (error) => Failure(error));
  }

  AsyncResult<bool> insertCost(CostsModel cost) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.insertCost(cost);
    await databaseService.close();

    return result.fold((_) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> updateCost(CostsModel cost) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.updateCost(cost);
    await databaseService.close();

    return result.fold((_) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> deleteCost(int id) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.deleteCost(id);
    await databaseService.close();

    return result.fold((_) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> deleteAllCosts() async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.deleteAllCosts();
    await databaseService.close();

    return result.fold((success) => Success(true), (error) => Failure(error));
  }
}
