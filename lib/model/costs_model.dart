class CostsModel {
  int? id;
  String? dateTime; // DateTime
  String? area;
  String? category; // Insumo | operacional | fixo
  String? description;
  double? value;
  String? actions;

  CostsModel({
    this.id,
    this.dateTime,
    this.area,
    this.category,
    this.description,
    this.value,
    this.actions,
  });

  factory CostsModel.fromMap(Map<String, dynamic> map) {
    return CostsModel(
      id: map['id'],
      dateTime: map['date_time'],
      area: map['area'],
      category: map['category'],
      description: map['description'],
      value: map['value'],
      actions: map['actions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date_time': dateTime,
      'area': area,
      'category': category,
      'description': description,
      'value': value,
      'actions': actions,
    };
  }

  Map<String, dynamic> toMapForInsert() {
    return {
      'date_time': dateTime,
      'area': area,
      'category': category,
      'description': description,
      'value': value,
      'actions': actions,
    };
  }
}
