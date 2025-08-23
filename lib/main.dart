import 'dart:io';
import 'package:caderno_do_campo/model/service/database/areas_db.dart';
import 'package:caderno_do_campo/model/service/database/costs_db.dart';
import 'package:caderno_do_campo/model/service/database/culture_db.dart';
import 'package:caderno_do_campo/model/service/database/registers_db.dart';
import 'package:caderno_do_campo/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();

  await AreasServiceDatabase().open();
  await CostsServiceDatabase().open();
  await CultureServiceDatabase().open();
  await RegistersServiceDatabase().open();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caderno do Campo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(background: Colors.black),
      ),
      home: MyHomePage(),
    );
  }
}
