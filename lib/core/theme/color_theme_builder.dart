import 'package:flutter/material.dart';

/// Builds a full Material 3 [ColorScheme] from only primary and secondary inputs.
abstract final class ColorThemeBuilder {
  /// Generates every M3 color role using [ColorScheme.fromSeed], with primary and
  /// secondary locked to the provided values and all other roles derived by the
  /// Material dynamic color algorithm.
  static ColorScheme build({
    required Color primary,
    required Color secondary,
    Brightness brightness = Brightness.light,
    DynamicSchemeVariant variant = DynamicSchemeVariant.fidelity,
  }) {
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      dynamicSchemeVariant: variant,
      primary: primary,
      secondary: secondary,
    );
  }

  /// Dart snippet for copying generated theme values into app code.
  static String toDartSnippet({
    required Color primary,
    required Color secondary,
    required Brightness brightness,
  }) {
    final scheme = build(
      primary: primary,
      secondary: secondary,
      brightness: brightness,
    );
    final mode = brightness == Brightness.light ? 'light' : 'dark';

    return '''
// Generated $mode color scheme
ColorThemeBuilder.build(
  primary: ${_colorLiteral(primary)},
  secondary: ${_colorLiteral(secondary)},
  brightness: Brightness.$mode,
);

// Or apply directly:
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ${_colorLiteral(primary)},
    brightness: Brightness.$mode,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    primary: ${_colorLiteral(primary)},
    secondary: ${_colorLiteral(secondary)},
  ),
);

// Preview primary: ${_hex(primary)}  secondary: ${_hex(secondary)}
// Preview onPrimary: ${_hex(scheme.onPrimary)}  onSecondary: ${_hex(scheme.onSecondary)}
''';
  }

  static String _colorLiteral(Color color) {
    return 'Color(0x${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()})';
  }

  static String _hex(Color color) {
    final value = color.toARGB32() & 0xFFFFFF;
    return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
