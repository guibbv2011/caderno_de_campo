import 'package:caderno_do_campo/model/service/api/weather_api.dart';
import 'package:caderno_do_campo/model/weather_model.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:result_dart/result_dart.dart';

class WeatherRepository {
  final WeatherApiService weatherService;
  WeatherRepository({required this.weatherService});

  AsyncResult<WeatherModel> fetchCurrentWeather() async {
    try {
      final response = await weatherService.getCurrentWeather();

      return response.fold(
        (r) {
          final data = Map<String, double>.fromEntries([
            MapEntry('precipitation', r[WeatherCurrent.precipitation].value),
            MapEntry('windSpeed', r[WeatherCurrent.wind_speed_10m].value),
            MapEntry('meanTemp', r[WeatherCurrent.temperature_2m].value),
            MapEntry('humidity', r[WeatherCurrent.relative_humidity_2m].value),
            MapEntry('cloudCover', r[WeatherCurrent.cloud_cover].value),
            MapEntry('pressure', r[WeatherCurrent.surface_pressure].value),
          ]);

          final WeatherModel weather = WeatherModel(
            precipitation: data['precipitation'],
            windSpeed: data['windSpeed'],
            meanTemp: data['meanTemp'],
            humidity: data['humidity'],
            cloudCover: data['cloudCover'],
            pressure: data['pressure'],
          );
          return Success(weather);
        },
        (error) {
          return Failure(Exception(error));
        },
      );
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  AsyncResult<List<WeatherDayModel>> fetchTwoDaysAfterWeather() async {
    try {
      final response = await weatherService.getTwoDaysAfterWeather();
      List<Map<dynamic, dynamic>>? el = [];
      List<WeatherDayModel> elmap = [];
      return response.fold(
        (success) {
          for (var i = 0; i < success.entries.length; i++) {
            el.add(success.values.elementAt(i).values);
          }

          for (var v = 2; v < (el.first.keys.length); v++) {
            final WeatherDayModel mapWeathers = WeatherDayModel(
              meanTemp: el.elementAt(0).values.elementAt(v),
              minTemp: el.elementAt(1).values.elementAt(v),
              maxTemp: el.elementAt(2).values.elementAt(v),
              precipitation: el.elementAt(3).values.elementAt(v),
              humidity: el.elementAt(4).values.elementAt(v),
            );
            elmap.add(mapWeathers);
          }
        },
        (error) {
          return Failure(Exception('onFailure in weather_repository: $error'));
        },
      );
    } catch (e) {
      return Failure(Exception('Failure in weather_repository: $e.toString()'));
    }
  }
}
