import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typefaces: CJK-capable primary so Chinese weight faces actually paint.
///
/// Roboto / Inter only cover Latin — Chinese falls back to a system font and
/// Medium/Bold often look identical to Regular (especially on Flutter web).
///
/// Primary: Noto Sans TC (繁中 + Latin). Fallback: Noto Sans SC (简中).
abstract final class AppFonts {
  static const weights = <FontWeight>[
    FontWeight.w400,
    FontWeight.w500,
    FontWeight.w600,
    FontWeight.w700,
  ];

  /// Preload TC + SC faces used by the type scale.
  static Future<void> preload() {
    return GoogleFonts.pendingFonts([
      for (final w in weights) ...[
        GoogleFonts.notoSansTc(fontWeight: w),
        GoogleFonts.notoSansSc(fontWeight: w),
      ],
    ]);
  }

  static List<String> get cjkFallbackFamilies => [
    GoogleFonts.notoSansSc().fontFamily!,
  ];

  /// M3 text theme on Noto Sans TC, with SC fallback for 简中 glyphs.
  static TextTheme textTheme(TextTheme base) {
    final tc = GoogleFonts.notoSansTcTextTheme(base);
    return _withFallback(tc);
  }

  static TextStyle style({
    TextStyle? textStyle,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return GoogleFonts.notoSansTc(
      textStyle: textStyle,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    ).copyWith(fontFamilyFallback: cjkFallbackFamilies);
  }

  static TextTheme _withFallback(TextTheme theme) {
    TextStyle? patch(TextStyle? style) {
      if (style == null) return null;
      return style.copyWith(fontFamilyFallback: cjkFallbackFamilies);
    }

    return theme.copyWith(
      displayLarge: patch(theme.displayLarge),
      displayMedium: patch(theme.displayMedium),
      displaySmall: patch(theme.displaySmall),
      headlineLarge: patch(theme.headlineLarge),
      headlineMedium: patch(theme.headlineMedium),
      headlineSmall: patch(theme.headlineSmall),
      titleLarge: patch(theme.titleLarge),
      titleMedium: patch(theme.titleMedium),
      titleSmall: patch(theme.titleSmall),
      bodyLarge: patch(theme.bodyLarge),
      bodyMedium: patch(theme.bodyMedium),
      bodySmall: patch(theme.bodySmall),
      labelLarge: patch(theme.labelLarge),
      labelMedium: patch(theme.labelMedium),
      labelSmall: patch(theme.labelSmall),
    );
  }
}
