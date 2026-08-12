import 'dart:ui';

import 'package:flutter/material.dart';

/// Default blur strength for [GlassSurface] (sigma).
const double kGlassSurfaceBlurSigma = 16;

/// Default corner radius for [GlassSurface] cards / panels.
const double kGlassSurfaceRadius = 16;

/// Normal glass tint opacity (10%).
const double kGlassSurfaceTintOpacity = 0.10;

/// Strong glass tint opacity (20%).
const double kGlassSurfaceTintOpacityStrong = 0.20;

/// Frosted-glass panel — optional blur of content behind + translucent tint
/// or gradient fill.
///
/// Not an M3 component. Built with [BackdropFilter] (when [blurSigma] &gt; 0) +
/// clipped translucent [ColorScheme] fill. Clip the blur region; keep panels
/// small for performance.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.blurSigma = kGlassSurfaceBlurSigma,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(kGlassSurfaceRadius),
    ),
    this.tint,
    this.gradient,
    this.borderColor,
    this.borderWidth = 1,
    this.padding,
    this.width,
    this.height,
    this.alignment,
  });

  final Widget child;

  /// Gaussian blur sigma. `0` skips [BackdropFilter] (gradient/tint only).
  final double blurSigma;

  final BorderRadiusGeometry borderRadius;

  /// Solid fill over the blur. Ignored when [gradient] is set.
  /// Defaults to [ColorScheme.surface] at [kGlassSurfaceTintOpacity] (10%).
  final Color? tint;

  /// When set, used instead of [tint] (e.g. bottom caption fade).
  final Gradient? gradient;

  /// Edge highlight. Defaults to [ColorScheme.outlineVariant] at ~40% opacity.
  final Color? borderColor;

  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedBorder =
        borderColor ?? colorScheme.outlineVariant.withValues(alpha: 0.4);

    final decoration = BoxDecoration(
      color: gradient == null
          ? (tint ??
              colorScheme.surface.withValues(alpha: kGlassSurfaceTintOpacity))
          : null,
      gradient: gradient,
      borderRadius: borderRadius,
      border: borderWidth <= 0
          ? null
          : Border.all(color: resolvedBorder, width: borderWidth),
    );

    Widget panel = Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (blurSigma > 0) {
      panel = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: panel,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: panel,
    );
  }
}

/// [ColorScheme.surface] tint at normal (10%) or strong (20%) opacity.
Color glassSurfaceTint(ColorScheme colorScheme, {bool strong = false}) {
  return colorScheme.surface.withValues(
    alpha: strong
        ? kGlassSurfaceTintOpacityStrong
        : kGlassSurfaceTintOpacity,
  );
}

/// Vertical clear → glass tint for captions over media.
///
/// Ends at normal (10%) or strong (20%) opacity. Pair with [GlassSurface] blur.
Gradient glassBottomCaptionGradient(
  ColorScheme colorScheme, {
  bool strong = false,
}) {
  final base = colorScheme.surface;
  final endOpacity =
      strong ? kGlassSurfaceTintOpacityStrong : kGlassSurfaceTintOpacity;
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      base.withValues(alpha: 0),
      base.withValues(alpha: endOpacity),
    ],
  );
}
