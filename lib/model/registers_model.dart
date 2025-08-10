import 'package:caderno_do_campo/model/areas_model.dart';
import 'package:caderno_do_campo/model/cultures_model.dart';

class Register {
  final String id;
  final String data;
  final CulturesModel culture;
  final AreasModel area;
  final String activity;
  final String responsable;
  final List<String> actions;

  Register({
    required this.id,
    required this.data,
    required this.culture,
    required this.area,
    required this.activity,
    required this.responsable,
    required this.actions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'culture': culture.toMap(),
      'area': area.toMap(),
      'activity': activity,
      'responsable': responsable,
      'actions': actions,
    };
  }
}
