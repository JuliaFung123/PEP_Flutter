import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'glass_media_brightness.dart';
import 'image_header_widget.dart';
import 'image_source.dart';

/// Max height for featured carousel strips — same as [kImageHeaderMaxHeight]
/// (320 logical pixels / dp). Prefer [resolvePepCarouselFeaturedHeight] or
/// [PepCarouselFeaturedBox] so height follows width ÷ 4:3 until the cap.
const double kPepCarouselFeaturedHeight = kImageHeaderMaxHeight;

/// Featured strip height matching [ImageHeaderWidget]:
/// `min(availableWidth / (4/3), 320)` logical pixels (dp).
double resolvePepCarouselFeaturedHeight(double availableWidth) =>
    resolveImageHeaderSize(availableWidth: availableWidth).height;

/// Default height for compact carousel strips (image-only items).
const double kPepCarouselCompactHeight = 120;

/// M3 item corner radius (dp).
/// https://m3.material.io/components/carousel/specs
const double kPepCarouselItemRadius = 28;

/// M3 small carousel item min width (dp).
const double kM3CarouselSmallMinWidth = 40;

/// M3 small carousel item max width (dp).
const double kM3CarouselSmallMaxWidth = 56;

/// Settled small-item **visible** width (within 40–56).
const double kM3CarouselSmallWidth = kM3CarouselSmallMaxWidth;

/// M3 padding between carousel elements (dp).
const double kM3CarouselItemGap = 8;

/// M3 carousel container insets: leading/trailing 16, top/bottom 8.
///
/// Horizontal 12 + [kM3CarouselItemPadding] (4 each side) = 16 at the
/// edges; item paddings meet as 8 between elements.
const EdgeInsets kM3CarouselPadding = EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 8,
);

/// Half of [kM3CarouselItemGap] on each side of an item (Flutter
/// [CarouselView] padding wraps each child).
const EdgeInsets kM3CarouselItemPadding = EdgeInsets.symmetric(horizontal: 4);

/// Caption only on items wider than a small slot (M3 small max is 56).
const double kPepCarouselCaptionMinWidth = kM3CarouselSmallMaxWidth + 1;

/// Material 3 carousel layouts
/// ([Carousel specs](https://m3.material.io/components/carousel/specs)).
enum PepCarouselLayout {
  /// Large then small. Small slot stays 40–56dp.
  hero,

  /// Small · large · small. Small slots stay 40–56dp.
  centerAlignedHero,

  /// Large · medium · small visible. Small slots stay 40–56dp.
  multiBrowse,
}

extension on PepCarouselLayout {
  bool get consumeMaxWeight => switch (this) {
        PepCarouselLayout.hero ||
        PepCarouselLayout.centerAlignedHero =>
          true,
        PepCarouselLayout.multiBrowse => false,
      };

  int get initialItem => switch (this) {
        PepCarouselLayout.hero => 0,
        PepCarouselLayout.centerAlignedHero => 1,
        PepCarouselLayout.multiBrowse => 2,
      };

  /// Flex weights so the smallest **visible** item is ~[kM3CarouselSmallWidth]
  /// dp (slot includes [kM3CarouselItemGap] from [CarouselView] item padding).
  List<int> flexWeightsFor(double viewportWidth) {
    final width = math.max(viewportWidth, kM3CarouselSmallMinWidth * 3);
    // Weighted extent includes per-item horizontal padding (gap).
    final smallExtent =
        (kM3CarouselSmallWidth + kM3CarouselItemGap).round();

    switch (this) {
      case PepCarouselLayout.hero:
        final large = math.max((width - smallExtent).round(), smallExtent + 1);
        return [large, smallExtent];
      case PepCarouselLayout.centerAlignedHero:
        final large =
            math.max((width - smallExtent * 2).round(), smallExtent + 1);
        return [smallExtent, large, smallExtent];
      case PepCarouselLayout.multiBrowse:
        // Pattern 1·2·3·2·1 — two smalls at M3 width; medium/large share rest.
        final remaining = math.max(width - smallExtent * 2, smallExtent * 5);
        final unit = remaining / 7; // 2+3+2
        final medium = math.max(unit * 2, smallExtent.toDouble()).round();
        final large = math.max(unit * 3, medium + 1).round();
        return [smallExtent, medium, large, medium, smallExtent];
    }
  }
}

/// Sizes a featured [PepCarousel] like [ImageHeaderWidget]: full width,
/// height = min(width ÷ 4:3, 320 logical px).
class PepCarouselFeaturedBox extends StatelessWidget {
  const PepCarouselFeaturedBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        return SizedBox(
          height: resolvePepCarouselFeaturedHeight(availableWidth),
          child: child,
        );
      },
    );
  }
}

/// Material 3 [CarouselView.weighted] wrapper for Hero / Center-aligned hero /
/// Multi-browse layouts.
///
/// Spec: https://m3.material.io/components/carousel/specs
///
/// Defaults match M3 multi-browse / hero metrics:
/// - Vertically centered strip (top/bottom padding 8)
/// - Leading/trailing padding 16
/// - Padding between elements 8
/// - Large item width dynamic; small 40–56dp
/// - Item corner radius 28
///
/// [shrinkExtent] is 40 so items don’t collapse thinner than the M3 minimum
/// while scrolling. Defaults to [infinite] looping so the last item wraps to
/// the first and every item can become the large hero.
///
/// Featured strips: wrap in [PepCarouselFeaturedBox] (same size rule as
/// [ImageHeaderWidget]). Compact strips: give an explicit height (e.g.
/// [kPepCarouselCompactHeight]). Mouse / trackpad drag is enabled for Chrome
/// web scrolling.
class PepCarousel extends StatefulWidget {
  const PepCarousel({
    super.key,
    required this.children,
    this.layout = PepCarouselLayout.multiBrowse,
    this.onTap,
    this.itemSnapping = true,
    this.infinite = true,
    this.elevation = 1,
    this.itemRadius = kPepCarouselItemRadius,
    this.padding = kM3CarouselPadding,
    this.itemPadding = kM3CarouselItemPadding,
    this.backgroundColor,
    this.shape,
  });

