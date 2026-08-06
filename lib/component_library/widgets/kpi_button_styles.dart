import 'package:flutter/material.dart';

/// KPI button sizes and toggle-state color overrides for the component library.
///
/// **Default colors** come from [ThemeData] — M3 tokens live on [ColorScheme]
/// (`outlineVariant`, `onSurfaceVariant`, `primary`, etc.) and are wired in
/// [AppTheme] via each `*ButtonTheme`. Do not duplicate hex values here.
///
/// Toggle unselected / selected colors are preview-only overrides (not in
/// standard Flutter button themes) for the Buttons reference matrix.
enum KpiButtonVariant { elevated, filled, filledTonal, outlined, text }

enum KpiButtonColorState { defaultState, toggleUnselected, toggleSelected }

abstract final class KpiButtonStyles {
  /// Size, padding, and capsule shape — colors inherit from theme.
  static ButtonStyle sizeStyle({
    required double height,
    required double horizontalPadding,
    required double iconSize,
  }) {
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: horizontalPadding),
      ),
      iconSize: WidgetStatePropertyAll(iconSize),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  /// Toggle-state color overrides using M3 [ColorScheme] roles from the theme.
  static ButtonStyle? toggleColorStyle({
    required ColorScheme scheme,
    required KpiButtonVariant variant,
    required KpiButtonColorState colorState,
  }) {
    if (colorState == KpiButtonColorState.defaultState) return null;

    return switch (variant) {
      KpiButtonVariant.elevated => _elevatedToggle(scheme, colorState),
      KpiButtonVariant.filled => _filledToggle(scheme, colorState),
      KpiButtonVariant.filledTonal => _tonalToggle(scheme, colorState),
      KpiButtonVariant.outlined => _outlinedToggle(scheme, colorState),
      KpiButtonVariant.text => null,
    };
  }

  static ButtonStyle style({
    required ColorScheme scheme,
    required KpiButtonVariant variant,
    required KpiButtonColorState colorState,
    required double height,
    required double horizontalPadding,
    required double iconSize,
  }) {
    final size = sizeStyle(
      height: height,
      horizontalPadding: horizontalPadding,
      iconSize: iconSize,
    );
    final toggle = toggleColorStyle(
      scheme: scheme,
      variant: variant,
      colorState: colorState,
    );
    return toggle == null ? size : size.merge(toggle);
  }

  static ButtonStyle _elevatedToggle(
    ColorScheme scheme,
    KpiButtonColorState state,
  ) {
    if (state == KpiButtonColorState.toggleUnselected) return const ButtonStyle();

    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(scheme.primary),
      foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
      elevation: const WidgetStatePropertyAll(0),
    );
  }

  static ButtonStyle _filledToggle(
    ColorScheme scheme,
    KpiButtonColorState state,
  ) {
    if (state == KpiButtonColorState.toggleSelected) return const ButtonStyle();

    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainer),
      foregroundColor: WidgetStatePropertyAll(scheme.onSurfaceVariant),
    );
  }

  static ButtonStyle _tonalToggle(
    ColorScheme scheme,
    KpiButtonColorState state,
  ) {
    if (state == KpiButtonColorState.toggleUnselected) return const ButtonStyle();

    return ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(scheme.onSecondary),
    );
  }

  static ButtonStyle _outlinedToggle(
    ColorScheme scheme,
    KpiButtonColorState state,
  ) {
    if (state == KpiButtonColorState.toggleUnselected) return const ButtonStyle();

    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(scheme.inverseSurface),
      foregroundColor: WidgetStatePropertyAll(scheme.onInverseSurface),
      side: const WidgetStatePropertyAll(BorderSide.none),
    );
  }
}
