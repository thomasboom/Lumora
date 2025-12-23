class EnergyEntry {
  final String id;
  final DateTime date;
  final int energyLevel;
  final List<String> activities;

  EnergyEntry({
    required this.id,
    required this.date,
    required this.energyLevel,
    required this.activities,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'energyLevel': energyLevel,
      'activities': activities,
    };
  }

  factory EnergyEntry.fromJson(Map<String, dynamic> json) {
    return EnergyEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      energyLevel: json['energyLevel'] as int,
      activities: List<String>.from(json['activities'] as List),
    );
  }
}
