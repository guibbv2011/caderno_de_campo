import 'package:caderno_do_campo/model/location_model.dart';
import 'package:caderno_do_campo/model/repository/api/weather_repository.dart';
import 'package:caderno_do_campo/model/service/api/weather_api.dart';
import 'package:caderno_do_campo/model/weather_model.dart';
import 'package:caderno_do_campo/viewmodel/weather_viewmodel.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  final LocationModel locate;
  const WeatherPage({super.key, required this.locate});
  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  late WeatherViewModel viewWeather;
  late WeatherViewModel viewWeatherDays;
  late ValueNotifier<List<WeatherViewModel>> weather;

  Future<void> weatherViews() async {
    final WeatherRepository weatherRepository = WeatherRepository(
      weatherService: WeatherApiService(
        myLat: widget.locate.latitude,
        myLong: widget.locate.longitude,
      ),
    );

    viewWeather = WeatherViewModel(weatherRepository: weatherRepository);
    viewWeatherDays = WeatherViewModel(weatherRepository: weatherRepository);
    viewWeather.addListener(() => setState(() {}));
    viewWeatherDays.addListener(() => setState(() {}));

    if (widget.locate.latitude != 0.0 && widget.locate.longitude != 0.0) {
      viewWeather.fetchCurrentWeatherCommand.execute();
      viewWeatherDays.fetchTwoDaysAfterWeatherCommand.execute();
    }

    weather = ValueNotifier([viewWeather, viewWeatherDays]);

    setState(() {});
  }

  @override
  void initState() {
    weatherViews();
    super.initState();
  }

  @override
  void dispose() {
    viewWeather.removeListener(() => setState(() {}));
    viewWeatherDays.removeListener(() => setState(() {}));

    viewWeather.dispose();
    viewWeatherDays.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempo'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: IconButton(
              icon: Icon(Icons.refresh_outlined),
              iconSize: 14.0,
              tooltip: 'Atualizar',
              onPressed: () {
                weatherViews();
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: weather,
              builder: (context, child) {
                return _card(viewWeather.weather, viewWeatherDays.map!, 'Hoje');
              },
            ),
            ListenableBuilder(
              listenable: weather,
              builder: (context, child) {
                return _card1(viewWeatherDays.map!, 1);
              },
            ),
            ListenableBuilder(
              listenable: weather,
              builder: (context, child) {
                return _card1(viewWeatherDays.map!, 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _card(
  WeatherModel viewModelCommand,
  List<WeatherDayModel> viewMapCommand,
  String whichDay,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
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
            child: Row(
              children: [
                _weatherWidget(
                  'Temperatura',
                  MainAxisAlignment.start,
                  true,
                  10,
                  64,
                  Colors.lightGreen,
                  LucideIcons.sunSnow,
                  viewModelCommand.meanTemp,
                  'C°',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _weatherWidget(
                        'Mínima',
                        null,
                        false,
                        10,
                        24,
                        Colors.lightBlue,
                        LucideIcons.sunSnow,
                        viewMapCommand.isNotEmpty
                            ? viewMapCommand.elementAt(0).minTemp!
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
                        viewMapCommand.isNotEmpty
                            ? viewMapCommand.elementAt(0).maxTemp!
                            : 0.0,
                        'C°',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                    viewModelCommand.humidity,
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
                    viewModelCommand.windSpeed,
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
                    viewModelCommand.pressure,
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
                    viewModelCommand.precipitation,
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
                    viewModelCommand.cloudCover,
                    '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _card1(List<WeatherDayModel> viewCommand, int whichDay) {
  final String day = switch (whichDay) {
    0 => '',
    1 => 'Amanhã',
    2 => 'Depos de Amanhã',
    _ => '',
  };
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
          Padding(padding: const EdgeInsets.all(8.0), child: Text(day)),
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
              viewCommand.isNotEmpty
                  ? viewCommand.elementAt(whichDay).meanTemp!
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
                  viewCommand.isNotEmpty
                      ? viewCommand.elementAt(whichDay).minTemp
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
                  viewCommand.isNotEmpty
                      ? viewCommand.elementAt(whichDay).maxTemp
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
                  viewCommand.isNotEmpty
                      ? viewCommand.elementAt(whichDay).humidity
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
                  viewCommand.isNotEmpty
                      ? viewCommand.elementAt(whichDay).precipitation
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
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
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
      ),
    ],
  );
}
