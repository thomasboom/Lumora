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
  String get disclaimerTitle => 'Important';

  @override
  String get disclaimerText => 'There\'s no one way to cure Long Covid. Keep an eye on yourself and don\'t just rely on technology.';

  @override
  String get disclaimerButton => 'Alright, I understand';

  @override
  String get energyTitle => 'How are you feeling?';

  @override
  String get energyLevel1 => 'Very tired';

  @override
  String get energyLevel2 => 'Tired';

  @override
  String get energyLevel3 => 'Okay';

  @override
  String get energyLevel4 => 'Good';

  @override
  String get energyLevel5 => 'Great';

  @override
  String get activitiesTitle => 'What did you do?';

  @override
  String get activityHint => 'Type something you did...';

  @override
  String get addActivity => 'Add';

  @override
  String get saveEntry => 'Save';

  @override
  String get historyTitle => 'History';

  @override
  String get delete => 'Delete';

  @override
  String get noEntries => 'No entries yet';
}
