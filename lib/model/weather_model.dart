class WeatherModel {
  final double? meanTemp;
  final double? minTemp;
  final double? maxTemp;
  final double? windSpeed;
  final double? humidity;
  final double? pressure;
  final double? precipitation;
  final double? cloudCover;

  WeatherModel({
    this.precipitation,
    this.meanTemp,
    this.minTemp,
    this.maxTemp,
    this.windSpeed,
    this.humidity,
    this.pressure,
    this.cloudCover,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      precipitation: map['precipitation'],
      meanTemp: map['mean_temp'],
      minTemp: map['min_temp'],
      maxTemp: map['max_temp'],
      windSpeed: map['wind_speed'],
      humidity: map['humidity'],
      pressure: map['pressure'],
      cloudCover: map['cloud_cover'],
    );
  }

  Map<String, double> toMap() {
    return {
      'precipitation': precipitation!,
      'mean_temp': meanTemp!,
      'min_temp': minTemp!,
      'max_temp': maxTemp!,
      'wind_speed': windSpeed!,
      'humidity': humidity!,
      'pressure': pressure!,
    };
  }
}

class WeatherDayModel {
  final double? meanTemp;
  final double? minTemp;
  final double? maxTemp;
  final double? precipitation;
  final double? humidity;

  WeatherDayModel({
    this.meanTemp,
    this.minTemp,
    this.maxTemp,
    this.precipitation,
    this.humidity,
  });

  factory WeatherDayModel.fromMap(Map<String, dynamic> map) {
    return WeatherDayModel(
      meanTemp: map['mean_temp'],
      minTemp: map['min_temp'],
      maxTemp: map['max_temp'],
      precipitation: map['precipitation'],
      humidity: map['humidity'],
    );
  }

  Map<String, double> toMap() {
    return {
      'mean_temp': meanTemp!,
      'min_temp': minTemp!,
      'max_temp': maxTemp!,
      'precipitation': precipitation!,
      'humidity': humidity!,
    };
  }
}
