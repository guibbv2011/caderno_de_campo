import 'package:caderno_do_campo/model/repository/database/list_titles_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:result_command/result_command.dart';

class ListTitlesViewModel extends ChangeNotifier {
  final ListTitlesRepository listTitleRepository;

  late final Command0<List<String>> fetchCulturesTitlesCommand;
  late final Command0<List<String>> fetchAreasTitlesCommand;

  List<String>? listCultures;
  List<String>? listAreas;
  String? error;
  bool isLoading = false;

  ListTitlesViewModel({required this.listTitleRepository}) {
    fetchCulturesTitlesCommand = Command0<List<String>>(() async {
      final result = await listTitleRepository.getCulturesTitles();
      return result.onSuccess((cultures) => cultures);
    });

    fetchAreasTitlesCommand = Command0<List<String>>(() async {
      final result = await listTitleRepository.getAreasTitles();
      return result.onSuccess((areas) => areas);
    });

    fetchCulturesTitlesCommand.addListener(_onfetchCulturesTitlesCommand);
    fetchAreasTitlesCommand.addListener(_onfetchAreasTitlesCommand);
  }

  void _onfetchCulturesTitlesCommand() {
    final state = fetchCulturesTitlesCommand.value;
    if (state is SuccessCommand<List<String>>) {
      listCultures = state.value;
      error = null;
      isLoading = false;
    } else if (state is FailureCommand<List<String>>) {
      error = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<List<String>>) {
      isLoading = true;
      error = null;
    }

    notifyListeners();
  }

  void _onfetchAreasTitlesCommand() {
    final state = fetchAreasTitlesCommand.value;

    if (state is SuccessCommand<List<String>>) {
      listAreas = state.value;
      error = null;
      isLoading = false;
    } else if (state is FailureCommand<List<String>>) {
      error = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<List<String>>) {
      isLoading = true;
      error = null;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    fetchCulturesTitlesCommand.removeListener(_onfetchCulturesTitlesCommand);
    fetchAreasTitlesCommand.removeListener(_onfetchAreasTitlesCommand);
    fetchCulturesTitlesCommand.dispose();
    fetchAreasTitlesCommand.dispose();
    super.dispose();
  }
}
