import 'package:flutter/material.dart';

import 'pep_input_decoration_theme.dart';

/// PEP design tokens carried on [ThemeData.extensions].
///
/// Keeps PEP text fields independent from M3 filled/outlined [InputDecorationTheme].
@immutable
class PepThemeExtension extends ThemeExtension<PepThemeExtension> {
  const PepThemeExtension({required this.inputDecoration});

  final InputDecorationThemeData inputDecoration;

  factory PepThemeExtension.from(ColorScheme colorScheme) {
    return PepThemeExtension(
      inputDecoration: PepInputDecorationTheme.build(colorScheme),
    );
  }

  static PepThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<PepThemeExtension>() ??
        PepThemeExtension.from(Theme.of(context).colorScheme);
  }

  /// Registers [PepThemeExtension] on a [ThemeData] (for reuse in other projects).
  static ThemeData apply(ThemeData theme) {
    final extensions = Map<Object, ThemeExtension<dynamic>>.from(
      theme.extensions,
    );
    extensions[PepThemeExtension] = PepThemeExtension.from(theme.colorScheme);
    return theme.copyWith(extensions: extensions.values.toList());
  }

  @override
  PepThemeExtension copyWith({InputDecorationThemeData? inputDecoration}) {
    return PepThemeExtension(
      inputDecoration: inputDecoration ?? this.inputDecoration,
    );
  }

  @override
  PepThemeExtension lerp(ThemeExtension<PepThemeExtension>? other, double t) {
    if (other is! PepThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}
