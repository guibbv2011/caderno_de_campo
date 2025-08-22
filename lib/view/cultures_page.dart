import 'package:caderno_do_campo/model/cultures_model.dart';
import 'package:caderno_do_campo/model/repository/database/cultures_repository.dart';
import 'package:caderno_do_campo/model/service/database/culture_db.dart';
import 'package:caderno_do_campo/view/shared/insert_dialog.dart';
import 'package:caderno_do_campo/view/shared/update_dialog.dart';
import 'package:caderno_do_campo/viewmodel/cultures_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    final databaseService = CultureServiceDatabase();
    final repository = CulturesRepository(databaseService: databaseService);

    viewModel = CulturesViewModel(culturesRepository: repository);

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
                                onPressed: () {
                                  _showUpdateDialog(
                                    context,
                                    culture,
                                    viewModel,
                                  );
                                },
                              ),
                              IconButton(
                                iconSize: 14,
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  viewModel.onDelete(culture.id!);
                                },
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
              _showAddDialog(context, viewModel);
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

void _showAddDialog(BuildContext context, CulturesViewModel viewModel) {
  showInsertDialog<CulturesModel>(
    context: context,
    title: 'Adicionar',
    fields: [
      InsertDialog(key: 'name', label: 'Nome', initialValue: ''),
      InsertDialog(key: 'variety', label: 'Variedade', initialValue: ''),
      InsertDialog(
        key: 'cycle',
        label: 'Ciclo (dias)',
        initialValue: '',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      ),
      InsertDialog(key: 'obs', label: 'Observações', initialValue: ''),
      InsertDialog(key: 'actions', label: 'Ações', initialValue: ''),
    ],
    modelBuilder: (culture) => CulturesModel(
      name: culture['name'] ?? '',
      variety: culture['variety'] ?? '',
      cycle: int.tryParse(culture['cycle']!) ?? 0,
      obs: culture['obs'] ?? '',
      actions: culture['actions'] ?? '',
    ),

    onInsert: (culture) async {
      viewModel.onInsert(culture);
    },
  );
}

void _showUpdateDialog(
  BuildContext context,
  CulturesModel model,
  CulturesViewModel viewModel,
) {
  showUpdateDialog<CulturesModel>(
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
      UpdateDialog(key: 'name', label: 'Nome', initialValue: model.name!),
      UpdateDialog(
        key: 'variety',
        label: 'Variedade',
        initialValue: model.variety!,
      ),
      UpdateDialog(
        key: 'cycle',
        label: 'Ciclo (dias)',
        initialValue: model.cycle.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      ),
      UpdateDialog(key: 'obs', label: 'Observações', initialValue: model.obs!),
      UpdateDialog(
        key: 'actions',
        label: 'Ações',
        initialValue: model.actions!,
      ),
    ],

    modelBuilder: (culture) => CulturesModel(
      id: int.tryParse(culture['id']!),
      name: culture['name']!,
      variety: culture['variety']!,
      cycle: int.tryParse(culture['cycle']!),
      obs: culture['obs']!,
      actions: culture['actions']!,
    ),

    onUpdate: (culture) {
      viewModel.onUpdate(culture);
    },
  );
}
