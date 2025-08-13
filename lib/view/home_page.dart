import 'package:caderno_do_campo/view/areas_page.dart';
import 'package:caderno_do_campo/view/costs_page.dart';
import 'package:caderno_do_campo/view/cultures_page.dart';
import 'package:caderno_do_campo/view/overview_page.dart';
import 'package:caderno_do_campo/view/registers_page.dart';
import 'package:caderno_do_campo/view/weather_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _changePage(int indexPage) {
    setState(() {
      _selectedIndex = indexPage;
    });
  }

  final List<Widget> _pages = [
    OverviewPage(),
    RegistersPage(),
    CulturesPage(),
    AreasPage(),
    CostsPage(),
    WeatherPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Caderno do Campo'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.11,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.lightGreenAccent),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: Text('Inicio'),
              selected: _selectedIndex == 0,
              onTap: () => {_changePage(0), Navigator.pop(context)},
            ),
            ListTile(
              title: Text('Registros'),
              selected: _selectedIndex == 1,
              onTap: () => {_changePage(1), Navigator.pop(context)},
            ),
            ListTile(
              title: Text('Culturas'),
              selected: _selectedIndex == 2,
              onTap: () => {_changePage(2), Navigator.pop(context)},
            ),
            ListTile(
              title: Text('Áreas'),
              selected: _selectedIndex == 3,
              onTap: () => {_changePage(3), Navigator.pop(context)},
            ),
            ListTile(
              title: Text('Custos'),
              selected: _selectedIndex == 4,
              onTap: () => {_changePage(4), Navigator.pop(context)},
            ),
            ListTile(
              title: Text('Tempo'),
              selected: _selectedIndex == 5,
              onTap: () => {_changePage(5), Navigator.pop(context)},
            ),
          ],
        ),
      ),
      body: IndexedStack(
        alignment: Alignment.center,
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
