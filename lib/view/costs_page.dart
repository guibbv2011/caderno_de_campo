import 'package:caderno_do_campo/model/costs_model.dart';
import 'package:caderno_do_campo/model/repository/database/costs_repository.dart';
import 'package:caderno_do_campo/model/service/database/costs_db.dart';
import 'package:caderno_do_campo/view/shared/insert_dialog.dart';
import 'package:caderno_do_campo/view/shared/update_dialog.dart';
import 'package:caderno_do_campo/viewmodel/costs_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                    viewModel.onDeleteAll();
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
                                      onPressed: () {
                                        _showUpdateDialog(
                                          context,
                                          cost,
                                          viewModel,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      iconSize: 14,
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        viewModel.onDelete(cost.id!);
                                      },
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
              _showAddDialog(context, viewModel);
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

void _showAddDialog(BuildContext context, CostsViewModel viewModel) {
  showInsertDialog<CostsModel>(
    context: context,
    title: 'Adicionar',
    fields: [
      InsertDialog(
        key: 'dateTime',
        label: 'Data',
        initialValue: DateTime.now().toString(),
      ),
      InsertDialog(key: 'area', label: 'Área', initialValue: ''),
      InsertDialog(key: 'category', label: 'Categoria', initialValue: ''),
      InsertDialog(key: 'description', label: 'Descrição', initialValue: ''),
      InsertDialog(
        key: 'value',
        label: 'Valor',
        initialValue: '',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      InsertDialog(key: 'actions', label: 'Ações', initialValue: ''),
    ],
    modelBuilder: (cost) => CostsModel(
      dateTime: DateTime.now().toString(),
      area: cost['area'] ?? '',
      category: cost['category'] ?? '',
      description: cost['description'] ?? '',
      value: double.tryParse(cost['value'].toString()) ?? 0.0,
      actions: cost['actions'] ?? '',
    ),
    onInsert: (cost) => viewModel.onInsert(cost),
  );
}

void _showUpdateDialog(
  BuildContext context,
  CostsModel model,
  CostsViewModel viewModel,
) {
  showUpdateDialog<CostsModel>(
    context: context,
    model: model,
    title: 'Atualizar',
    fields: [
      UpdateDialog(
        key: 'id',
        label: 'ID',
        initialValue: model.id.toString(),
        enabled: false,
      ),
      UpdateDialog(
        key: 'dateTime',
        label: 'Data',
        initialValue: model.dateTime!.toString(),
      ),
      UpdateDialog(key: 'area', label: 'Área', initialValue: model.area!),
      UpdateDialog(
        key: 'category',
        label: 'Categoria',
        initialValue: model.category!,
      ),
      UpdateDialog(
        key: 'description',
        label: 'Descrição',
        initialValue: model.description!,
      ),
      UpdateDialog(
        key: 'value',
        label: 'Valor',
        initialValue: model.value.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      UpdateDialog(
        key: 'actions',
        label: 'Ações',
        initialValue: model.actions!,
      ),
    ],
    modelBuilder: (cost) => CostsModel(
      id: int.tryParse(cost['id']!),
      dateTime: cost['dateTime']!,
      area: cost['area']!,
      category: cost['category']!,
      description: cost['description']!,
      value: double.tryParse(cost['value']!.toString()) ?? 0.0,
      actions: cost['actions']!,
    ),
    onUpdate: (cost) => viewModel.onUpdate(cost),
  );
}
