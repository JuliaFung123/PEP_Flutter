import 'package:flutter/material.dart';

/// Button sizes from Figma Flutter UI kit.
///
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2061-548
enum KpiButtonSize {
  /// Figma `Size=XS 32` — height 32, pad 12, label inner 4, Label Large.
  xs32,

  /// Figma `Size=S 40` — height 40, pad 16, label inner 8, Label Large.
  s40,

  /// Figma `Size=M 56` — height 56, pad 24, label inner 16, Title Large.
  m56,
}

enum KpiButtonMode { filled, outlined, tonal, text }

extension KpiButtonSizeX on KpiButtonSize {
  String get label => switch (this) {
    KpiButtonSize.xs32 => 'XS 32',
    KpiButtonSize.s40 => 'S 40',
    KpiButtonSize.m56 => 'M 56',
  };

  double get height => switch (this) {
    KpiButtonSize.xs32 => 32,
    KpiButtonSize.s40 => 40,
    KpiButtonSize.m56 => 56,
  };

  /// Outer horizontal padding (Figma button `px`).
  double get horizontalPadding => switch (this) {
    KpiButtonSize.xs32 => 12,
    KpiButtonSize.s40 => 16,
    KpiButtonSize.m56 => 24,
  };

  /// Leading glyph size from Figma.
  double get leadingIconSize => switch (this) {
    KpiButtonSize.xs32 => 20,
    KpiButtonSize.s40 => 20,
    KpiButtonSize.m56 => 24,
  };

  /// Trailing glyph size from Figma (dropdown is slightly smaller on XS/S).
  double get trailingIconSize => switch (this) {
    KpiButtonSize.xs32 => 18,
    KpiButtonSize.s40 => 18,
    KpiButtonSize.m56 => 20,
  };

  /// Alias for icon-only buttons (matches leading).
  double get iconSize => leadingIconSize;

  /// Gap between icon and label (Figma Button Label horizontal pad).
  double get iconLabelGap => switch (this) {
    KpiButtonSize.xs32 => 4,
    KpiButtonSize.s40 => 8,
    KpiButtonSize.m56 => 16,
  };

  /// XS/S → Label Large; M → Title Large.
  TextStyle? textStyleOf(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return switch (this) {
      KpiButtonSize.xs32 || KpiButtonSize.s40 => theme.labelLarge,
      KpiButtonSize.m56 => theme.titleLarge,
    };
  }

  String get typographyToken => switch (this) {
    KpiButtonSize.xs32 || KpiButtonSize.s40 => 'Label Large',
    KpiButtonSize.m56 => 'Title Large',
  };
}

/// Shared styles for label + icon buttons (stadium / circle, Figma sizes).
abstract final class KpiButtonStyles {
  /// Label button — exact Figma height. Do not use [VisualDensity.compact]
  /// (it subtracts 8px from min height and breaks XS/S/M).
  static ButtonStyle labelStyle(BuildContext context, KpiButtonSize size) {
    final h = size.height;
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, h)),
      maximumSize: WidgetStatePropertyAll(Size(double.infinity, h)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: size.horizontalPadding),
      ),
      textStyle: WidgetStatePropertyAll(size.textStyleOf(context)),
      iconSize: WidgetStatePropertyAll(size.leadingIconSize),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
    );
  }

  /// Circular icon button matching Figma Icon Button size.
  static ButtonStyle iconStyle(KpiButtonSize size) {
    final dim = size.height;
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(dim, dim)),
      maximumSize: WidgetStatePropertyAll(Size(dim, dim)),
      fixedSize: WidgetStatePropertyAll(Size(dim, dim)),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      iconSize: WidgetStatePropertyAll(size.iconSize),
      shape: const WidgetStatePropertyAll(CircleBorder()),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
    );
  }
}
