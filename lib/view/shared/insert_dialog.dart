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
  List<String>? list,
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

  // String? selectedValue;
  ValueNotifier<TextEditingController> areaValue =
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
              if (field.key == 'areacost' && areaValue.value.text == '') {
                return TypeAheadField<String>(
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: areaValue.value,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Area',
                      ),
                    );
                  },
                  itemBuilder: (context, String suggestions) {
                    return ListTile(title: Text(suggestions));
                  },
                  onSelected: (value) {
                    areaValue.value.text = value;
                  },
                  suggestionsCallback: (String search) {
                    return list;
                  },
                );
              } else {
                return TextField(
                  controller: controllers[field.key],
                  decoration: InputDecoration(labelText: field.label),
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
                } else {
                  final text = controllers[field.key]!.text;
                  values[field.key] = text.isNotEmpty ? text : '';
                }
              }

              debugPrint('OK 0: ${values}');

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
