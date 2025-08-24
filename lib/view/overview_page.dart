import 'package:caderno_do_campo/view/shared/ui.dart';
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
  ValueNotifier<Set> viewModels = ValueNotifier({});

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
      widget.registersViewModel,
      widget.areasViewModel,
      widget.costsViewModel,
      widget.culturesViewModel,
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
    if (viewModels.value.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Visão Geral')),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 4.0,
          left: 12.0,
          right: 12.0,
        ),
        child: ListenableBuilder(
          listenable: viewModels,
          builder: (context, child) {
            return ListView(
              children: [
                if (viewModels.value.elementAt(0).registers.isNotEmpty)
                  _card(
                    context,
                    viewModels.value.elementAt(0).registers,
                    'Registers',
                    widget.onJumpToRegisters,
                  ),

                if (viewModels.value.elementAt(1).areas.isNotEmpty)
                  _card(
                    context,
                    viewModels.value.elementAt(1).areas,
                    'Areas',
                    widget.onJumpToAreas,
                  ),
                if (viewModels.value.elementAt(3).cultures.isNotEmpty)
                  _card(
                    context,
                    viewModels.value.elementAt(3).cultures,
                    'Culturas',
                    widget.onJumpToCultures,
                  ),
                if (viewModels.value.elementAt(2).costs.isNotEmpty)
                  _card(
                    context,
                    viewModels.value.elementAt(2).costs,
                    'Custos',
                    widget.onJumpToCosts,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _card(context, List models, String title, toJump) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity * 8.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightGreenAccent.shade700),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: SizedBox(
                    width: title_wbox(context),
                    child: title_default(
                      '${models.length.toString()} ${title}',
                    ),
                  ),
                ),
                Row(
                  children: [
                    Tooltip(
                      preferBelow: false,
                      verticalOffset: 5,
                      decoration: BoxDecoration(color: Colors.transparent),
                      message: 'Vá para ${title}',
                      textStyle: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 10,
                      ),
                      child: IconButton(
                        iconSize: 14,
                        icon: Icon(Icons.navigation_outlined),
                        onPressed: toJump,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Último',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
                lastCard(context: context, model: models.last.toMap()),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget lastCard({
  required BuildContext context,
  required Map<String, dynamic> model,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 10.0,
      bottom: 4.0,
      left: 12.0,
      right: 12.0,
    ),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightGreen),
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (String k in model.keys.toList())
            kv_card(context: context, k: k, model: model),
        ],
      ),
    ),
  );
}
