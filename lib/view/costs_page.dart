import 'package:caderno_do_campo/model/costs_model.dart';
import 'package:caderno_do_campo/model/repository/costs_repository.dart';
import 'package:caderno_do_campo/model/service/database/costs_db.dart';
import 'package:caderno_do_campo/viewmodel/costs_viewmodel.dart';
import 'package:flutter/material.dart';

class CostsPage extends StatefulWidget {
  const CostsPage({super.key});

  @override
  CostsPageState createState() => CostsPageState();
}

class CostsPageState extends State<CostsPage> {
  late final CostsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    final databaseService = CostsServiceDatabase();
    final repository = CostsRepository(databaseService: databaseService);
    viewModel = CostsViewModel(costsRepository: repository);

    viewModel.addListener(() => setState(() {}));
    viewModel.fetchCostsCommand.execute();
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
            title: const Text('Custos'),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_alt_outlined),
                iconSize: 14.0,
                tooltip: 'Filtrar',
                onPressed: () {
                  // _showAddDialog(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: IconButton(
                  icon: Icon(Icons.clear_all_outlined),
                  iconSize: 14.0,
                  tooltip: 'Remover tudo',
                  onPressed: () {
                    viewModel.deleteAllCostsCommand.execute();
                  },
                ),
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: viewModel.costs.length,
                  itemBuilder: (context, index) {
                    final cost = viewModel.costs[index];
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
                                  '${cost.category}',
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
                            Text('Data: ${cost.dateTime}'),
                            Text('Área: ${cost.area}'),
                            Text('descrição: ${cost.description}'),
                            Text('Custo: ${cost.value}'),
                            Text('Ações: ${cost.actions}'),
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
    final dateTimeController = TextEditingController();
    final areaController = TextEditingController(); // selection area.name
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final valueController = TextEditingController();
    final actionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Nova Custo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              TextField(
                controller: areaController,
                decoration: const InputDecoration(labelText: 'Área'),
              ),
              TextField(
                controller: dateTimeController,
                decoration: const InputDecoration(labelText: 'Data'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(labelText: 'Custo'),
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
              final area = CostsModel(
                category: categoryController.text.isNotEmpty
                    ? categoryController.text
                    : '',
                area: areaController.text.isNotEmpty ? areaController.text : '',
                dateTime: DateTime.now().toIso8601String(),
                description: descriptionController.text.isNotEmpty
                    ? descriptionController.text
                    : '',
                value: double.tryParse(valueController.text) ?? 0.0,
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
