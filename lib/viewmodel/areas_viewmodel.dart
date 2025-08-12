import 'package:caderno_do_campo/model/areas_model.dart';
import 'package:caderno_do_campo/model/repository/areas_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:result_command/result_command.dart';

class AreasViewModel extends ChangeNotifier {
  final AreasRepository areasRepository;
  late final Command0<List<AreasModel>> fetchAreasCommand;
  late final Command1<bool, AreasModel> insertAreaCommand;
  late final Command1<bool, AreasModel> updateAreaCommand;
  late final Command1<bool, int> deleteAreaCommand;

  AreasModel? area = AreasModel();
  List<AreasModel> areas = [];
  String? error;
  bool isLoading = false;

  AreasViewModel({required this.areasRepository}) {
    fetchAreasCommand = Command0<List<AreasModel>>(() async {
      final result = await areasRepository.fetchAreas();
      return result.onSuccess((areas) => areas);
    });

    insertAreaCommand = Command1<bool, AreasModel>((area) async {
      final result = await areasRepository.insertArea(area);
      return result.onSuccess((_) => true);
    });

    updateAreaCommand = Command1<bool, AreasModel>((area) async {
      final result = await areasRepository.updateArea(area);
      return result.onSuccess((_) => true);
    });

    deleteAreaCommand = Command1<bool, int>((id) async {
      final result = await areasRepository.deleteArea(id);
      return result.onSuccess((_) => true);
    });

    fetchAreasCommand.addListener(_onFetchAreas);
    insertAreaCommand.addListener(_onInsertArea);
    updateAreaCommand.addListener(_onUpdateArea);
    deleteAreaCommand.addListener(_onDeleteArea);
  }

  void _onFetchAreas() {
    final state = fetchAreasCommand.value;

    if (state is SuccessCommand<List<AreasModel>>) {
      areas = state.value;
      error = null;
      isLoading = false;
    } else if (state is FailureCommand<List<AreasModel>>) {
      error = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<List<AreasModel>>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onInsertArea() {
    final state = insertAreaCommand.value;

    if (state is SuccessCommand<bool>) {
      error = null;
      isLoading = false;
      fetchAreasCommand.execute();
    } else if (state is FailureCommand<bool>) {
      isLoading = false;
      error = state.error.toString();
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onDeleteArea() {
    final state = deleteAreaCommand.value;

    if (state is SuccessCommand<bool>) {
      error = null;
      isLoading = false;
      fetchAreasCommand.execute();
    } else if (state is FailureCommand<bool>) {
      isLoading = false;
      error = state.error.toString();
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onUpdateArea() {
    final state = updateAreaCommand.value;

    if (state is SuccessCommand<bool>) {
      error = null;
      isLoading = false;
      fetchAreasCommand.execute();
    } else if (state is FailureCommand<bool>) {
      isLoading = false;
      error = state.error.toString();
    } else if (state is RunningCommand<bool>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void onInsert(AreasModel area) {
    insertAreaCommand.execute(area);
  }

  void onDelete(int id) {
    deleteAreaCommand.execute(id);
  }

  void onUpdate(AreasModel area) {
    updateAreaCommand.execute(area);
  }

  @override
  void dispose() {
    fetchAreasCommand.removeListener(_onFetchAreas);
    insertAreaCommand.removeListener(_onInsertArea);
    deleteAreaCommand.removeListener(_onDeleteArea);
    updateAreaCommand.removeListener(_onUpdateArea);
    super.dispose();
  }
}
