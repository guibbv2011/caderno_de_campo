import 'package:caderno_do_campo/model/location_model.dart';
import 'package:caderno_do_campo/model/repository/location/location_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationRepository locationRepository;

  late final Command0<LocationModel> fetchLocationCommand;

  LocationModel? location;
  String? error;
  bool isLoading = false;

  LocationViewModel({required this.locationRepository}) {
    fetchLocationCommand = Command0<LocationModel>(() async {
      final result = await locationRepository.fetchLocation();
      return result.onSuccess((location) => location);
    });

    fetchLocationCommand.addListener(_onFetchLocation);
  }

  void _onFetchLocation() {
    final state = fetchLocationCommand.value;
    if (state is SuccessCommand<LocationModel>) {
      location = state.value;
      error = null;
      isLoading = false;
    } else if (state is FailureCommand<LocationModel>) {
      error = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<LocationModel>) {
      isLoading = true;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    fetchLocationCommand.removeListener(_onFetchLocation);
    fetchLocationCommand.dispose();
    super.dispose();
  }
}
