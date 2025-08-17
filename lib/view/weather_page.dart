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
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Weather Page'));
  }
}
