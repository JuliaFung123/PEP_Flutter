import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Holds user-selected brand colors that drive the live app theme.
class AppThemeController extends ChangeNotifier {
  AppThemeController({
    this._primary = AppColors.seed,
    this._secondary = AppColors.secondarySeed,
  });

  Color _primary;
  Color _secondary;

  Color get primary => _primary;
  Color get secondary => _secondary;

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
