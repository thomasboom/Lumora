import 'package:flutter/material.dart';
import '../models/energy_entry.dart';
import '../models/insight_model.dart';

class InsightsService {
  List<WeeklySummary> getWeeklySummaries(List<EnergyEntry> entries) {
    final summaries = <WeeklySummary>[];

    final sortedEntries = List<EnergyEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    final now = DateTime.now();
    for (int week = 0; week < 4; week++) {
      final weekStart = now.subtract(Duration(days: week * 7));
      final weekEnd = weekStart.subtract(const Duration(days: 7));

      final weekEntries = sortedEntries.where((entry) {
        return entry.date.isAfter(weekEnd) &&
            entry.date.isBefore(weekStart.add(const Duration(days: 1)));
      }).toList();

      if (weekEntries.isEmpty) continue;

      final avgEnergy =
          weekEntries.fold<double>(0, (sum, e) => sum + e.energyLevel) /
          weekEntries.length;

      final activityEnergy = <String, List<double>>{};
      for (final entry in weekEntries) {
        for (final activity in entry.activities) {
          activityEnergy.putIfAbsent(activity, () => []);
          activityEnergy[activity]!.add(entry.energyLevel.toDouble());
        }
      }

      final helpfulActivities = activityEnergy.entries
          .where((e) => e.value.isNotEmpty)
          .map(
            (e) => MapEntry(
              e.key,
              e.value.reduce((a, b) => a + b) / e.value.length,
            ),
          )
          .where((e) => e.value >= avgEnergy + 0.5)
          .map((e) => e.key)
          .take(3)
          .toList();

      final symptomsAfterActivity = <String, Map<String, int>>{};
      for (int i = 1; i < weekEntries.length; i++) {
        final currentEntry = weekEntries[i];
        final previousEntry = weekEntries[i - 1];

        final hoursDiff = currentEntry.date
            .difference(previousEntry.date)
            .inHours;

        if (hoursDiff <= 24 && currentEntry.symptoms.isNotEmpty) {
          for (final activity in previousEntry.activities) {
            symptomsAfterActivity.putIfAbsent(activity, () => {});
            for (final symptom in currentEntry.symptoms) {
              symptomsAfterActivity[activity]![symptom.name] =
                  (symptomsAfterActivity[activity]![symptom.name] ?? 0) + 1;
            }
          }
        }
      }

      final triggers = <String>[];
      final activitySymptomPairs = <String, List<String>>{};

      for (final activityEntry in symptomsAfterActivity.entries) {
        final activity = activityEntry.key;
        final symptomCounts = activityEntry.value;

        for (final symptomEntry in symptomCounts.entries) {
          if (symptomEntry.value >= 2) {
            activitySymptomPairs.putIfAbsent(activity, () => []);
            activitySymptomPairs[activity]!.add(symptomEntry.key);
          }
        }
      }

      final activityCount = <String, int>{};
      for (final entry in activitySymptomPairs.entries) {
        activityCount[entry.key] = entry.value.length;
      }

      final sortedActivityCount = activityCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (final entry in sortedActivityCount.take(2)) {
        triggers.add(entry.key);
      }

      summaries.add(
        WeeklySummary(
          averageEnergy: avgEnergy,
          helpfulActivities: helpfulActivities,
          triggers: triggers,
        ),
      );
    }

    return summaries;
  }

  List<TriggerInsight> detectTriggers(List<EnergyEntry> entries) {
    final triggers = <TriggerInsight>[];

    final sortedEntries = List<EnergyEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    final activitySymptomPairs = <String, Map<String, List<int>>>{};

    for (int i = 1; i < sortedEntries.length; i++) {
      final currentEntry = sortedEntries[i];
      final previousEntry = sortedEntries[i - 1];

      final hoursDiff = currentEntry.date
          .difference(previousEntry.date)
          .inHours;

      if (hoursDiff > 0 &&
          hoursDiff <= 48 &&
          currentEntry.symptoms.isNotEmpty) {
        for (final activity in previousEntry.activities) {
          activitySymptomPairs.putIfAbsent(activity, () => {});
          for (final symptom in currentEntry.symptoms) {
            activitySymptomPairs[activity]!.putIfAbsent(symptom.name, () => []);
            activitySymptomPairs[activity]![symptom.name]!.add(hoursDiff);
          }
        }
      }
    }

    for (final activityEntry in activitySymptomPairs.entries) {
      final activity = activityEntry.key;
      final symptomData = activityEntry.value;

      for (final symptomEntry in symptomData.entries) {
        final symptom = symptomEntry.key;
        final hoursList = symptomEntry.value;

        if (hoursList.length >= 2) {
          final avgHours = hoursList.reduce((a, b) => a + b) / hoursList.length;

          triggers.add(
            TriggerInsight(
              activity: activity,
              symptom: symptom,
              occurrenceCount: hoursList.length,
              avgHoursAfter: avgHours,
            ),
          );
        }
      }
    }

    triggers.sort((a, b) => b.occurrenceCount.compareTo(a.occurrenceCount));

    return triggers.take(5).toList();
  }

  List<RecoveryTrend> getRecoveryTrends(List<EnergyEntry> entries) {
    final trends = <RecoveryTrend>[];

    final sortedEntries = List<EnergyEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    final dailyData = <DateTime, List<EnergyEntry>>{};

    for (final entry in sortedEntries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      dailyData.putIfAbsent(date, () => []);
      dailyData[date]!.add(entry);
    }

    for (final dateEntry in dailyData.entries) {
      final date = dateEntry.key;
      final dayEntries = dateEntry.value;

      final avgEnergy =
          dayEntries.fold<double>(0, (sum, e) => sum + e.energyLevel) /
          dayEntries.length;

      final totalSymptoms = dayEntries.fold<int>(
        0,
        (sum, e) => sum + e.symptoms.length,
      );

      trends.add(
        RecoveryTrend(
          date: date,
          energyLevel: avgEnergy,
          totalSymptoms: totalSymptoms,
        ),
      );
    }

    return trends;
  }

  List<InsightModel> generateInsights(List<EnergyEntry> entries) {
    final insights = <InsightModel>[];
    final summaries = getWeeklySummaries(entries);
    final triggers = detectTriggers(entries);

    if (summaries.isNotEmpty) {
      final latestSummary = summaries.first;

      if (latestSummary.helpfulActivities.isNotEmpty) {
        insights.add(
          InsightModel(
            title: 'What worked this week',
            description:
                'Activities like ${latestSummary.helpfulActivities.join(", ")} '
                'seem to boost your energy.',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
        );
      }

      if (latestSummary.triggers.isNotEmpty) {
        insights.add(
          InsightModel(
            title: 'Watch out for triggers',
            description:
                'Activities like ${latestSummary.triggers.join(", ")} '
                'may be causing symptoms.',
            icon: Icons.warning,
            color: Colors.orange,
          ),
        );
      }
    }

    for (final trigger in triggers.take(2)) {
      insights.add(
        InsightModel(
          title: 'Potential trigger detected',
          description:
              '${trigger.activity} often leads to ${trigger.symptom} '
              'within ${trigger.avgHoursAfter.round()} hours.',
          icon: Icons.bolt,
          color: Colors.red,
        ),
      );
    }

    if (insights.isEmpty) {
      insights.add(
        InsightModel(
          title: 'Keep tracking',
          description:
              'Keep logging your entries to get personalized insights.',
          icon: Icons.info,
          color: Colors.blue,
        ),
      );
    }

    return insights;
  }
}
