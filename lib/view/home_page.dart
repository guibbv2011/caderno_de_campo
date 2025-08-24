import 'package:caderno_do_campo/model/location_model.dart';
import 'package:caderno_do_campo/model/repository/database/costs_repository.dart';
import 'package:caderno_do_campo/model/repository/database/cultures_repository.dart';
import 'package:caderno_do_campo/model/repository/database/registers_repository.dart';
import 'package:caderno_do_campo/model/repository/location/location_repository.dart';
import 'package:caderno_do_campo/model/service/database/costs_db.dart';
import 'package:caderno_do_campo/model/service/database/culture_db.dart';
import 'package:caderno_do_campo/model/service/database/registers_db.dart';
import 'package:caderno_do_campo/model/service/location/location_service.dart';
import 'package:caderno_do_campo/view/areas_page.dart';
import 'package:caderno_do_campo/view/costs_page.dart';
import 'package:caderno_do_campo/view/cultures_page.dart';
import 'package:caderno_do_campo/view/overview_page.dart';
import 'package:caderno_do_campo/view/registers_page.dart';
import 'package:caderno_do_campo/view/weather_page.dart';
import 'package:caderno_do_campo/viewmodel/areas_viewmodel.dart';
import 'package:caderno_do_campo/viewmodel/costs_viewmodel.dart';
import 'package:caderno_do_campo/viewmodel/cultures_viewmodel.dart';
import 'package:caderno_do_campo/viewmodel/location_viewmodel.dart';
import 'package:caderno_do_campo/viewmodel/registers_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:caderno_do_campo/model/repository/database/areas_repository.dart';
import 'package:caderno_do_campo/model/service/database/areas_db.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LocationViewModel viewLocate;
  late AreasViewModel viewAreasModel;
  late final CulturesViewModel viewCulturesModel;
  late final CostsViewModel viewCostsModel;
  late final RegistersViewModel viewRegistersModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    final locationService = LocationService();
    final locationRepository = LocationRepository(
      locationService: locationService,
    );
    viewLocate = LocationViewModel(locationRepository: locationRepository);
    viewLocate.addListener(() => setState(() {}));
    viewLocate.fetchLocationCommand.execute();

    final databaseAreasService = AreasServiceDatabase();
    final areasRepository = AreasRepository(
      databaseService: databaseAreasService,
    );
    viewAreasModel = AreasViewModel(areasRepository: areasRepository);
    viewAreasModel.addListener(() => setState(() {}));
    viewAreasModel.fetchAreasCommand.execute();

    final databaseCultureService = CultureServiceDatabase();
    final culturesRepository = CulturesRepository(
      databaseService: databaseCultureService,
    );
    viewCulturesModel = CulturesViewModel(
      culturesRepository: culturesRepository,
    );
    viewCulturesModel.addListener(() => setState(() {}));
    viewCulturesModel.fetchCulturesCommand.execute();

    final databaseCostsService = CostsServiceDatabase();
    final costsRepository = CostsRepository(
      databaseService: databaseCostsService,
    );
    viewCostsModel = CostsViewModel(costsRepository: costsRepository);
    viewCostsModel.addListener(() => setState(() {}));
    viewCostsModel.fetchCostsCommand.execute();

    final databaseRegistersService = RegistersServiceDatabase();
    final registersRepository = RegistersRepository(
      databaseService: databaseRegistersService,
    );
    viewRegistersModel = RegistersViewModel(
      registersRepository: registersRepository,
    );
    viewRegistersModel.addListener(() => setState(() {}));
    viewRegistersModel.fetchRegistersCommand.execute();
    super.initState();
  }

  @override
  void dispose() {
    viewLocate.removeListener(() => setState(() => {}));
    viewLocate.dispose();

    viewAreasModel.removeListener(() => setState(() {}));
    viewAreasModel.dispose();

    viewCulturesModel.removeListener(() => setState(() {}));
    viewCulturesModel.dispose();

    viewCostsModel.removeListener(() => setState(() {}));
    viewCostsModel.dispose();

    viewRegistersModel.dispose();
    super.dispose();
  }

  void _changePage(int indexPage) {
    setState(() {
      _selectedIndex = indexPage;
    });
  }

  List<Widget> get _pages => [
    OverviewPage(
      registersViewModel: viewRegistersModel,
      areasViewModel: viewAreasModel,
      costsViewModel: viewCostsModel,
      culturesViewModel: viewCulturesModel,
      onJumpToRegisters: () => _changePage(1),
      onJumpToCultures: () => _changePage(2),
      onJumpToAreas: () => _changePage(3),
      onJumpToCosts: () => _changePage(4),
    ),
    RegistersPage(viewModel: viewRegistersModel),
    CulturesPage(viewModel: viewCulturesModel),
    AreasPage(viewModel: viewAreasModel),
    CostsPage(viewModel: viewCostsModel),
    WeatherPage(locate: viewLocate.location ?? LocationModel(0.0, 0.0)),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: GestureDetector(
        onHorizontalDragEnd: (event) {
          if (event.primaryVelocity! > 0) {
            _scaffoldKey.currentState!.openDrawer();
          }
        },
        child: IndexedStack(
          alignment: Alignment.center,
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
  }
}
