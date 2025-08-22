import 'package:caderno_do_campo/model/location_model.dart';
import 'package:caderno_do_campo/model/repository/location/location_repository.dart';
import 'package:caderno_do_campo/model/service/location/location_service.dart';
import 'package:caderno_do_campo/view/areas_page.dart';
import 'package:caderno_do_campo/view/costs_page.dart';
import 'package:caderno_do_campo/view/cultures_page.dart';
import 'package:caderno_do_campo/view/overview_page.dart';
import 'package:caderno_do_campo/view/registers_page.dart';
import 'package:caderno_do_campo/view/weather_page.dart';
import 'package:caderno_do_campo/viewmodel/location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LocationViewModel viewLocate;
  int _selectedIndex = 0;

  Future<void> savePage(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('page', page);
  }

  Future<void> loadPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedIndex = prefs.getInt('page')!;
    setState(() {});
  }

  LocationModel locate = LocationModel(0.0, 0.0);

  @override
  void initState() {
    loadPage().whenComplete(() {
      if (_selectedIndex == 5) {
        savePage(0);
      }
    });
    final locationService = LocationService();
    final locationRepository = LocationRepository(
      locationService: locationService,
    );
    viewLocate = LocationViewModel(locationRepository: locationRepository);
    viewLocate.addListener(() => setState(() {}));
    viewLocate.fetchLocationCommand.execute();

    super.initState();
  }

  @override
  void dispose() {
    viewLocate.removeListener(() => setState(() => {}));
    viewLocate.dispose();
    super.dispose();
  }

  void _changePage(int indexPage) {
    setState(() {
      _selectedIndex = indexPage;
    });
  }

  List<Widget> get _pages => [
    OverviewPage(),
    RegistersPage(),
    CulturesPage(),
    AreasPage(),
    CostsPage(),
    WeatherPage(locate: viewLocate.location ?? LocationModel(0.0, 0.0)),
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 5 && viewLocate.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
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
