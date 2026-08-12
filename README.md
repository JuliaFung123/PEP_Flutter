# PEP Flutter

Flutter app scaffold with **Material Design 3** (M3), ready for PEP development.

## Environment

| Tool | Status |
|------|--------|
| Flutter SDK | `3.44.4` (stable) at `C:\Users\hp\flutter` |
| Dart | `3.12.2` |
| Platforms | Android, iOS, Web (Chrome), Windows |

Flutter has been added to your **user PATH**. Open a **new terminal** if `flutter` is not recognized.

## Quick start

```bash
cd C:\Users\hp\Desktop\PEP_Flutter
flutter pub get
flutter run -d chrome
```

Other targets:

```bash
flutter run -d windows   # requires Visual Studio C++ workload
flutter run              # picks a connected device/emulator
```

## Project structure

```
lib/
├── main.dart                 # App entry point
├── app/
│   └── app.dart              # MaterialApp, theme mode
├── core/
│   └── theme/
│       ├── app_colors.dart   # Brand seed colors
│       └── app_theme.dart    # M3 light/dark themes
└── features/
    └── home/
        └── presentation/
            └── home_page.dart
```

## Material 3 setup

- `useMaterial3: true` with `ColorScheme.fromSeed`
- System light/dark theme via `ThemeMode.system`
- M3 components: `NavigationBar`, `FilledButton`, tonal icons, rounded cards
- Inter font via `google_fonts`

Change the brand color in `lib/core/theme/app_colors.dart`.

## Remaining setup (optional)

Run `flutter doctor` and fix any warnings:

1. **Android licenses** (if building for Android):
   ```bash
   flutter doctor --android-licenses
   ```
2. **Windows desktop builds** — install [Visual Studio](https://visualstudio.microsoft.com/downloads/) with the **Desktop development with C++** workload.

## Component library

10 M3 **atom** reference pages ([full list](https://m3.material.io/components)):

Badges · Buttons · Checkbox · Chips · Divider · Progress indicators · Radio button · Sliders · Switch · Text fields

List all atoms: `dart run tool/create_atom_pages.dart`

| Part | Purpose |
|------|---------|
| **1. Note** | Table comparing each variant to [M3 specs](https://m3.material.io/components) |
| **2. Variants** | Visual matrix (Enabled / Disabled); icon toggles |
| **3. Pending** | Layout-only elements awaiting promotion to Part 2 |

Run the app and open **Chips** from the library home.

### Create a new component page

```bash
dart run tool/create_component_page.dart buttons "Buttons" "https://m3.material.io/components/buttons/specs"
```

This scaffolds `lib/component_library/pages/<id>_component_page.dart` and registers it in `component_registry.dart`. Then fill in Parts 1–3.


```bash
flutter analyze
flutter test
flutter pub outdated
```
