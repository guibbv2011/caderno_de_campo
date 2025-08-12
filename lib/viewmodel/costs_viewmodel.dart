import 'package:caderno_do_campo/model/costs_model.dart';
import 'package:caderno_do_campo/model/repository/costs_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:result_command/result_command.dart';

class CostsViewModel extends ChangeNotifier {
  final CostsRepository costsRepository;
  late final Command0<List<CostsModel>> fetchCostsCommand;
  late final Command1<bool, CostsModel> insertCostCommand;
  late final Command1<bool, CostsModel> updateCostCommand;
  late final Command1<bool, int> deleteCostCommand;
  late final Command0<bool> deleteAllCostsCommand;

  CostsModel cost = CostsModel();
  List<CostsModel> costs = [];
  String? errorMessage;
  bool isLoading = false;

  CostsViewModel({required this.costsRepository}) {
    fetchCostsCommand = Command0<List<CostsModel>>(() async {
      final result = await costsRepository.fetchCosts();
      return result.onSuccess((costs) => costs);
    });

    insertCostCommand = Command1<bool, CostsModel>((cost) async {
      final result = await costsRepository.insertCost(cost);
      return result.onSuccess((_) => true);
    });

    updateCostCommand = Command1<bool, CostsModel>((cost) async {
      final result = await costsRepository.updateCost(cost);
      return result.onSuccess((_) => true);
    });

    deleteCostCommand = Command1<bool, int>((id) async {
      final result = await costsRepository.deleteCost(id);
      return result.onSuccess((_) => true);
    });

    deleteAllCostsCommand = Command0<bool>(() async {
      final result = await costsRepository.deleteAllCosts();
      return result.onSuccess((_) => true);
    });

    fetchCostsCommand.addListener(_onFetchCosts);
    insertCostCommand.addListener(_onInsertCost);
    updateCostCommand.addListener(_onUpdateCost);
    deleteCostCommand.addListener(_onDeleteCost);
    deleteAllCostsCommand.addListener(_onDeleteAllCosts);
  }

  void _onFetchCosts() {
    final state = fetchCostsCommand.value;
    if (state is SuccessCommand<List<CostsModel>>) {
      costs = state.value;
      errorMessage = null;
      isLoading = false;
    } else if (state is FailureCommand<List<CostsModel>>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<List<CostsModel>>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onInsertCost() {
    final state = insertCostCommand.value;
    if (state is SuccessCommand<bool>) {
      errorMessage = null;
      isLoading = false;
      fetchCostsCommand.execute();
    } else if (state is FailureCommand<bool>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onUpdateCost() {
    final state = updateCostCommand.value;
    if (state is SuccessCommand<bool>) {
      errorMessage = null;
      isLoading = false;
      fetchCostsCommand.execute();
    } else if (state is FailureCommand<bool>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onDeleteCost() {
    final state = deleteCostCommand.value;
    if (state is SuccessCommand<bool>) {
      errorMessage = null;
      isLoading = false;
      fetchCostsCommand.execute();
    } else if (state is FailureCommand<bool>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onDeleteAllCosts() {
    final state = deleteAllCostsCommand.value;
    if (state is SuccessCommand<bool>) {
      errorMessage = null;
      isLoading = false;
      fetchCostsCommand.execute();
    } else if (state is FailureCommand<bool>) {
      errorMessage = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void onInsert(CostsModel cost) {
    insertCostCommand.execute(cost);
  }

  void onUpdate(CostsModel cost) {
    updateCostCommand.execute(cost);
  }

  void onDelete(int id) {
    deleteCostCommand.execute(id);
  }

  void onDeleteAll() {
    deleteAllCostsCommand.execute();
  }

  @override
  void dispose() {
    fetchCostsCommand.removeListener(_onFetchCosts);
    updateCostCommand.removeListener(_onUpdateCost);
    deleteCostCommand.removeListener(_onDeleteCost);
    insertCostCommand.removeListener(_onInsertCost);
    deleteAllCostsCommand.removeListener(_onDeleteAllCosts);
    super.dispose();
  }
}
