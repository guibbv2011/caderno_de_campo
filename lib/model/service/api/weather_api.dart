import 'package:open_meteo/open_meteo.dart';
import 'package:result_dart/result_dart.dart';

class WeatherApiService {
  final double myLat;
  final double myLong;
  WeatherApiService({required this.myLat, required this.myLong});

  AsyncResultDart<Map, Exception> getTwoDaysAfterWeather() async {
    try {
      final WeatherApi weather = WeatherApi(userAgent: 'Caderno de Campo');
      final ApiResponse<WeatherApi> response = await weather.request(
        latitude: myLat,
        longitude: myLong,
        daily: <WeatherDaily>{
          WeatherDaily.temperature_2m_mean,
          WeatherDaily.temperature_2m_min,
          WeatherDaily.temperature_2m_max,
          WeatherDaily.precipitation_probability_mean,
          WeatherDaily.relative_humidity_2m_mean,
        },
        forecastDays: 4,
      );

      return Success(response.dailyData);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  AsyncResult<Map> getCurrentWeather() async {
    try {
      final WeatherApi weather = WeatherApi(userAgent: 'Open-meteo-dart');
      final ApiResponse<WeatherApi> response = await weather.request(
        latitude: myLat,
        longitude: myLong,
        current: <WeatherCurrent>{
          WeatherCurrent.precipitation,
          WeatherCurrent.wind_speed_10m,
          WeatherCurrent.temperature_2m,
          WeatherCurrent.relative_humidity_2m,
          WeatherCurrent.cloud_cover,
          WeatherCurrent.surface_pressure,
        },
      );

      return Success(response.currentData);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
