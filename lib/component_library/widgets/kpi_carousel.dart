import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'image_source.dart';

/// Default height for featured / hero-style carousel strips (Figma Items List).
const double kKpiCarouselFeaturedHeight = 240;

/// Default height for compact carousel strips (image-only items).
const double kKpiCarouselCompactHeight = 120;

/// Default corner radius for M3 carousel items.
const double kKpiCarouselItemRadius = 28;

/// M3 small carousel item min width (dp).
/// https://m3.material.io/components/carousel/specs
const double kM3CarouselSmallMinWidth = 40;

/// M3 small carousel item max width (dp).
const double kM3CarouselSmallMaxWidth = 56;

/// Settled small-item width used when computing flex weights (within 40–56).
const double kM3CarouselSmallWidth = kM3CarouselSmallMaxWidth;

/// Caption only on items wider than a small slot (M3 small max is 56).
const double kKpiCarouselCaptionMinWidth = kM3CarouselSmallMaxWidth + 1;

/// Material 3 carousel layouts
/// ([Carousel specs](https://m3.material.io/components/carousel/specs)).
enum KpiCarouselLayout {
  /// Large then small. Small slot stays 40–56dp.
  hero,

  /// Small · large · small. Small slots stay 40–56dp.
  centerAlignedHero,

  /// Large · medium · small visible. Small slots stay 40–56dp.
  multiBrowse,
}

extension on KpiCarouselLayout {
  bool get consumeMaxWeight => switch (this) {
        KpiCarouselLayout.hero ||
        KpiCarouselLayout.centerAlignedHero =>
          true,
        KpiCarouselLayout.multiBrowse => false,
      };

  int get initialItem => switch (this) {
        KpiCarouselLayout.hero => 0,
        KpiCarouselLayout.centerAlignedHero => 1,
        KpiCarouselLayout.multiBrowse => 2,
      };

  /// Flex weights so the smallest visible slot is ~[kM3CarouselSmallWidth] dp.
  ///
  /// Pixel-proportional integers keep small items inside M3’s 40–56dp band
  /// instead of scaling with a fixed ratio of the viewport.
  List<int> flexWeightsFor(double viewportWidth) {
    final width = math.max(viewportWidth, kM3CarouselSmallMinWidth * 3);
    final small = kM3CarouselSmallWidth.round();

    switch (this) {
      case KpiCarouselLayout.hero:
        final large = math.max((width - small).round(), small + 1);
        return [large, small];
      case KpiCarouselLayout.centerAlignedHero:
        final large = math.max((width - small * 2).round(), small + 1);
        return [small, large, small];
      case KpiCarouselLayout.multiBrowse:
        // Pattern 1·2·3·2·1 — two smalls at M3 width; medium/large share rest.
        final remaining = math.max(width - small * 2, small * 5);
        final unit = remaining / 7; // 2+3+2
        final medium = math.max(unit * 2, small.toDouble()).round();
        final large = math.max(unit * 3, medium + 1).round();
        return [small, medium, large, medium, small];
    }
  }
}

/// Material 3 [CarouselView.weighted] wrapper for Hero / Center-aligned hero /
/// Multi-browse layouts.
///
/// Spec: https://m3.material.io/components/carousel/specs
///
/// Small items are sized to M3 **40–56dp** (target 56) via viewport-based
/// flex weights. [shrinkExtent] is 40 so items don’t collapse thinner than
/// the M3 minimum while scrolling.
///
/// Parent must give a bounded height. Mouse / trackpad drag is enabled for
/// Chrome web scrolling.
class KpiCarousel extends StatefulWidget {
  const KpiCarousel({
    super.key,
    required this.children,
    this.layout = KpiCarouselLayout.multiBrowse,
    this.onTap,
    this.itemSnapping = true,
    this.elevation = 1,
    this.itemRadius = kKpiCarouselItemRadius,
    this.padding = EdgeInsets.zero,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 4),
    this.backgroundColor,
    this.shape,
  });

  final List<Widget> children;
  final KpiCarouselLayout layout;
  final ValueChanged<int>? onTap;
  final bool itemSnapping;
  final double elevation;
  final double itemRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsets? itemPadding;
  final Color? backgroundColor;
  final ShapeBorder? shape;

  @override
  State<KpiCarousel> createState() => _KpiCarouselState();
}

