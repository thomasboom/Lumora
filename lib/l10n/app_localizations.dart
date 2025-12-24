import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Lumora'**
  String get appTitle;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Hey there, let\'s talk'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'There\'s no single cure for Long Covid. This app is for informational purposes only and we take no responsibility for its use. Always consult a healthcare professional for medical advice. Keep listening to your body and don\'t just rely on technology.'**
  String get disclaimerText;

  /// No description provided for @disclaimerButton.
  ///
  /// In en, this message translates to:
  /// **'Got it, I understand'**
  String get disclaimerButton;

  /// No description provided for @energyTitle.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling right now?'**
  String get energyTitle;

  /// No description provided for @energyLevel1.
  ///
  /// In en, this message translates to:
  /// **'Exhausted'**
  String get energyLevel1;

  /// No description provided for @energyLevel2.
  ///
  /// In en, this message translates to:
  /// **'Pretty tired'**
  String get energyLevel2;

  /// No description provided for @energyLevel3.
  ///
  /// In en, this message translates to:
  /// **'Alright, I guess'**
  String get energyLevel3;

  /// No description provided for @energyLevel4.
  ///
  /// In en, this message translates to:
  /// **'Not bad'**
  String get energyLevel4;

  /// No description provided for @energyLevel5.
  ///
  /// In en, this message translates to:
  /// **'Feeling great'**
  String get energyLevel5;

  /// No description provided for @activitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'What have you been up to?'**
  String get activitiesTitle;

  /// No description provided for @activityHint.
  ///
  /// In en, this message translates to:
  /// **'Type what you did today...'**
  String get activityHint;

  /// No description provided for @addActivity.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addActivity;

  /// No description provided for @saveEntry.
  ///
  /// In en, this message translates to:
  /// **'Done, save this'**
  String get saveEntry;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your journey'**
  String get historyTitle;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries yet. Let\'s start tracking!'**
  String get noEntries;

  /// No description provided for @symptomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Did you experience any symptoms?'**
  String get symptomsTitle;

  /// No description provided for @symptomsHint.
  ///
  /// In en, this message translates to:
  /// **'Pick what you\'re feeling...'**
  String get symptomsHint;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @newActivity.
  ///
  /// In en, this message translates to:
  /// **'New activity'**
  String get newActivity;

  /// No description provided for @selectActivities.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what you picked'**
  String get selectActivities;

  /// No description provided for @energyLevelsChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Your energy levels lately'**
  String get energyLevelsChartTitle;

  /// No description provided for @topSymptomsChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Most common symptoms'**
  String get topSymptomsChartTitle;

  /// No description provided for @topActivitiesChartTitle.
  ///
  /// In en, this message translates to:
  /// **'What you\'ve been doing'**
  String get topActivitiesChartTitle;

  /// No description provided for @recentEntriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your recent entries'**
  String get recentEntriesTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(Object count);

  /// No description provided for @symptomFatigue.
  ///
  /// In en, this message translates to:
  /// **'fatigue'**
  String get symptomFatigue;

  /// No description provided for @symptomBrainFog.
  ///
  /// In en, this message translates to:
  /// **'brain fog'**
  String get symptomBrainFog;

  /// No description provided for @symptomDizziness.
  ///
  /// In en, this message translates to:
  /// **'dizziness'**
  String get symptomDizziness;

  /// No description provided for @symptomPain.
  ///
  /// In en, this message translates to:
  /// **'pain'**
  String get symptomPain;

  /// No description provided for @symptomHeadache.
  ///
  /// In en, this message translates to:
  /// **'headache'**
  String get symptomHeadache;

  /// No description provided for @symptomNausea.
  ///
  /// In en, this message translates to:
  /// **'nausea'**
  String get symptomNausea;

  /// No description provided for @symptomShortnessOfBreath.
  ///
  /// In en, this message translates to:
  /// **'shortness of breath'**
  String get symptomShortnessOfBreath;

  /// No description provided for @symptomChestPain.
  ///
  /// In en, this message translates to:
  /// **'chest pain'**
  String get symptomChestPain;

  /// No description provided for @symptomMuscleWeakness.
  ///
  /// In en, this message translates to:
  /// **'muscle weakness'**
  String get symptomMuscleWeakness;

  /// No description provided for @symptomJointPain.
  ///
  /// In en, this message translates to:
  /// **'joint pain'**
  String get symptomJointPain;

  /// No description provided for @fabAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Add new entry'**
  String get fabAddEntry;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'nl': return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
