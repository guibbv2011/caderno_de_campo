// import 'package:caderno_do_campo/view/registers_page.dart';
import 'package:caderno_do_campo/viewmodel/areas_viewmodel.dart';
import 'package:caderno_do_campo/viewmodel/costs_viewmodel.dart';
import 'package:caderno_do_campo/viewmodel/cultures_viewmodel.dart';
import 'package:caderno_do_campo/viewmodel/registers_viewmodel.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  final RegistersViewModel registersViewModel;
  final AreasViewModel areasViewModel;
  final CostsViewModel costsViewModel;
  final CulturesViewModel culturesViewModel;
  final VoidCallback onJumpToRegisters;
  final VoidCallback onJumpToAreas;
  final VoidCallback onJumpToCosts;
  final VoidCallback onJumpToCultures;

  const OverviewPage({
    super.key,
    required this.registersViewModel,
    required this.areasViewModel,
    required this.costsViewModel,
    required this.culturesViewModel,
    required this.onJumpToRegisters,
    required this.onJumpToAreas,
    required this.onJumpToCosts,
    required this.onJumpToCultures,
  });
  @override
  OverviewPageState createState() => OverviewPageState();
}

class OverviewPageState extends State<OverviewPage> {
  late ValueNotifier<Map<String, dynamic>> viewModels;
  @override
  void initState() {
    widget.registersViewModel.addListener(() => setState(() {}));
    widget.areasViewModel.addListener(() => setState(() {}));
    widget.costsViewModel.addListener(() => setState(() {}));
    widget.culturesViewModel.addListener(() => setState(() {}));

    widget.registersViewModel.fetchRegistersCommand.execute();
    widget.areasViewModel.fetchAreasCommand.execute();
    widget.costsViewModel.fetchCostsCommand.execute();
    widget.culturesViewModel.fetchCulturesCommand.execute();

    viewModels = ValueNotifier({
      'registers': widget.registersViewModel,
      'areas': widget.areasViewModel,
      'costs': widget.costsViewModel,
      'cultures': widget.culturesViewModel,
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.registersViewModel.removeListener(() => setState(() {}));
    widget.areasViewModel.removeListener(() => setState(() {}));
    widget.costsViewModel.removeListener(() => setState(() {}));
    widget.culturesViewModel.removeListener(() => setState(() {}));

    widget.registersViewModel.dispose();
    widget.areasViewModel.dispose();
    widget.costsViewModel.dispose();
    widget.culturesViewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('OverviewPage');
  }
}
