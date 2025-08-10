class CulturesModel {
  int? id;
  String name;
  String variety;
  int cycle;
  String obs;
  String actions;

  CulturesModel({
    this.id,
    required this.name,
    required this.variety,
    required this.cycle,
    required this.obs,
    required this.actions,
  });

  factory CulturesModel.fromMap(Map<String, dynamic> map) {
    return CulturesModel(
      id: map['id'] as int,
      name: map['name'] as String,
      variety: map['variety'] as String,
      cycle: map['cycle'] as int,
      obs: map['obs'] as String,
      actions: map['actions'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'variety': variety,
      'cycle': cycle,
      'obs': obs,
      'actions': actions,
    };
  }
}
