import 'package:flutter/material.dart';

import 'kpi_theme_extension.dart';

/// KPI outlined text field decoration — surface fill plus full 4dp outline.
///
/// Consumed by [KpiTextField] via [KpiThemeExtension]. Portable across projects:
/// register with [KpiThemeExtension.apply] on [ThemeData].
abstract final class KpiInputDecorationTheme {
  static const _radius = BorderRadius.all(Radius.circular(4));

  static OutlineInputBorder _outlineBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: _radius,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  /// Builds the KPI [InputDecorationThemeData] for a [ColorScheme].
  static InputDecorationThemeData build(ColorScheme colorScheme) {
    final disabledOutline =
        colorScheme.onSurface.withValues(alpha: 0.12);

    return InputDecorationThemeData(
      filled: true,
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.04);
        }
        return colorScheme.surfaceContainerLowest;
      }),
      constraints: const BoxConstraints(minHeight: 56),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: _outlineBorder(colorScheme.outline),
      enabledBorder: _outlineBorder(colorScheme.outline),
      focusedBorder: _outlineBorder(colorScheme.primary, width: 2),
      errorBorder: _outlineBorder(colorScheme.error),
      focusedErrorBorder: _outlineBorder(colorScheme.error, width: 2),
      disabledBorder: _outlineBorder(disabledOutline),
      prefixIconConstraints:
          const BoxConstraints(minWidth: 48, minHeight: 48),
      suffixIconConstraints:
          const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }

  /// Reads KPI input decoration from [ThemeData], with a safe fallback.
  static InputDecorationThemeData of(BuildContext context) {
    return KpiThemeExtension.of(context).inputDecoration;
  }
}
