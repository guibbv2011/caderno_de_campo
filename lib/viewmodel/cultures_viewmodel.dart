import 'package:caderno_do_campo/model/cultures_model.dart';
import 'package:caderno_do_campo/model/repository/cultures_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';

class CulturesViewModel extends ChangeNotifier {
  final CulturesRepository culturesRepository;
  late final Command0<List<CulturesModel>> fetchCulturesCommand;
  late final Command1<bool, CulturesModel> insertCultureCommand;
  late final Command1<bool, int> deleteCultureCommand;
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

    fetchCulturesCommand.addListener(_onFetchCulture);
    insertCultureCommand.addListener(_onInsertCulture);
    deleteCultureCommand.addListener(_onDeleteCulture);
    updateCultureCommand.addListener(_onUpdateCulture);
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

    // Handle different command states
    if (state is RunningCommand<bool>) {
      isLoading = true;
    } else if (state is SuccessCommand<bool>) {
      isLoading = false;
      error = null;
      // Refresh the list after successful insert
      fetchCulturesCommand.execute();
      notifyListeners();
    } else if (state is FailureCommand<bool>) {
      isLoading = false;
      error = state.error.toString();
      notifyListeners();
    }
  }

  void _onDeleteCulture() {
    final state = deleteCultureCommand.value;
    if (state is SuccessCommand<bool>) {
      error = null;
      // Refresh the list after successful delete
      fetchCulturesCommand.execute();
    } else if (state is FailureCommand<bool>) {
      error = state.error.toString();
    }
    notifyListeners();
  }

  void _onUpdateCulture() {
    final state = updateCultureCommand.value;
    if (state is SuccessCommand<bool>) {
      error = null;
      // Refresh the list after successful update
      fetchCulturesCommand.execute();
    } else if (state is FailureCommand<bool>) {
      error = state.error.toString();
    }
    notifyListeners();
  }

  void onInsertCulture(CulturesModel culture) {
    insertCultureCommand.execute(culture);
  }

  void onDeleteCulture(int id) {
    deleteCultureCommand.execute(id);
  }

  void onUpdateCulture(CulturesModel culture) {
    updateCultureCommand.execute(culture);
  }

  @override
  void dispose() {
    fetchCulturesCommand.removeListener(_onFetchCulture);
    insertCultureCommand.removeListener(_onInsertCulture);
    deleteCultureCommand.removeListener(_onDeleteCulture);
    updateCultureCommand.removeListener(_onUpdateCulture);
    super.dispose();
  }
}
