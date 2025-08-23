import 'package:caderno_do_campo/model/registers_model.dart';
import 'package:caderno_do_campo/model/repository/database/list_titles_repository.dart';
import 'package:caderno_do_campo/view/shared/insert_dialog.dart';
import 'package:caderno_do_campo/view/shared/update_dialog.dart';
import 'package:caderno_do_campo/viewmodel/list_titles_viewmodel.dart';
import 'package:caderno_do_campo/viewmodel/registers_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistersPage extends StatefulWidget {
  final RegistersViewModel viewModel;
  const RegistersPage({super.key, required this.viewModel});
  @override
  RegistersPageState createState() => RegistersPageState();
}

class RegistersPageState extends State<RegistersPage> {
  late final ListTitlesViewModel viewModelAreaTitles;
  late final ListTitlesViewModel viewModelCultureTitles;

  @override
  void initState() {
    final listRepository = ListTitlesRepository();
    viewModelAreaTitles = ListTitlesViewModel(
      listTitleRepository: listRepository,
    );
    viewModelCultureTitles = ListTitlesViewModel(
      listTitleRepository: listRepository,
    );

    widget.viewModel.addListener(() => setState(() {}));
    viewModelAreaTitles.addListener(() => setState(() {}));
    viewModelCultureTitles.addListener(() => setState(() {}));

    widget.viewModel.fetchRegistersCommand.execute();
    viewModelAreaTitles.fetchAreasTitlesCommand.execute();
    viewModelCultureTitles.fetchCulturesTitlesCommand.execute();
    super.initState();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(() => setState(() {}));
    viewModelAreaTitles.removeListener(() => setState(() {}));
    viewModelCultureTitles.removeListener(() => setState(() {}));

    widget.viewModel.dispose();
    viewModelAreaTitles.dispose();
    viewModelCultureTitles.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Registros'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: IconButton(
                  icon: Icon(Icons.clear_all_outlined),
                  iconSize: 14.0,
                  tooltip: 'Remover tudo',
                  onPressed: () {
                    widget.viewModel.onDeleteAll();
                  },
                ),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: widget.viewModel.registers.length,
            itemBuilder: (context, index) {
              final register = widget.viewModel.registers[index];
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
                            '${register.activity}',
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
                                    register,
                                    widget.viewModel,
                                  );
                                },
                              ),
                              IconButton(
                                iconSize: 14,
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  widget.viewModel.onDelete(register.id!);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('Data: ${register.dateTime}'),
                      Text('Cultura: ${register.culture}'),
                      Text('Área: ${register.area}'),
                      Text('responsable: ${register.responsable}'),
                      Text('Ações: ${register.actions}'),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            onPressed: () {
              viewModelAreaTitles.fetchAreasTitlesCommand
                  .execute()
                  .whenComplete(
                    () => viewModelCultureTitles.fetchCulturesTitlesCommand
                        .execute()
                        .whenComplete(
                          () => _showAddDialog(
                            context,
                            widget.viewModel,
                            viewModelAreaTitles.listAreas!,
                            viewModelCultureTitles.listCultures!,
                          ),
                        ),
                  );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

void _showAddDialog(
  BuildContext context,
  RegistersViewModel viewModel,
  List<String> listAreas,
  List<String> listCultures,
) {
  final DateTime now = DateTime.now();
  final DateFormat format = DateFormat('dd/MM/yyyy hh:mm');

  showInsertDialog<RegistersModel>(
    context: context,
    lists: {listAreas, listCultures},
    title: 'Adicionar',
    fields: [
      InsertDialog(
        key: 'datetime',
        label: 'Data',
        initialValue: format.format(now).toString(),
      ),
      InsertDialog(key: 'activity', label: 'Atividade', initialValue: ''),
      InsertDialog(key: 'arearegister', label: 'Área', initialValue: ''),
      InsertDialog(key: 'cultureregister', label: 'Cultura', initialValue: ''),
      InsertDialog(key: 'responsable', label: 'Responsável', initialValue: ''),
      InsertDialog(key: 'actions', label: 'Ações', initialValue: ''),
    ],
    modelBuilder: (register) => RegistersModel(
      dateTime: register['datetime'],
      activity: register['activity'] ?? '',
      area: register['area'] ?? '',
      culture: register['culture'] ?? '',
      responsable: register['responsable'] ?? '',
      actions: register['actions'] ?? '',
    ),
    onInsert: (register) => viewModel.onInsert(register),
  );
}

void _showUpdateDialog(
  BuildContext context,
  RegistersModel model,
  RegistersViewModel viewModel,
) {
  showUpdateDialog<RegistersModel>(
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
        key: 'datetime',
        label: 'Data',
        initialValue: model.dateTime!.toString(),
      ),
      UpdateDialog(
        key: 'activity',
        label: 'Atividade',
        initialValue: model.activity!,
      ),
      UpdateDialog(key: 'area', label: 'Área', initialValue: model.area!),
      UpdateDialog(
        key: 'culture',
        label: 'Cultura',
        initialValue: model.culture!,
      ),
      UpdateDialog(
        key: 'responsable',
        label: 'Responsável',
        initialValue: model.responsable!,
      ),
      UpdateDialog(
        key: 'actions',
        label: 'Ações',
        initialValue: model.actions!,
      ),
    ],
    modelBuilder: (register) => RegistersModel(
      id: int.tryParse(register['id']!),
      dateTime: register['datetime']!,
      activity: register['activity']!,
      area: register['area']!,
      culture: register['culture']!,
      responsable: register['responsable']!,
      actions: register['actions']!,
    ),
    onUpdate: (reguster) => viewModel.onUpdate(reguster),
  );
}
