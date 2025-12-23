class EnergyEntry {
  final String id;
  final DateTime date;
  final int energyLevel;
  final List<String> activities;
  final List<String> symptoms;

  EnergyEntry({
    required this.id,
    required this.date,
    required this.energyLevel,
    required this.activities,
    required this.symptoms,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'energyLevel': energyLevel,
      'activities': activities,
      'symptoms': symptoms,
    };
  }

  factory EnergyEntry.fromJson(Map<String, dynamic> json) {
    return EnergyEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      energyLevel: json['energyLevel'] as int,
      activities: List<String>.from(json['activities'] as List),
      symptoms: json['symptoms'] != null
          ? List<String>.from(json['symptoms'] as List)
          : <String>[],
    );
  }
}
