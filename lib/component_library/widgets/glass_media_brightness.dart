import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../core/theme/color_theme_builder.dart';
import 'image_source.dart';

/// [ColorScheme] roles for glass content at [glassBrightness] — not app theme.
///
/// Light cover → light glass → dark [onSurface] / light [inverseSurface] badge.
ColorScheme colorSchemeForGlassBrightness(
  BuildContext context,
  Brightness glassBrightness,
) {
  final theme = Theme.of(context);
  if (theme.brightness == glassBrightness) {
    return theme.colorScheme;
  }
  final scheme = theme.colorScheme;
  return ColorThemeBuilder.build(
    primary: scheme.primary,
    secondary: scheme.secondary,
    brightness: glassBrightness,
  );
}

/// Resolved glass-brightness colors for a glass content group.
class GlassMediaScope extends InheritedWidget {
  const GlassMediaScope({
    super.key,
    required this.glassBrightness,
    required this.colorScheme,
    required this.titleColor,
    required this.badgeBackground,
    required this.badgeForeground,
    required super.child,
  });

  /// Light/dark glass chrome driven by cover luminance.
  final Brightness glassBrightness;

  final ColorScheme colorScheme;

  /// Title ink — [ColorScheme.onSurface] at [glassBrightness].
  final Color titleColor;

  /// Badge fill — [ColorScheme.inverseSurface] at [glassBrightness].
  final Color badgeBackground;

  /// Badge ink — [ColorScheme.onInverseSurface] at [glassBrightness].
  final Color badgeForeground;

  static GlassMediaScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GlassMediaScope>();
    assert(scope != null, 'No GlassMediaScope found — wrap in GlassMediaInk.');
    return scope!;
  }

  @override
  bool updateShouldNotify(GlassMediaScope oldWidget) =>
      glassBrightness != oldWidget.glassBrightness ||
      colorScheme != oldWidget.colorScheme ||
      titleColor != oldWidget.titleColor ||
      badgeBackground != oldWidget.badgeBackground ||
      badgeForeground != oldWidget.badgeForeground;
}

