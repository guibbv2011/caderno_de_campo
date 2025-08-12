class AreasModel {
  int? id;
  String? name;
  double? area;
  String? location;
  int? plat;
  double? totalCost;
  String? actions;

  AreasModel({
    this.id,
    this.name,
    this.area,
    this.location,
    this.plat,
    this.totalCost,
    this.actions,
  });

  factory AreasModel.fromMap(Map<String, dynamic> map) {
    return AreasModel(
      id: map['id'] as int,
      name: map['name'] as String,
      area: map['area'] as double,
      location: map['location'] as String?,
      plat: map['plat'] as int,
      totalCost: map['total_cost'] as double?,
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
      'total_cost': totalCost,
      'actions': actions,
    };
  }

  Map<String, dynamic> toMapForInsert() {
    return {
      'name': name,
      'area': area,
      'location': location,
      'plat': plat,
      'total_cost': totalCost,
      'actions': actions,
    };
  }
}
