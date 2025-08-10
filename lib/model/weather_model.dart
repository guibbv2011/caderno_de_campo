class WeatherModel {
  final double degrees;
  final String weather;
  final double minTemp;
  final double maxTemp;
  final double windSpeed;
  final double humidity;
  final double pressure;

  WeatherModel({
    required this.degrees,
    required this.weather,
    required this.minTemp,
    required this.maxTemp,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      degrees: map['degrees'],
      weather: map['weather'],
      minTemp: map['minTemp'],
      maxTemp: map['maxTemp'],
      windSpeed: map['windSpeed'],
      humidity: map['humidity'],
      pressure: map['pressure'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'degrees': degrees,
      'weather': weather,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'pressure': pressure,
    };
  }
}
