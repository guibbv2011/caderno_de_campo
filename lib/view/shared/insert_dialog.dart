import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class InsertDialog {
  final String key;
  final String label;
  final String initialValue;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  InsertDialog({
    required this.key,
    required this.label,
    required this.initialValue,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
  });
}

void showInsertDialog<T>({
  required BuildContext context,
  Set<List<String>>? lists,
  model,
  required String title,
  required List<InsertDialog> fields,
  required T Function(Map<String, String> values) modelBuilder,
  required void Function(T model) onInsert,
}) {
  final controllers = <String, TextEditingController>{};
  for (var field in fields) {
    controllers[field.key] = TextEditingController(text: field.initialValue);
  }

  ValueNotifier<TextEditingController> areaValue =
      ValueNotifier<TextEditingController>(TextEditingController(text: ''));
  ValueNotifier<TextEditingController> cultureValue =
      ValueNotifier<TextEditingController>(TextEditingController(text: ''));
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: fields.map((field) {
              if (field.key == 'arearegister' || field.key == 'areacost') {
                return TypeAheadField<String>(
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: areaValue.value,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Area',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, String suggestions) {
                    return ListTile(
                      title: Text(suggestions),
                      splashColor: Colors.grey,
                      hoverColor: Colors.grey.shade500,
                      tileColor: Colors.black,
                      shape: BorderDirectional(
                        bottom: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    );
                  },
                  onSelected: (value) {
                    areaValue.value.text = value;
                  },
                  suggestionsCallback: (String search) {
                    return lists!.first;
                  },
                );
              } else if (field.key == 'cultureregister') {
                return TypeAheadField<String>(
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: cultureValue.value,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Cultura',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, String suggestions) {
                    return ListTile(
                      title: Text(suggestions),
                      splashColor: Colors.grey,
                      hoverColor: Colors.grey.shade500,
                      tileColor: Colors.black,
                      shape: BorderDirectional(
                        bottom: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    );
                  },
                  onSelected: (value) {
                    cultureValue.value.text = value;
                  },
                  suggestionsCallback: (String search) {
                    return lists!.last;
                  },
                );
              } else {
                return TextField(
                  controller: controllers[field.key],
                  decoration: InputDecoration(
                    labelText: field.label,
                    labelStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  enabled: field.enabled,
                  keyboardType: field.keyboardType,
                  inputFormatters: [],
                );
              }
            }).toList(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.cancel_outlined),
          ),
          IconButton(
            onPressed: () {
              final values = <String, String>{};
              for (var field in fields) {
                if (field.key == 'areacost') {
                  values['area'] = areaValue.value.text.isNotEmpty
                      ? areaValue.value.text
                      : '';
                } else if (field.key == 'arearegister') {
                  values['area'] = areaValue.value.text.isNotEmpty
                      ? areaValue.value.text
                      : '';
                } else if (field.key == 'cultureregister') {
                  values['culture'] = cultureValue.value.text.isNotEmpty
                      ? cultureValue.value.text
                      : '';
                } else {
                  final text = controllers[field.key]!.text;
                  values[field.key] = text.isNotEmpty ? text : '';
                }
              }

              final insertModel = modelBuilder(values);
              onInsert(insertModel);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.add_task),
          ),
        ],
      );
    },
  );
}
