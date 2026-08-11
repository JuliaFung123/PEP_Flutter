import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App typefaces: Noto Sans TC bundled as assets (繁中 + Latin).
///
/// Flutter web often fails to pick Medium/Bold **within** one multi-weight
/// family (w500 silently paints as Regular). Each weight is therefore a
/// separate `family` in `pubspec.yaml`; [familyFor] selects the face.
///
/// Pass a geometry-merged [TextTheme] into [textTheme] (see [AppTheme]) —
/// M3 `typography.black` alone has null weights, so every slot would map to
/// Regular and titleMedium would match bodyLarge.
abstract final class AppFonts {
  static const familyRegular = 'NotoSansTC';
  static const familyMedium = 'NotoSansTCMedium';
  static const familySemiBold = 'NotoSansTCSemiBold';
  static const familyBold = 'NotoSansTCBold';

  /// Display name for docs / typography kit.
  static const displayName = 'Noto Sans TC';

  static const _assets = <String, String>{
    familyRegular: 'assets/fonts/NotoSansTC-Regular.ttf',
    familyMedium: 'assets/fonts/NotoSansTC-Medium.ttf',
    familySemiBold: 'assets/fonts/NotoSansTC-SemiBold.ttf',
    familyBold: 'assets/fonts/NotoSansTC-Bold.ttf',
  };

  static String familyFor(FontWeight? weight) {
    final value = weight?.value ?? FontWeight.w400.value;
    if (value >= FontWeight.w700.value) return familyBold;
    if (value >= FontWeight.w600.value) return familySemiBold;
    if (value >= FontWeight.w500.value) return familyMedium;
    return familyRegular;
  }

  /// Ensure faces are in the engine before first paint.
  static Future<void> preload() async {
    await Future.wait([
      for (final entry in _assets.entries) _loadFamily(entry.key, entry.value),
    ]);
  }

  static Future<void> _loadFamily(String family, String assetPath) async {
    final loader = FontLoader(family);
    loader.addFont(rootBundle.load(assetPath));
    await loader.load();
  }

  /// Apply per-weight [fontFamily] to every M3 slot.
  ///
  /// [base] must include geometry (size/weight), e.g.
  /// `typography.englishLike.merge(typography.black)`.
  static TextTheme textTheme(TextTheme base) {
    TextStyle? apply(TextStyle? style) {
      if (style == null) return null;
      final weight = style.fontWeight ?? FontWeight.w400;
      return style.copyWith(
        fontFamily: familyFor(weight),
        fontWeight: weight,
      );
    }

    return TextTheme(
      displayLarge: apply(base.displayLarge),
      displayMedium: apply(base.displayMedium),
      displaySmall: apply(base.displaySmall),
      headlineLarge: apply(base.headlineLarge),
      headlineMedium: apply(base.headlineMedium),
      headlineSmall: apply(base.headlineSmall),
      titleLarge: apply(base.titleLarge),
      titleMedium: apply(base.titleMedium),
      titleSmall: apply(base.titleSmall),
      bodyLarge: apply(base.bodyLarge),
      bodyMedium: apply(base.bodyMedium),
      bodySmall: apply(base.bodySmall),
      labelLarge: apply(base.labelLarge),
      labelMedium: apply(base.labelMedium),
      labelSmall: apply(base.labelSmall),
    );
  }

  static TextStyle style({
    TextStyle? textStyle,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    final weight = fontWeight ?? textStyle?.fontWeight ?? FontWeight.w400;
    return (textStyle ?? const TextStyle()).copyWith(
      fontFamily: familyFor(weight),
      fontSize: fontSize,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }
}
