import 'package:caderno_do_campo/model/registers_model.dart';
import 'package:caderno_do_campo/model/repository/database/registers_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:result_command/result_command.dart';

class RegistersViewModel extends ChangeNotifier {
  final RegistersRepository registersRepository;
  late final Command0<List<RegistersModel>> fetchRegistersCommand;
  late final Command1<bool, RegistersModel> insertRegisterCommand;
  late final Command1<bool, RegistersModel> updateRegisterCommand;
  late final Command1<bool, int> deleteRegisterCommand;
  late final Command0<bool> deleteAllRegistersCommand;

  RegistersModel register = RegistersModel();
  List<RegistersModel> registers = [];
  String? errorMessage;
  bool isLoading = false;

  RegistersViewModel({required this.registersRepository}) {
    fetchRegistersCommand = Command0<List<RegistersModel>>(() async {
      final result = await registersRepository.fetchRegisters();
      return result.onSuccess((registers) => registers);
    });

    insertRegisterCommand = Command1<bool, RegistersModel>((register) async {
      final result = await registersRepository.insertRegister(register);
      return result.onSuccess((_) => true);
    });

    updateRegisterCommand = Command1<bool, RegistersModel>((register) async {
      final result = await registersRepository.updateRegister(register);
      return result.onSuccess((_) => true);
    });

    deleteRegisterCommand = Command1<bool, int>((id) async {
      final result = await registersRepository.deleteRegister(id);
      return result.onSuccess((_) => true);
    });

    deleteAllRegistersCommand = Command0<bool>(() async {
      final result = await registersRepository.deleteAllRegisters();
      return result.onSuccess((_) => true);
    });

    fetchRegistersCommand.addListener(_onFetchRegisters);
    insertRegisterCommand.addListener(_onInsertRegister);
    updateRegisterCommand.addListener(_onUpdateRegister);
    deleteRegisterCommand.addListener(_onDeleteRegister);
    deleteAllRegistersCommand.addListener(_onDeleteAllRegisters);
  }

  void _onFetchRegisters() {
    final state = fetchRegistersCommand.value;
    if (state is SuccessCommand<List<RegistersModel>>) {
      registers = state.value;
      errorMessage = null;
      isLoading = false;
    } else if (state is FailureCommand<List<RegistersModel>>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<List<RegistersModel>>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onInsertRegister() {
    final state = insertRegisterCommand.value;
    if (state is SuccessCommand<bool>) {
      errorMessage = null;
      isLoading = false;
      fetchRegistersCommand.execute();
    } else if (state is FailureCommand<bool>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onUpdateRegister() {
    final state = updateRegisterCommand.value;
    if (state is SuccessCommand<bool>) {
      errorMessage = null;
      isLoading = false;
      fetchRegistersCommand.execute();
    } else if (state is FailureCommand<bool>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onDeleteRegister() {
    final state = deleteRegisterCommand.value;
    if (state is SuccessCommand<bool>) {
      errorMessage = null;
      isLoading = false;
      fetchRegistersCommand.execute();
    } else if (state is FailureCommand<bool>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onDeleteAllRegisters() {
    final state = deleteAllRegistersCommand.value;
    if (state is SuccessCommand<bool>) {
      errorMessage = null;
      isLoading = false;
      fetchRegistersCommand.execute();
    } else if (state is FailureCommand<bool>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void onInsert(RegistersModel register) {
    insertRegisterCommand.execute(register);
  }

  void onUpdate(RegistersModel register) {
    updateRegisterCommand.execute(register);
  }

  void onDelete(int id) {
    deleteRegisterCommand.execute(id);
  }

  void onDeleteAll() {
    deleteAllRegistersCommand.execute();
  }

  @override
  void dispose() {
    fetchRegistersCommand.removeListener(_onFetchRegisters);
    insertRegisterCommand.removeListener(_onInsertRegister);
    updateRegisterCommand.removeListener(_onUpdateRegister);
    deleteRegisterCommand.removeListener(_onDeleteRegister);
    deleteAllRegistersCommand.removeListener(_onDeleteAllRegisters);
    super.dispose();
  }
}
