import 'package:caderno_do_campo/model/areas_model.dart';
import 'package:caderno_do_campo/view/shared/insert_dialog.dart';
import 'package:caderno_do_campo/view/shared/update_dialog.dart';
import 'package:caderno_do_campo/viewmodel/areas_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AreasPage extends StatefulWidget {
  final AreasViewModel viewModel;
  const AreasPage({super.key, required this.viewModel});

  @override
  AreasPageState createState() => AreasPageState();
}

class AreasPageState extends State<AreasPage> {
  @override
  void initState() {
    widget.viewModel.addListener(() => setState(() {}));
    widget.viewModel.fetchAreasCommand.execute();
    super.initState();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(() => setState(() {}));
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Áreas'),
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
            itemCount: widget.viewModel.areas.length,
            itemBuilder: (context, index) {
              final area = widget.viewModel.areas[index];
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
                                onPressed: () {
                                  _showUpdateDialog(
                                    context,
                                    area,
                                    widget.viewModel,
                                  );
                                },
                              ),
                              IconButton(
                                iconSize: 14,
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  widget.viewModel.onDelete(area.id!);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('Área: ${area.area}'),
                      Text('Local: ${area.location}'),
                      Text('Canteiros: ${area.plat}'),
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
              _showAddDialog(context, widget.viewModel);
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

void _showAddDialog(BuildContext context, AreasViewModel viewModel) {
  showInsertDialog(
    context: context,
    title: 'Adicionar',
    fields: [
      InsertDialog(key: 'name', label: 'Nome', initialValue: ''),
      InsertDialog(
        key: 'area',
        label: 'Área (m²)',
        initialValue: '',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      ),
      InsertDialog(key: 'location', label: 'Localização', initialValue: ''),
      InsertDialog(
        key: 'plat',
        label: 'Canteiros',
        initialValue: '',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      ),
      InsertDialog(key: 'actions', label: 'Ações', initialValue: ''),
    ],
    modelBuilder: (area) => AreasModel(
      name: area['name'] ?? '',
      area: double.tryParse(area['area'].toString()) ?? 0.0,
      location: area['location'] ?? '',
      plat: int.tryParse(area['plat'].toString()) ?? 0,
      actions: area['actions'] ?? '',
    ),
    onInsert: (area) => viewModel.onInsert(area),
  );
}

void _showUpdateDialog(
  BuildContext context,
  AreasModel model,
  AreasViewModel viewModel,
) {
  showUpdateDialog(
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
        key: 'area',
        label: 'Área (m²)',
        initialValue: model.area.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      ),
      UpdateDialog(
        key: 'location',
        label: 'Localização',
        initialValue: model.location!,
      ),
      UpdateDialog(
        key: 'plat',
        label: 'Canteiros',
        initialValue: model.plat.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      ),
      UpdateDialog(
        key: 'actions',
        label: 'Ações',
        initialValue: model.actions!,
      ),
    ],
    modelBuilder: (area) => AreasModel(
      id: int.tryParse(area['id'].toString()) ?? 0,
      name: area['name'] ?? '',
      area: double.tryParse(area['area'].toString()) ?? 0.0,
      location: area['location'] ?? '',
      plat: int.tryParse(area['plat'].toString()) ?? 0,
      actions: area['actions'] ?? '',
    ),
    onUpdate: (area) => viewModel.onUpdate(area),
  );
}
