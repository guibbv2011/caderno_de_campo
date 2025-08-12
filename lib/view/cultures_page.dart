import 'package:caderno_do_campo/model/cultures_model.dart';
import 'package:caderno_do_campo/model/repository/cultures_repository.dart';
import 'package:caderno_do_campo/model/service/database/culture_db.dart';
import 'package:caderno_do_campo/viewmodel/cultures_viewmodel.dart';
import 'package:flutter/material.dart';
// import 'package:result_dart/result_dart.dart';

class CulturesPage extends StatefulWidget {
  const CulturesPage({super.key});

  @override
  CulturesPageState createState() => CulturesPageState();
}

class CulturesPageState extends State<CulturesPage> {
  late final CulturesViewModel viewModel;

  @override
  void initState() {
    super.initState();

    // Initialize the database service and repository
    final databaseService = CultureServiceDatabase();
    final repository = CulturesRepository(databaseService: databaseService);

    // Initialize the ViewModel with the repository
    viewModel = CulturesViewModel(culturesRepository: repository);

    // Add listener and fetch initial data
    viewModel.addListener(() => setState(() {}));
    viewModel.fetchCulturesCommand.execute();
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
            title: Text('Culturas'),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_alt_outlined),
                iconSize: 14.0,
                tooltip: 'Filtrar',
                onPressed: () {
                  //_showAddDialog(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: IconButton(
                  icon: Icon(Icons.clear_all_outlined),
                  iconSize: 14.0,
                  tooltip: 'Remover tudo',
                  onPressed: () {
                    viewModel.deleteAllCulturesCommand.execute();
                  },
                ),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: viewModel.cultures.length,
            itemBuilder: (context, index) {
              final culture = viewModel.cultures[index];
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
                          Text(
                            '${culture.name}',
                            style: TextStyle(fontSize: 16),
                          ),
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
                      Text('Variedade: ${culture.variety}'),
                      Text('Ciclo: ${culture.cycle}'),
                      Text('Observações: ${culture.obs}'),
                      Text('Ações: ${culture.actions}'),
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
    final varietyController = TextEditingController();
    final cycleController = TextEditingController();
    final obsController = TextEditingController();
    final actionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Nova Cultura'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: varietyController,
                decoration: const InputDecoration(labelText: 'Variedade'),
              ),
              TextField(
                controller: cycleController,
                decoration: const InputDecoration(labelText: 'Ciclo (dias)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: obsController,
                decoration: const InputDecoration(labelText: 'Observações'),
                maxLines: 2,
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
              final culture = CulturesModel(
                name: nameController.text.isNotEmpty ? nameController.text : '',
                variety: varietyController.text.isNotEmpty
                    ? varietyController.text
                    : '',
                cycle: int.tryParse(cycleController.text) ?? 0,
                obs: obsController.text.isNotEmpty ? obsController.text : '',
                actions: actionsController.text.isNotEmpty
                    ? actionsController.text
                    : '',
              );

              viewModel.onInsert(culture);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.add_task),
          ),
        ],
      ),
    );
  }
}
