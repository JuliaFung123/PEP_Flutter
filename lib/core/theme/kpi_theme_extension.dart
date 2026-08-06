import 'package:flutter/material.dart';

import 'kpi_input_decoration_theme.dart';

/// KPI design tokens carried on [ThemeData.extensions].
///
/// Keeps KPI text fields independent from M3 filled/outlined [InputDecorationTheme].
@immutable
class KpiThemeExtension extends ThemeExtension<KpiThemeExtension> {
  const KpiThemeExtension({required this.inputDecoration});

  final InputDecorationThemeData inputDecoration;

  factory KpiThemeExtension.from(ColorScheme colorScheme) {
    return KpiThemeExtension(
      inputDecoration: KpiInputDecorationTheme.build(colorScheme),
    );
  }

  static KpiThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<KpiThemeExtension>() ??
        KpiThemeExtension.from(Theme.of(context).colorScheme);
  }

  /// Registers [KpiThemeExtension] on a [ThemeData] (for reuse in other projects).
  static ThemeData apply(ThemeData theme) {
    final extensions = Map<Object, ThemeExtension<dynamic>>.from(
      theme.extensions,
    );
    extensions[KpiThemeExtension] = KpiThemeExtension.from(theme.colorScheme);
    return theme.copyWith(extensions: extensions.values.toList());
  }

  @override
  KpiThemeExtension copyWith({InputDecorationThemeData? inputDecoration}) {
    return KpiThemeExtension(
      inputDecoration: inputDecoration ?? this.inputDecoration,
    );
  }

  @override
  KpiThemeExtension lerp(ThemeExtension<KpiThemeExtension>? other, double t) {
    if (other is! KpiThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}
