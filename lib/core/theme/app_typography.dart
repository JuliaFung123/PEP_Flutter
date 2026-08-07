import 'package:flutter/material.dart';

import 'app_fonts.dart';

/// Custom type styles beyond the M3 [TextTheme] slots.
///
/// Figma: Flutter/TitleSemiLarge — modified from Material Title Large.
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2151-98
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({required this.titleSemiLarge});

  /// Title between Title Medium (16) and Title Large (22).
  /// Noto Sans TC · 18sp / 26 · w500 · tracking 0.
  final TextStyle titleSemiLarge;

  factory AppTypography.fromTextTheme(TextTheme textTheme) {
    final base = textTheme.titleMedium ?? textTheme.titleLarge;
    return AppTypography(
      titleSemiLarge: AppFonts.style(
        textStyle: base,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 26 / 18,
        letterSpacing: 0,
      ),
    );
  }

  static AppTypography of(BuildContext context) {
    return Theme.of(context).extension<AppTypography>() ??
        AppTypography.fromTextTheme(Theme.of(context).textTheme);
  }

  @override
  AppTypography copyWith({TextStyle? titleSemiLarge}) {
    return AppTypography(
      titleSemiLarge: titleSemiLarge ?? this.titleSemiLarge,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      titleSemiLarge: TextStyle.lerp(titleSemiLarge, other.titleSemiLarge, t)!,
    );
  }
}
