// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lumora';

  @override
  String get disclaimerTitle => 'Hey there, let\'s talk';

  @override
  String get disclaimerText => 'There\'s no single cure for Long Covid. Keep listening to your body and don\'t just rely on technology, okay?';

  @override
  String get disclaimerButton => 'Got it, I understand';

  @override
  String get energyTitle => 'How are you feeling right now?';

  @override
  String get energyLevel1 => 'Exhausted';

  @override
  String get energyLevel2 => 'Pretty tired';

  @override
  String get energyLevel3 => 'Alright, I guess';

  @override
  String get energyLevel4 => 'Not bad';

  @override
  String get energyLevel5 => 'Feeling great';

  @override
  String get activitiesTitle => 'What have you been up to?';

  @override
  String get activityHint => 'Type what you did today...';

  @override
  String get addActivity => 'Add';

  @override
  String get saveEntry => 'Done, save this';

  @override
  String get historyTitle => 'Your journey';

  @override
  String get delete => 'Delete';

  @override
  String get noEntries => 'No entries yet. Let\'s start tracking!';

  @override
  String get symptomsTitle => 'Did you experience any symptoms?';

  @override
  String get symptomsHint => 'Pick what you\'re feeling...';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get newActivity => 'New activity';

  @override
  String get selectActivities => 'Here\'s what you picked';

  @override
  String get energyLevelsChartTitle => 'Your energy levels lately';

  @override
  String get topSymptomsChartTitle => 'Most common symptoms';

  @override
  String get topActivitiesChartTitle => 'What you\'ve been doing';

  @override
  String get recentEntriesTitle => 'Your recent entries';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String get symptomFatigue => 'fatigue';

  @override
  String get symptomBrainFog => 'brain fog';

  @override
  String get symptomDizziness => 'dizziness';

  @override
  String get symptomPain => 'pain';

  @override
  String get symptomHeadache => 'headache';

  @override
  String get symptomNausea => 'nausea';

  @override
  String get symptomShortnessOfBreath => 'shortness of breath';

  @override
  String get symptomChestPain => 'chest pain';

  @override
  String get symptomMuscleWeakness => 'muscle weakness';

  @override
  String get symptomJointPain => 'joint pain';

  @override
  String get fabAddEntry => 'Add new entry';
}
