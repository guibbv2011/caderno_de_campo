class AreasModel {
  String id;
  String name;
  String area;
  String location;
  String plat;
  double totalCost;
  List<String> actions;

  AreasModel({
    required this.id,
    required this.name,
    required this.area,
    required this.location,
    required this.plat,
    required this.totalCost,
    required this.actions,
  });

  factory AreasModel.fromMap(Map<String, dynamic> map) {
    return AreasModel(
      id: map['id'],
      name: map['name'],
      area: map['area'],
      location: map['location'],
      plat: map['plat'],
      totalCost: map['totalCost'],
      actions: List<String>.from(map['actions']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'location': location,
      'plat': plat,
      'totalCost': totalCost,
      'actions': actions,
    };
  }
}