class _KpiCarouselState extends State<KpiCarousel> {
  late CarouselController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarouselController(initialItem: widget.layout.initialItem);
  }

  @override
  void didUpdateWidget(covariant KpiCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layout != widget.layout) {
      _controller.dispose();
      _controller = CarouselController(initialItem: widget.layout.initialItem);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: widget.padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final flexWeights =
              widget.layout.flexWeightsFor(constraints.maxWidth);
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.stylus,
              },
            ),
            child: CarouselView.weighted(
              controller: _controller,
              flexWeights: flexWeights,
              consumeMaxWeight: widget.layout.consumeMaxWeight,
              itemSnapping: widget.itemSnapping,
              elevation: widget.elevation,
              shrinkExtent: kM3CarouselSmallMinWidth,
              padding: widget.itemPadding,
              shape: widget.shape ??
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.itemRadius),
                  ),
              backgroundColor: widget.backgroundColor ??
                  colorScheme.surfaceContainerHighest,
              onTap: widget.onTap,
              children: widget.children,
            ),
          );
        },
      ),
    );
  }
}

/// Featured image card for [KpiCarousel] (Figma List/活動card).
///
/// Content-only — do not wrap in [Material]/[InkWell]; [KpiCarousel] /
/// [CarouselView] provides those. Caption uses liquid glass
/// ([GlassContainer]) with [GlassContentAwareBrightness] so title color
/// flips for contrast against the cover image (white on dark media, onSurface
/// on light media).
class KpiCarouselFeaturedCard extends StatefulWidget {
  const KpiCarouselFeaturedCard({
    super.key,
    required this.image,
    required this.title,
    this.dateBadge,
    this.showCaption = true,
  });

  final String image;
  final String title;
  final String? dateBadge;

  /// When false, always image-only. When true, caption shows only on items
  /// wider than M3 small max (56dp).
  final bool showCaption;

  @override
  State<KpiCarouselFeaturedCard> createState() =>
      _KpiCarouselFeaturedCardState();
}

class _KpiCarouselFeaturedCardState extends State<KpiCarouselFeaturedCard> {
  void _requestBrightnessSample() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      GlassContentAwareScope.maybeOf(context)?.requestSample();
      // Image decode can land after the first paint — sample again shortly.
      Future<void>.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        GlassContentAwareScope.maybeOf(context)?.requestSample();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _requestBrightnessSample();
  }

  @override
  void didUpdateWidget(covariant KpiCarouselFeaturedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      _requestBrightnessSample();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showCaption) {
      return buildImageSource(widget.image, fit: BoxFit.cover);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final showBar = constraints.maxWidth >= kKpiCarouselCaptionMinWidth;
        if (!showBar) {
          return buildImageSource(widget.image, fit: BoxFit.cover);
        }

        return GlassContentAwareScope(
          child: GlassPage(
            background: GlassContentAwareContent(
              child: buildImageSource(widget.image, fit: BoxFit.cover),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GlassContentAwareBrightness(
                gridColumns: 6,
                gridRows: 2,
                builder: (context, brightness, darkAmount) {
                  final colorScheme = Theme.of(context).colorScheme;
                  final textTheme = Theme.of(context).textTheme;
                  // Dark media → Brightness.dark → light glyphs; light media →
                  // onSurface for readable dark text.
                  final captionColor = brightness == Brightness.dark
                      ? Colors.white
                      : colorScheme.onSurface;

                  return GlassContainer(
                    useOwnLayer: true,
                    quality: GlassQuality.standard,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    shape: const LiquidRoundedSuperellipse(borderRadius: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.dateBadge != null &&
                            widget.dateBadge!.isNotEmpty) ...[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: Text(
                                widget.dateBadge!,
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: captionColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