  final List<Widget> children;
  final PepCarouselLayout layout;
  final ValueChanged<int>? onTap;
  final bool itemSnapping;

  /// When true, scrolling past the last item wraps to the first (and reverse).
  /// Also lets every item expand to the large hero slot — without looping,
  /// the final item can stay stuck as the small peek.
  final bool infinite;
  final double elevation;
  final double itemRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsets? itemPadding;
  final Color? backgroundColor;
  final ShapeBorder? shape;

  @override
  State<PepCarousel> createState() => _PepCarouselState();
}

class _PepCarouselState extends State<PepCarousel> {
  late CarouselController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarouselController(initialItem: widget.layout.initialItem);
  }

  @override
  void didUpdateWidget(covariant PepCarousel oldWidget) {
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
            // Items fill the strip height (M3 vertically centered track).
            child: CarouselView.weighted(
              controller: _controller,
              flexWeights: flexWeights,
              consumeMaxWeight: widget.layout.consumeMaxWeight,
              itemSnapping: widget.itemSnapping,
              infinite: widget.infinite,
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

/// Featured image card for [PepCarousel] (Figma List/活動card).
///
/// Content-only — do not wrap in [Material]/[InkWell]; [PepCarousel] /
/// [CarouselView] provides those.
///
/// Caption is a local glass bottom bar on featured items (not a library widget).
class PepCarouselFeaturedCard extends StatefulWidget {
  const PepCarouselFeaturedCard({
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
  State<PepCarouselFeaturedCard> createState() =>
      _PepCarouselFeaturedCardState();
}

class _PepCarouselFeaturedCardState extends State<PepCarouselFeaturedCard> {
  /// Bottom band of the cover — light band → light glass, dark band → dark glass.
  Brightness _glassBrightness = Brightness.dark;

  @override
  void initState() {
    super.initState();
    unawaited(_resolveGlassBrightness());
  }

  @override
  void didUpdateWidget(covariant PepCarouselFeaturedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      _glassBrightness = Brightness.dark;
      unawaited(_resolveGlassBrightness());
    }
  }

  Future<void> _resolveGlassBrightness() async {
    final next = await analyzeImageMediaBrightness(
      imageProviderFor(widget.image),
      startYFraction: 0.68,
      previous: _glassBrightness,
    );
    if (!mounted || next == null || next == _glassBrightness) return;
    setState(() => _glassBrightness = next);
  }

  void _onImageFrameLoaded() {
    unawaited(_resolveGlassBrightness());
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showCaption) {
      return buildImageSource(widget.image, fit: BoxFit.cover);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final showBar = constraints.maxWidth >= kPepCarouselCaptionMinWidth;
        if (!showBar) {
          return buildImageSource(widget.image, fit: BoxFit.cover);
        }

        return GlassPage(
          background: Image(
            image: imageProviderFor(widget.image),
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _onImageFrameLoaded();
                });
              }
              return child;
            },
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _PepCarouselFeaturedCaption(
              key: ValueKey('${widget.image}-$_glassBrightness'),
              glassBrightness: _glassBrightness,
              title: widget.title,
              dateBadge: widget.dateBadge,
            ),
          ),
        );
      },
    );
  }
}

/// Borderless glass caption for [PepCarouselFeaturedCard] only.
class _PepCarouselFeaturedCaption extends StatelessWidget {
  const _PepCarouselFeaturedCaption({
    super.key,
    required this.glassBrightness,
    required this.title,
    this.dateBadge,
  });

  static const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  static const _settings = LiquidGlassSettings(
    glowIntensity: 0,
    lightIntensity: 0,
    ambientStrength: 0,
    ambientRim: 0,
    fresnelStrength: 0,
    shadowElevation: 0,
    chromaticAberration: 0,
    refractiveIndex: 0,
    thickness: 0,
    blur: 8,
  );

  final Brightness glassBrightness;
  final String title;
  final String? dateBadge;

  @override
  Widget build(BuildContext context) {
    return GlassTheme(
      data: GlassThemeData(brightness: glassBrightness),
      child: GlassContainer(
        useOwnLayer: true,
        quality: GlassQuality.minimal,
        width: double.infinity,
        padding: _padding,
        shape: const LiquidRoundedSuperellipse(borderRadius: 0),
        settings: _settings,
        child: GlassMediaInk(
          key: ValueKey(glassBrightness),
          glassBrightness: glassBrightness,
          child: Builder(
            builder: (context) {
              final media = GlassMediaScope.of(context);
              final textTheme = Theme.of(context).textTheme;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dateBadge != null && dateBadge!.isNotEmpty) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: media.badgeBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Text(
                          dateBadge!,
                          style: textTheme.labelMedium?.copyWith(
                            color: media.badgeForeground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: media.titleColor,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