/// M3 [TextTheme] with every slot ink set to [titleColor].
TextTheme glassMediaTextTheme(TextTheme base, Color titleColor) {
  TextStyle? apply(TextStyle? style) => style?.copyWith(color: titleColor);
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

/// Applies glass-brightness [ColorScheme] ink to a content group — title
/// [onSurface], badge [inverseSurface] / [onInverseSurface]. Wrap once on
/// the container child.
class GlassMediaInk extends StatelessWidget {
  const GlassMediaInk({
    super.key,
    required this.glassBrightness,
    required this.child,
  });

  /// Glass chrome brightness driven by cover luminance.
  final Brightness glassBrightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = colorSchemeForGlassBrightness(context, glassBrightness);
    final titleColor = scheme.onSurface;
    final badgeBackground = scheme.inverseSurface;
    final badgeForeground = scheme.onInverseSurface;
    final theme = Theme.of(context);
    final base = DefaultTextStyle.of(context).style;
    final inkTheme = glassMediaTextTheme(theme.textTheme, titleColor);

    return GlassMediaScope(
      glassBrightness: glassBrightness,
      colorScheme: scheme,
      titleColor: titleColor,
      badgeBackground: badgeBackground,
      badgeForeground: badgeForeground,
      child: Theme(
        data: theme.copyWith(
          brightness: glassBrightness,
          colorScheme: scheme,
          textTheme: inkTheme,
          primaryTextTheme: inkTheme,
        ),
        child: DefaultTextStyle(
          style: base.copyWith(color: titleColor),
          child: IconTheme(
            data: IconThemeData(color: titleColor),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Average luminance → [Brightness] for glass chrome over an image.
///
/// [startYFraction] 0 = full frame; ~0.68 = bottom caption band.
/// Hysteresis uses [previous] so borderline media stays stable.
Future<Brightness?> analyzeImageMediaBrightness(
  ImageProvider provider, {
  double startYFraction = 0,
  Brightness? previous,
}) async {
  try {
    final image = await _loadImageForAnalysis(provider);
    if (image == null) return null;

    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return null;

    final width = image.width;
    final height = image.height;
    if (width <= 0 || height <= 0) return null;

    final pixels = byteData.buffer.asUint8List();
    final startY =
        (height * startYFraction.clamp(0.0, 1.0)).floor().clamp(0, height - 1);
    var sum = 0.0;
    var count = 0;
    for (var y = startY; y < height; y += 2) {
      for (var x = 0; x < width; x += 2) {
        final i = (y * width + x) * 4;
        final r = pixels[i] / 255.0;
        final g = pixels[i + 1] / 255.0;
        final b = pixels[i + 2] / 255.0;
        sum += 0.2126 * r + 0.7152 * g + 0.0722 * b;
        count++;
      }
    }
    if (count == 0) return null;
    final avg = sum / count;
    // Light media → light glass (dark ink); dark media → dark glass (light ink).
    if (avg >= 0.52) return Brightness.light;
    if (avg <= 0.42) return Brightness.dark;
    // First sample in the gray zone — pick a side instead of returning null.
    return previous ?? (avg >= 0.47 ? Brightness.light : Brightness.dark);
  } catch (_) {
    return null;
  }
}

/// Downscale decode for reliable pixel readback (incl. Flutter web).
Future<ui.Image?> _loadImageForAnalysis(ImageProvider provider) async {
  const targetWidth = 128;

  if (provider is AssetImage) {
    final bundle = provider.bundle ?? rootBundle;
    final data = await bundle.load(provider.assetName);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: targetWidth,
    );
    return (await codec.getNextFrame()).image;
  }

  final stream = provider.resolve(ImageConfiguration.empty);
  final completer = Completer<ui.Image>();
  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, _) {
      stream.removeListener(listener);
      completer.complete(info.image);
    },
    onError: (Object error, StackTrace? stackTrace) {
      stream.removeListener(listener);
      completer.completeError(error, stackTrace);
    },
  );
  stream.addListener(listener);
  return completer.future;
}

/// Glass light/dark from a solid fill (not app [ThemeMode]).
Brightness brightnessForMediaColor(Color color) =>
    ThemeData.estimateBrightnessForColor(color);

/// Demo / layout frame: glass chrome follows **background image or color**,
/// not app light/dark.
class GlassMediaAwareFrame extends StatefulWidget {
  const GlassMediaAwareFrame({
    super.key,
    required this.builder,
    this.image,
    this.color,
    this.height = 220,
    this.alignment = Alignment.center,
    this.borderRadius = 16,
    this.imageSampleStartY = 0,
  }) : assert(
          image != null || color != null,
          'Provide an image path and/or a solid color background.',
        );

  /// Builds glass content for the resolved media [Brightness].
  final Widget Function(BuildContext context, Brightness mediaBrightness)
      builder;

  final String? image;
  final Color? color;
  final double height;
  final AlignmentGeometry alignment;
  final double borderRadius;

  /// Image luminance sample start (0 = full; 0.68 ≈ caption band).
  final double imageSampleStartY;

  @override
  State<GlassMediaAwareFrame> createState() => _GlassMediaAwareFrameState();
}

class _GlassMediaAwareFrameState extends State<GlassMediaAwareFrame> {
  final ValueNotifier<Brightness> _mediaBrightness =
      ValueNotifier(Brightness.dark);

  @override
  void initState() {
    super.initState();
    unawaited(_resolve());
  }

  @override
  void didUpdateWidget(covariant GlassMediaAwareFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image ||
        oldWidget.color != widget.color ||
        oldWidget.imageSampleStartY != widget.imageSampleStartY) {
      unawaited(_resolve());
    }
  }

  @override
  void dispose() {
    _mediaBrightness.dispose();
    super.dispose();
  }

  Future<void> _resolve() async {
    if (widget.image != null) {
      final next = await analyzeImageMediaBrightness(
        imageProviderFor(widget.image!),
        startYFraction: widget.imageSampleStartY,
        previous: _mediaBrightness.value,
      );
      if (!mounted || next == null) return;
      if (_mediaBrightness.value != next) {
        _mediaBrightness.value = next;
      }
      return;
    }
    if (widget.color != null) {
      final next = brightnessForMediaColor(widget.color!);
      if (_mediaBrightness.value != next) {
        _mediaBrightness.value = next;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = widget.image != null
        ? buildImageSource(widget.image!, fit: BoxFit.cover)
        : ColoredBox(color: widget.color!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        height: widget.height,
        child: GlassPage(
          background: background,
          child: Align(
            alignment: widget.alignment,
            child: ValueListenableBuilder<Brightness>(
              valueListenable: _mediaBrightness,
              builder: (context, brightness, _) {
                return widget.builder(context, brightness);
              },
            ),
          ),
        ),
      ),
    );
  }
}
