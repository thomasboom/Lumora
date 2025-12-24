# Lumora

An energy tracking application designed for people living with Long COVID and chronic fatigue conditions.

## Overview

Lumora helps you monitor your energy levels, track activities, and log symptoms to identify patterns and better manage your daily energy budget. The app provides visualizations to help you understand trends over time and make informed decisions about pacing.

## Features

- **Energy Level Tracking**: Log your energy on a 5-point scale from critical to full
- **Activity Logging**: Track activities performed during each entry
- **Symptom Recording**: Log common Long COVID symptoms including fatigue, brain fog, dizziness, pain, and more
- **Visual Analytics**: 
  - Energy level trends over time
  - Most frequent symptoms chart
  - Top activities chart
- **Multi-Language Support**: Available in English and Dutch
- **Dark Theme**: Eye-friendly dark mode designed for sensitive eyes
- **Cross-Platform**: Runs on Android, iOS, Linux, macOS, Windows, and Web
- **Local Storage**: All data stays on your device

## Screenshots

The app features a clean, dark-themed interface with:
- Step-by-step entry logging flow
- Color-coded energy level indicators
- Interactive charts using FL Chart
- History view with recent entries

## Installation

### Building from Source

Prerequisites:
- Flutter SDK (3.10.4 or higher)
- Dart SDK
- Platform-specific development tools (Android Studio, Xcode, etc.)

1. Clone the repository:
```bash
git clone <repository-url>
cd Lumora
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Specific Platforms

**Android:**
```bash
flutter build apk
```

**iOS:**
```bash
flutter build ios
```

**Linux:**
```bash
flutter build linux
```

**macOS:**
```bash
flutter build macos
```

**Windows:**
```bash
flutter build windows
```

**Web:**
```bash
flutter build web
```

## Dependencies

- `flutter_localizations` - Internationalization support
- `intl` - Internationalization and localization utilities
- `shared_preferences` - Local data persistence
- `fl_chart` - Charting and visualization
- `cupertino_icons` - iOS-style icons

## Project Structure

```
lib/
├── l10n/                 # Localization files
│   ├── app_en.arb       # English translations
│   └── app_nl.arb       # Dutch translations
├── models/
│   └── energy_entry.dart # Data model for entries
├── screens/
│   ├── energy_tracker_screen.dart # Main tracker interface
│   └── disclaimer_screen.dart     # Initial disclaimer
├── services/
│   └── storage_service.dart       # Data persistence
└── main.dart             # App entry point
```

## Roadmap

Planned features include:
- Pacing & activity budgeting
- PEM (Post-Exertional Malaise) tracking with delayed symptom logging
- Symptom severity intensity sliders
- Personalized insights and trigger detection
- Recovery goals and milestones
- Daily check-in reminders
- Doctor export (PDF reports)
- Activity impact scoring
- Custom symptoms
- Wearable integration

See [roadmap.md](roadmap.md) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Disclaimer

Lumora is a tracking tool designed to help monitor symptoms and energy levels. It is not a medical device and should not be used for medical diagnosis or treatment. Always consult with your healthcare provider regarding any medical concerns or decisions.

## Privacy

All data is stored locally on your device using Flutter's shared_preferences. No data is transmitted to external servers or third parties.
