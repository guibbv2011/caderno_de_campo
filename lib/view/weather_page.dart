import 'package:caderno_do_campo/model/repository/api/weather_repository.dart';
import 'package:caderno_do_campo/model/service/api/weather_api.dart';
import 'package:caderno_do_campo/viewmodel/weather_viewmodel.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  late final WeatherViewModel viewModel;
  late final WeatherViewModel viewMap;

  @override
  void initState() {
    super.initState();
    final weatherService = WeatherApiService(
    );
    final weatherRepository = WeatherRepository(weatherService: weatherService);
    viewModel = WeatherViewModel(weatherRepository: weatherRepository);
    viewModel.addListener(() => setState(() {}));

    viewMap = WeatherViewModel(weatherRepository: weatherRepository);
    viewMap.addListener(() => setState(() {}));

    viewModel.fetchCurrentWeatherCommand.execute();
    viewMap.fetchTwoDaysAfterWeatherCommand.execute();
  }

  @override
  void dispose() {
    viewModel.removeListener(() => setState(() => {}));
    viewModel.dispose();
    viewMap.removeListener(() => setState(() => {}));
    viewMap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: [
          _card(viewModel, 'Hoje'),
          _card1(viewMap, 0),
          _card1(viewMap, 1),
        ],
      ),
    );
  }
}

Widget _card(WeatherViewModel viewCommand, String whichDay) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      width: double.infinity * 0.8,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightGreenAccent.shade700),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: Text(whichDay)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _weatherWidget(
              'Temperatura',
              MainAxisAlignment.start,
              true,
              10,
              64,
              Colors.lightGreen,
              LucideIcons.sunSnow,
              viewCommand.weather.meanTemp,
              'C°',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _weatherWidget(
                  'Humidade',
                  null,
                  false,
                  10,
                  24,
                  Colors.blueAccent,
                  LucideIcons.bubbles,
                  viewCommand.weather.humidity,
                  '',
                ),
                _weatherWidget(
                  'Vento',
                  null,
                  false,
                  10,
                  24,
                  Colors.grey.shade200,
                  LucideIcons.wind,
                  viewCommand.weather.windSpeed,
                  '(km/h)',
                ),
                _weatherWidget(
                  'Pressão',
                  null,
                  false,
                  10,
                  24,
                  Colors.grey.shade400,
                  LucideIcons.windArrowDown,
                  viewCommand.weather.pressure,
                  '',
                ),
                _weatherWidget(
                  'Precipitação',
                  null,
                  false,
                  10,
                  24,
                  Colors.blue,
                  LucideIcons.cloudHail,
                  viewCommand.weather.precipitation,
                  '%',
                ),
                _weatherWidget(
                  'Nuvens',
                  null,
                  false,
                  10,
                  24,
                  Colors.grey.shade700,
                  LucideIcons.cloudy,
                  viewCommand.weather.cloudCover,
                  '',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _card1(WeatherViewModel viewCommand, int whichDay) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      width: double.infinity * 0.8,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightGreenAccent.shade700),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(whichDay == 0 ? 'Amanhã' : 'Depos de Amanhã'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _weatherWidget(
              'Temperatura',
              MainAxisAlignment.start,
              true,
              10,
              64,
              Colors.lightGreen,
              LucideIcons.sunSnow,
              viewCommand.map != null
                  ? viewCommand.map!.isEmpty
                        ? 0.0
                        : viewCommand.map!.elementAt(whichDay).meanTemp
                  : 0.0,
              'C°',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _weatherWidget(
                  'Mínima',
                  null,
                  false,
                  10,
                  24,
                  Colors.lightBlue,
                  LucideIcons.sunSnow,
                  viewCommand.map != null
                      ? viewCommand.map!.isEmpty
                            ? 0.0
                            : viewCommand.map!.elementAt(whichDay).minTemp
                      : 0.0,
                  'C°',
                ),
                _weatherWidget(
                  'Máxima',
                  null,
                  false,
                  10,
                  24,
                  Colors.orangeAccent,
                  LucideIcons.sunSnow,
                  viewCommand.map != null
                      ? viewCommand.map!.isEmpty
                            ? 0.0
                            : viewCommand.map!.elementAt(whichDay).maxTemp
                      : 0.0,
                  'C°',
                ),
                _weatherWidget(
                  'Humidade',
                  null,
                  false,
                  10,
                  24,
                  Colors.blueAccent,
                  LucideIcons.bubbles,
                  viewCommand.map != null
                      ? viewCommand.map!.isEmpty
                            ? 0.0
                            : viewCommand.map!.elementAt(whichDay).humidity
                      : 0.0,
                  '',
                ),
                _weatherWidget(
                  'Precipitação',
                  null,
                  false,
                  10,
                  24,
                  Colors.blue,
                  LucideIcons.cloudHail,
                  viewCommand.map != null
                      ? viewCommand.map!.isEmpty
                            ? 0.0
                            : viewCommand.map!.elementAt(whichDay).precipitation
                      : 0.0,
                  '%',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _weatherWidget(
  String title,
  MainAxisAlignment? mainAxis,
  bool showTitle,
  double space,
  double iconSize,
  Color iconColor,
  IconData icon,
  double? dataModel,
  String finalText,
) {
  return Row(
    spacing: space,
    mainAxisAlignment: mainAxis ?? MainAxisAlignment.spaceAround,
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Tooltip(
        preferBelow: false,
        verticalOffset: 5,
        decoration: BoxDecoration(color: Colors.transparent),
        message: showTitle != true ? title : '',
        textStyle: TextStyle(color: Colors.grey.shade200, fontSize: 10),
        child: IconTheme(
          data: IconThemeData(size: iconSize, color: iconColor),
          child: Icon(icon),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle == true)
            Text(
              showTitle == true ? title : '',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),

          Text(
            dataModel?.toStringAsFixed(2) ?? '...',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    ],
  );
}
