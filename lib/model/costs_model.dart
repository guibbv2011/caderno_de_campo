class CostsModel {
  int id;
  String data;
  String area;
  String category;
  String description;
  double value;
  List<String> actions;

  CostsModel({
    required this.id,
    required this.data,
    required this.area,
    required this.category,
    required this.description,
    required this.value,
    required this.actions,
  });

  factory CostsModel.fromMap(Map<String, dynamic> map) {
    return CostsModel(
      id: map['id'],
      data: map['data'],
      area: map['area'],
      category: map['category'],
      description: map['description'],
      value: map['value'],
      actions: List<String>.from(map['actions']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'area': area,
      'category': category,
      'description': description,
      'value': value,
      'actions': actions,
    };
  }
}
