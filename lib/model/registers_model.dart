// import 'package:caderno_do_campo/model/areas_model.dart';
// import 'package:caderno_do_campo/model/cultures_model.dart';

class RegistersModel {
  final int? id;
  final String? dateTime;
  final String? culture;
  final String? area;
  final String? activity;
  final String? responsable;
  final String? actions;

  RegistersModel({
    this.id,
    this.dateTime,
    this.culture,
    this.area,
    this.activity,
    this.responsable,
    this.actions,
  });

  factory RegistersModel.fromMap(Map<String, dynamic> map) {
    return RegistersModel(
      id: map['id'],
      dateTime: map['datetime'],
      culture: map['culture'],
      area: map['area'],
      activity: map['activity'],
      responsable: map['responsable'],
      actions: map['actions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': dateTime,
      'culture': culture,
      'area': area,
      'activity': activity,
      'responsable': responsable,
      'actions': actions,
    };
  }

  Map<String, dynamic> toMapForInsert() {
    return {
      'datetime': dateTime,
      'culture': culture,
      'area': area,
      'activity': activity,
      'responsable': responsable,
      'actions': actions,
    };
  }
}
