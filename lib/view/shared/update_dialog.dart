// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateDialog {
  final String key;
  final String label;
  final String initialValue;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  // final int? maxLines;

  UpdateDialog({
    required this.key,
    required this.label,
    required this.initialValue,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    // this.maxLines = 1,
  });
}

void showUpdateDialog<T>({
  required BuildContext context,
  required T model,
  required String title,
  required List<UpdateDialog> fields,
  required T Function(Map<String, String> values) modelBuilder,
  required void Function(T) onUpdate,
}) {
  // Create controllers dynamically from fields
  final controllers = <String, TextEditingController>{};
  for (var field in fields) {
    controllers[field.key] = TextEditingController(text: field.initialValue);
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: fields.map((field) {
            return TextField(
              controller: controllers[field.key],
              decoration: InputDecoration(labelText: field.label),
              enabled: field.enabled,
              keyboardType: field.keyboardType,
              inputFormatters: field.inputFormatters ?? [],
              // maxLines: field.maxLines,
            );
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
            // Collect updated values into a map
            final values = <String, String>{};
            for (var field in fields) {
              final text = controllers[field.key]!.text;
              values[field.key] = text.isNotEmpty
                  ? text
                  : ''; // Handle empty as ''
            }

            // Build the updated model
            final updatedModel = modelBuilder(values);

            // Call the update callback
            onUpdate(updatedModel);

            // Close the dialog
            Navigator.pop(context);
          },
          icon: const Icon(Icons.cached_outlined),
        ),
      ],
    ),
  );
}
