import 'package:flutter/material.dart';

/// M3 filled / outlined reference decoration for the component library only.
///
/// Not used in the app theme — PEP projects should use [PepInputDecorationTheme].
abstract final class M3InputDecorationTheme {
  static InputDecorationThemeData filled(ColorScheme colorScheme) {
    return InputDecorationThemeData(
      filled: true,
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.04);
        }
        return colorScheme.surfaceContainerHighest;
      }),
      constraints: const BoxConstraints(minHeight: 56),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  static InputDecorationThemeData outlined(ColorScheme colorScheme) {
    return InputDecorationThemeData(
      filled: false,
      constraints: const BoxConstraints(minHeight: 56),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }
}
