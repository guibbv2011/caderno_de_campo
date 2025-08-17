import 'package:caderno_do_campo/model/cultures_model.dart';
import 'package:caderno_do_campo/model/repository/database/cultures_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';

class CulturesViewModel extends ChangeNotifier {
  final CulturesRepository culturesRepository;
  late final Command0<List<CulturesModel>> fetchCulturesCommand;
  late final Command1<bool, CulturesModel> insertCultureCommand;
  late final Command1<bool, int> deleteCultureCommand;
  late final Command0<bool> deleteAllCulturesCommand;
  late final Command1<bool, CulturesModel> updateCultureCommand;

  CulturesModel? culture = CulturesModel();
  List<CulturesModel> cultures = [];
  String? error;
  bool isLoading = false;

  CulturesViewModel({required this.culturesRepository}) {
    fetchCulturesCommand = Command0<List<CulturesModel>>(() async {
      final result = await culturesRepository.fetchCultures();
      return result.onSuccess((cultures) => cultures);
    });

    insertCultureCommand = Command1<bool, CulturesModel>((culture) async {
      final result = await culturesRepository.insertCulture(culture);
      return result.onSuccess((_) => true);
    });

    deleteCultureCommand = Command1<bool, int>((id) async {
      final result = await culturesRepository.deleteCulture(id);
      return result.onSuccess((_) => true);
    });

    updateCultureCommand = Command1<bool, CulturesModel>((culture) async {
      final result = await culturesRepository.updateCulture(culture);
      return result.onSuccess((_) => true);
    });

    deleteAllCulturesCommand = Command0<bool>(() async {
      final result = await culturesRepository.deleteAllCultures();
      return result.onSuccess((_) => true);
    });

    fetchCulturesCommand.addListener(_onFetchCulture);
    insertCultureCommand.addListener(_onInsertCulture);
    deleteCultureCommand.addListener(_onDeleteCulture);
    updateCultureCommand.addListener(_onUpdateCulture);
    deleteAllCulturesCommand.addListener(_onDeleteAllCultures);
  }

  void _onFetchCulture() {
    final state = fetchCulturesCommand.value;

    if (state is SuccessCommand<List<CulturesModel>>) {
      cultures = state.value;
      error = null;
      isLoading = false;
    } else if (state is FailureCommand<List<CulturesModel>>) {
      error = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<List<CulturesModel>>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onInsertCulture() {
    final state = insertCultureCommand.value;

    if (state is RunningCommand<bool>) {
      isLoading = true;
    } else if (state is SuccessCommand<bool>) {
      isLoading = false;
      error = null;
      fetchCulturesCommand.execute();
    } else if (state is FailureCommand<bool>) {
      isLoading = false;
      error = state.error.toString();
    }
    notifyListeners();
  }

  void _onDeleteCulture() {
    final state = deleteCultureCommand.value;
    if (state is SuccessCommand<bool>) {
      error = null;
      isLoading = false;
      fetchCulturesCommand.execute();
    } else if (state is FailureCommand<bool>) {
      isLoading = false;
      error = state.error.toString();
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onDeleteAllCultures() {
    final state = deleteAllCulturesCommand.value;
    if (state is SuccessCommand<bool>) {
      error = null;
      isLoading = false;
      fetchCulturesCommand.execute();
    } else if (state is FailureCommand<bool>) {
      isLoading = false;
      error = state.error.toString();
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onUpdateCulture() {
    final state = updateCultureCommand.value;
    if (state is SuccessCommand<bool>) {
      error = null;
      isLoading = false;
      fetchCulturesCommand.execute();
    } else if (state is FailureCommand<bool>) {
      isLoading = false;
      error = state.error.toString();
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void onInsert(CulturesModel culture) {
    insertCultureCommand.execute(culture);
  }

  void onDelete(int id) {
    deleteCultureCommand.execute(id);
  }

  void onUpdate(CulturesModel culture) {
    updateCultureCommand.execute(culture);
  }

  void onDeleteAll() {
    deleteAllCulturesCommand.execute();
  }

  @override
  void dispose() {
    fetchCulturesCommand.removeListener(_onFetchCulture);
    insertCultureCommand.removeListener(_onInsertCulture);
    deleteCultureCommand.removeListener(_onDeleteCulture);
    updateCultureCommand.removeListener(_onUpdateCulture);
    deleteAllCulturesCommand.removeListener(_onDeleteAllCultures);
    super.dispose();
  }
}
