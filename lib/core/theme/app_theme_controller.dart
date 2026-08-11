import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Holds user-selected brand colors and brightness that drive the live app theme.
class AppThemeController extends ChangeNotifier {
  AppThemeController({
    this._primary = AppColors.seed,
    this._secondary = AppColors.secondarySeed,
    this._themeMode = ThemeMode.system,
  });

  Color _primary;
  Color _secondary;
  ThemeMode _themeMode;

  Color get primary => _primary;
  Color get secondary => _secondary;
  ThemeMode get themeMode => _themeMode;

  /// Whether dark theme is active for [context] (resolves [ThemeMode.system]).
  bool isDark(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void setDarkMode(bool dark) {
    setThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }

  void setPrimary(Color color) {
    if (_primary == color) return;
    _primary = color;
    notifyListeners();
  }

  void setSecondary(Color color) {
    if (_secondary == color) return;
    _secondary = color;
    notifyListeners();
  }

  void setColors({Color? primary, Color? secondary}) {
    var changed = false;
    if (primary != null && _primary != primary) {
      _primary = primary;
      changed = true;
    }
    if (secondary != null && _secondary != secondary) {
      _secondary = secondary;
      changed = true;
    }
    if (changed) notifyListeners();
  }
}
