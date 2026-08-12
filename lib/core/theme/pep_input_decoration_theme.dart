import 'package:flutter/material.dart';

import 'pep_theme_extension.dart';

/// PEP outlined text field decoration — surface fill plus full 4dp outline.
///
/// Consumed by [PepTextField] via [PepThemeExtension]. Portable across projects:
/// register with [PepThemeExtension.apply] on [ThemeData].
abstract final class PepInputDecorationTheme {
  static const _radius = BorderRadius.all(Radius.circular(4));

  static OutlineInputBorder _outlineBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: _radius,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  /// Builds the PEP [InputDecorationThemeData] for a [ColorScheme].
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

  /// Reads PEP input decoration from [ThemeData], with a safe fallback.
  static InputDecorationThemeData of(BuildContext context) {
    return PepThemeExtension.of(context).inputDecoration;
  }
}
