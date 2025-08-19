class AreasModel {
  int? id;
  String? name;
  double? area;
  String? location;
  int? plat;
  String? actions;

  AreasModel({
    this.id,
    this.name,
    this.area,
    this.location,
    this.plat,
    this.actions,
  });

  factory AreasModel.fromMap(Map<String, dynamic> map) {
    return AreasModel(
      id: map['id'] as int,
      name: map['name'] as String,
      area: map['area'] as double,
      location: map['location'] as String?,
      plat: map['plat'] as int,
      actions: map['actions'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'location': location,
      'plat': plat,
      'actions': actions,
    };
  }

  Map<String, dynamic> toMapForInsert() {
    return {
      'name': name,
      'area': area,
      'location': location,
      'plat': plat,
      'actions': actions,
    };
  }
}
