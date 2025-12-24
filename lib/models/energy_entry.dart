class SymptomEntry {
  final String name;
  final int severity;
  final int duration;

  SymptomEntry({
    required this.name,
    required this.severity,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'severity': severity, 'duration': duration};
  }

  factory SymptomEntry.fromJson(Map<String, dynamic> json) {
    return SymptomEntry(
      name: json['name'] as String,
      severity: json['severity'] as int? ?? 5,
      duration: json['duration'] as int? ?? 0,
    );
  }
}

class EnergyEntry {
  final String id;
  final DateTime date;
  final int energyLevel;
  final List<String> activities;
  final List<SymptomEntry> symptoms;

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
      'symptoms': symptoms.map((s) => s.toJson()).toList(),
    };
  }

  factory EnergyEntry.fromJson(Map<String, dynamic> json) {
    return EnergyEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      energyLevel: json['energyLevel'] as int,
      activities: List<String>.from(json['activities'] as List),
      symptoms: json['symptoms'] != null
          ? (json['symptoms'] as List).map((s) {
              if (s is String) {
                return SymptomEntry(name: s, severity: 5, duration: 0);
              }
              return SymptomEntry.fromJson(s as Map<String, dynamic>);
            }).toList()
          : <SymptomEntry>[],
    );
  }
}
