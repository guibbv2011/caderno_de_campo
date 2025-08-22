import 'package:caderno_do_campo/model/registers_model.dart';
import 'package:caderno_do_campo/model/service/database/registers_db.dart';
import 'package:result_dart/result_dart.dart';

class RegistersRepository {
  final RegistersServiceDatabase databaseService;

  RegistersRepository({required this.databaseService});

  AsyncResult<List<RegistersModel>> fetchRegisters() async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final registers = await databaseService.getAllRegisters();
    await databaseService.close();

    return registers.fold(
      (registers) => Success(registers),
      (error) => Failure(error),
    );
  }

  AsyncResult<bool> insertRegister(RegistersModel register) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.insertRegister(register);
    await databaseService.close();

    return result.fold((_) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> updateRegister(RegistersModel register) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.updateRegister(register);
    await databaseService.close();

    return result.fold((_) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> deleteRegister(int id) async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.deleteRegister(id);
    await databaseService.close();

    return result.fold((_) => Success(true), (error) => Failure(error));
  }

  AsyncResult<bool> deleteAllRegisters() async {
    if (!databaseService.isOpen()) {
      await databaseService.open();
    }

    final result = await databaseService.deleteAllRegisters();
    await databaseService.close();

    return result.fold((success) => Success(true), (error) => Failure(error));
  }
}
