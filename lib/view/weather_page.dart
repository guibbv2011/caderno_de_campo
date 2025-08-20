import 'package:caderno_do_campo/model/repository/api/weather_repository.dart';
import 'package:caderno_do_campo/model/service/api/weather_api.dart';
import 'package:caderno_do_campo/model/weather_model.dart';
import 'package:caderno_do_campo/viewmodel/weather_viewmodel.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);
  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  late final WeatherViewModel viewWeather;
  late final WeatherViewModel viewWeatherDays;

  double _latitude = 0.0;
  double _longitude = 0.0;

  Future<void> savePage(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('page', page);
  }

  Future<void> _loadDoubles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _latitude = prefs.getDouble('latitude')!;
    _longitude = prefs.getDouble('longitude')!;

    // debugPrint('_lat: $_latitude');
    // debugPrint('_long: $_longitude');
    setState(() {});
  }

  Future<void> weatherViews() async {
    // debugPrint('_lat in watherview: $_latitude');
    debugPrint('_lat in watherview: $_latitude');
    if (_latitude == 0.0) {
      savePage(5);
    }
    // debugPrint('_long in weatherview: $_longitude');
    final WeatherRepository weatherRepository = WeatherRepository(
      weatherService: WeatherApiService(myLat: _latitude, myLong: _longitude),
    );

    viewWeather = WeatherViewModel(weatherRepository: weatherRepository);
    viewWeatherDays = WeatherViewModel(weatherRepository: weatherRepository);
    viewWeather.addListener(() => setState(() {}));
    viewWeatherDays.addListener(() => setState(() {}));
    viewWeather.fetchCurrentWeatherCommand.execute();
    viewWeatherDays.fetchTwoDaysAfterWeatherCommand.execute();

    setState(() {});
  }

  @override
  void initState() {
    _loadDoubles().whenComplete(() => weatherViews());
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
    if (viewWeather.isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    }
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
                if (_latitude == 0.0) {
                  Phoenix.rebirth(context);
                } else {
                  viewWeather.fetchCurrentWeatherCommand.execute();
                  viewWeatherDays.fetchTwoDaysAfterWeatherCommand.execute();
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            _card(viewWeather.weather, viewWeatherDays.map!, 'Hoje'),
            _card1(viewWeatherDays.map!, 1),
            _card1(viewWeatherDays.map!, 2),
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
