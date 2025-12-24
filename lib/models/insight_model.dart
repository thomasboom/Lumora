import 'package:flutter/material.dart';

class InsightModel {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  InsightModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class WeeklySummary {
  final double averageEnergy;
  final List<String> helpfulActivities;
  final List<String> triggers;

  WeeklySummary({
    required this.averageEnergy,
    required this.helpfulActivities,
    required this.triggers,
  });
}

class TriggerInsight {
  final String activity;
  final String symptom;
  final int occurrenceCount;
  final double avgHoursAfter;

  TriggerInsight({
    required this.activity,
    required this.symptom,
    required this.occurrenceCount,
    required this.avgHoursAfter,
  });
}

class RecoveryTrend {
  final DateTime date;
  final double energyLevel;
  final int totalSymptoms;

  RecoveryTrend({
    required this.date,
    required this.energyLevel,
    required this.totalSymptoms,
  });
}
