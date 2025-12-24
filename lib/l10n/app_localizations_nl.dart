// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Lumora';

  @override
  String get disclaimerTitle => 'Hé, laten we even praten';

  @override
  String get disclaimerText => 'Er is geen enkel middel tegen Long Covid. Deze app is alleen voor informatieve doeleinden en wij aanvaarden geen verantwoordelijkheid voor het gebruik ervan. Raadpleeg altijd een zorgprofessional voor medisch advies. Luister goed naar je lichaam en vertrouw niet alleen op technologie.';

  @override
  String get disclaimerButton => 'Begrepen, ik snap het';

  @override
  String get energyTitle => 'Hoe voel je je nu?';

  @override
  String get energyLevel1 => 'Helemaal uitgeput';

  @override
  String get energyLevel2 => 'Best moe';

  @override
  String get energyLevel3 => 'Nou ja, het gaat';

  @override
  String get energyLevel4 => 'Niet slecht';

  @override
  String get energyLevel5 => 'Top gevoel';

  @override
  String get activitiesTitle => 'Wat heb je gedaan?';

  @override
  String get activityHint => 'Typ wat je vandaag hebt gedaan...';

  @override
  String get addActivity => 'Toevoegen';

  @override
  String get saveEntry => 'Klaar, opslaan';

  @override
  String get historyTitle => 'Jouw reis';

  @override
  String get delete => 'Verwijderen';

  @override
  String get noEntries => 'Nog geen vermeldingen. Laten we beginnen!';

  @override
  String get symptomsTitle => 'Heb je symptomen ervaren?';

  @override
  String get symptomsHint => 'Kies wat je voelt...';

  @override
  String get next => 'Volgende';

  @override
  String get back => 'Terug';

  @override
  String get newActivity => 'Nieuwe activiteit';

  @override
  String get selectActivities => 'Dit heb je gekozen';

  @override
  String get energyLevelsChartTitle => 'Je energieniveau recent';

  @override
  String get topSymptomsChartTitle => 'Meest voorkomende symptomen';

  @override
  String get topActivitiesChartTitle => 'Wat je hebt gedaan';

  @override
  String get recentEntriesTitle => 'Je recente vermeldingen';

  @override
  String get today => 'Vandaag';

  @override
  String get yesterday => 'Gisteren';

  @override
  String daysAgo(Object count) {
    return '$count dagen geleden';
  }

  @override
  String get symptomFatigue => 'vermoeidheid';

  @override
  String get symptomBrainFog => 'hersenmist';

  @override
  String get symptomDizziness => 'duizeligheid';

  @override
  String get symptomPain => 'pijn';

  @override
  String get symptomHeadache => 'hoofdpijn';

  @override
  String get symptomNausea => 'misselijkheid';

  @override
  String get symptomShortnessOfBreath => 'kortademigheid';

  @override
  String get symptomChestPain => 'pijn op de borst';

  @override
  String get symptomMuscleWeakness => 'spierzwakte';

  @override
  String get symptomJointPain => 'gewrichtspijn';

  @override
  String get fabAddEntry => 'Nieuwe vermelding';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get dataSection => 'Gegevens';

  @override
  String get deleteAllDataTitle => 'Alle gegevens verwijderen';

  @override
  String get deleteAllDataSubtitle => 'Hiermee worden al je vermeldingen permanent verwijderd';

  @override
  String get deleteAllDataConfirmation => 'Weet je zeker dat je al je gegevens wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get dataDeleted => 'Alle gegevens zijn verwijderd';

  @override
  String get appSection => 'App';

  @override
  String get aboutTitle => 'Over';

  @override
  String get appName => 'Lumora';

  @override
  String get version => 'Versie';

  @override
  String get build => 'Bouw';

  @override
  String get close => 'Sluiten';

  @override
  String get cancel => 'Annuleren';

  @override
  String get reshowDisclaimer => 'Disclaimer opnieuw tonen';

  @override
  String get reshowDisclaimerSubtitle => 'Toon de disclaimer bij de volgende start';
}
