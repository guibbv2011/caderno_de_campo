import 'package:caderno_do_campo/model/areas_model.dart';
import 'package:caderno_do_campo/model/repository/areas_repository.dart';
import 'package:caderno_do_campo/model/service/database/areas_db.dart';
import 'package:caderno_do_campo/viewmodel/areas_viewmodel.dart';
import 'package:flutter/material.dart';

class AreasPage extends StatefulWidget {
  const AreasPage({super.key});

  @override
  AreasPageState createState() => AreasPageState();
}

class AreasPageState extends State<AreasPage> {
  late final AreasViewModel viewModel;

  @override
  void initState() {
    super.initState();
    final databaseService = AreasServiceDatabase();
    final repository = AreasRepository(databaseService: databaseService);
    viewModel = AreasViewModel(areasRepository: repository);

    viewModel.addListener(() => setState(() {}));
    viewModel.fetchAreasCommand.execute();
  }

  @override
  void dispose() {
    viewModel.removeListener(() => setState(() {}));
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Áreas'),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_alt_outlined),
                iconSize: 14.0,
                tooltip: 'Filtrar',
                onPressed: () {
                  _showAddDialog(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: IconButton(
                  icon: Icon(Icons.clear_all_outlined),
                  iconSize: 14.0,
                  tooltip: 'Remover tudo',
                  onPressed: () {
                    viewModel.deleteAllAreasCommand.execute();
                  },
                ),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: viewModel.areas.length,
            itemBuilder: (context, index) {
              final area = viewModel.areas[index];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${area.name}', style: TextStyle(fontSize: 16)),
                          Row(
                            children: [
                              IconButton(
                                iconSize: 14,
                                icon: Icon(Icons.edit),
                                onPressed: () {},
                              ),
                              IconButton(
                                iconSize: 14,
                                icon: Icon(Icons.delete),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('Área: ${area.area}'),
                      Text('Local: ${area.location}'),
                      Text('Canteiros: ${area.plat}'),
                      Text('Custo total: ${area.totalCost}'),
                      Text('Ações: ${area.actions}'),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            onPressed: () {
              _showAddDialog(context);
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final areaController = TextEditingController();
    final locationController = TextEditingController();
    final platController = TextEditingController();
    final totalCostController = TextEditingController();
    final actionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Nova Área'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: areaController,
                decoration: const InputDecoration(labelText: 'Área'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Local'),
              ),
              TextField(
                controller: platController,
                decoration: const InputDecoration(labelText: 'Canteiros'),
              ),
              TextField(
                controller: totalCostController,
                decoration: const InputDecoration(labelText: 'Custo total'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: actionsController,
                decoration: const InputDecoration(labelText: 'Ações'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.cancel_outlined),
          ),
          IconButton(
            onPressed: () {
              final area = AreasModel(
                name: nameController.text.isNotEmpty ? nameController.text : '',
                area: double.tryParse(areaController.text) ?? 0.0,
                location: locationController.text.isNotEmpty
                    ? locationController.text
                    : '',
                plat: int.tryParse(platController.text) ?? 0,
                totalCost: double.tryParse(totalCostController.text) ?? 0.0,
                actions: actionsController.text.isNotEmpty
                    ? actionsController.text
                    : '',
              );

              viewModel.onInsert(area);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.add_task),
          ),
        ],
      ),
    );
  }
}
