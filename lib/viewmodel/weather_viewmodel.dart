import 'package:caderno_do_campo/model/repository/api/weather_repository.dart';
import 'package:caderno_do_campo/model/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository weatherRepository;
  late final Command0<WeatherModel> fetchCurrentWeatherCommand;
  late final Command0<List<WeatherDayModel>> fetchTwoDaysAfterWeatherCommand;

  WeatherModel weather = WeatherModel();
  List<WeatherDayModel>? map = [];
  String? error;
  bool isLoading = false;

  WeatherViewModel({required this.weatherRepository}) {
    fetchCurrentWeatherCommand = Command0<WeatherModel>(() async {
      final result = await weatherRepository.fetchCurrentWeather();
      return result.onSuccess((weather) => weather);
    });

    fetchTwoDaysAfterWeatherCommand = Command0<List<WeatherDayModel>>(() async {
      final result = await weatherRepository.fetchTwoDaysAfterWeather();
      return result.onSuccess((map) => map);
    });

    fetchTwoDaysAfterWeatherCommand.addListener(_onFetchTwoDaysAfterWeather);
    fetchCurrentWeatherCommand.addListener(_onFetchCurrentWeather);
  }

  void _onFetchTwoDaysAfterWeather() {
    final state = fetchTwoDaysAfterWeatherCommand.value;
    if (state is SuccessCommand<List<WeatherDayModel>>) {
      map = state.value;
      error = null;
      isLoading = false;
    } else if (state is FailureCommand<List<WeatherDayModel>>) {
      error = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<List<WeatherDayModel>>) {
      isLoading = true;
    }
    notifyListeners();
  }

  void _onFetchCurrentWeather() {
    final state = fetchCurrentWeatherCommand.value;
    if (state is SuccessCommand<WeatherModel>) {
      weather = state.value;
      error = null;
      isLoading = false;
    } else if (state is FailureCommand<WeatherModel>) {
      error = state.error.toString();
      isLoading = false;
    } else if (state is RunningCommand<WeatherModel>) {
      isLoading = true;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    fetchTwoDaysAfterWeatherCommand.removeListener(_onFetchTwoDaysAfterWeather);
    fetchTwoDaysAfterWeatherCommand.dispose();
    fetchCurrentWeatherCommand.removeListener(_onFetchCurrentWeather);
    fetchCurrentWeatherCommand.dispose();
    super.dispose();
  }
}
