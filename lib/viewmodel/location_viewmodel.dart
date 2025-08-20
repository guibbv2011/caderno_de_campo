import 'package:caderno_do_campo/model/location_model.dart';
import 'package:caderno_do_campo/model/repository/location/location_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationViewmodel extends ChangeNotifier {
  final LocationRepository locationRepository;

  late final Command0<LocationModel> fetchLocationCommand;

  LocationModel? location;
  String? error;
  bool isLoading = false;

  Future<void> saveDoubles(double lat, double long) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('latitude', lat);
    await prefs.setDouble('longitude', long);
  }

  LocationViewmodel({required this.locationRepository}) {
    fetchLocationCommand = Command0<LocationModel>(() async {
      final result = await locationRepository.fetchLocation();
      return result.onSuccess((location) => location);
    });

    fetchLocationCommand.addListener(_onFetchLocation);
  }

  void _onFetchLocation() {
    final state = fetchLocationCommand.value;
    if (state is SuccessCommand<LocationModel>) {
      saveDoubles(state.value.latitude, state.value.longitude);
      location = state.value;

      error = null;
      isLoading = false;
    } else if (state is FailureCommand<LocationModel>) {
      error = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<LocationModel>) {
      isLoading = true;
      error = null;
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
