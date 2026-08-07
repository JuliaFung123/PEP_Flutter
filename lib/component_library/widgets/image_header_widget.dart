import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'image_header_gallery_page.dart';
import 'image_source.dart';
import 'kpi_button_styles.dart';

/// Target aspect (width ÷ height). Used until [kImageHeaderMaxHeight] would be exceeded.
const kImageHeaderAspectRatio = 4 / 3;
const kImageHeaderMaxHeight = 320.0;

/// Full-width block; height = min(width ÷ 4:3, 320).
({double width, double height}) resolveImageHeaderSize({
  required double availableWidth,
}) {
  final height = math.min(
    availableWidth / kImageHeaderAspectRatio,
    kImageHeaderMaxHeight,
  );
  return (width: availableWidth, height: height);
}

class ImageHeaderWidget extends StatefulWidget {
  const ImageHeaderWidget({
    super.key,
    this.images = kDemoImageHeaderAssets,
    this.borderRadius = BorderRadius.zero,
    this.dotCount,
    this.initialIndex = 0,
    this.badgeText,
    this.showBackButton = false,
    this.onBackPressed,
    this.onBadgePressed,
    this.expandToParent = false,
  });

  final List<String> images;
  final BorderRadius borderRadius;

  /// Defaults to [images.length].
  final int? dotCount;
  final int initialIndex;

  /// Defaults to current index / total, e.g. `1/4`.
  final String? badgeText;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  /// When null, opens a full-page gallery at the current image.
  final VoidCallback? onBadgePressed;

  /// When true, fills the parent (e.g. [FlexibleSpaceBar] background).
  /// Parent height should come from [resolveImageHeaderSize].
  final bool expandToParent;

  @override
  State<ImageHeaderWidget> createState() => _ImageHeaderWidgetState();
}

class _ImageHeaderWidgetState extends State<ImageHeaderWidget> {
  late final PageController _pageController;
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.images.isEmpty
        ? 0
        : widget.initialIndex.clamp(0, widget.images.length - 1);
    _pageController = PageController(initialPage: _activeIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _pageCount => widget.images.isEmpty ? 1 : widget.images.length;

  int get _dotCount => widget.dotCount ?? _pageCount;

  String get _badgeLabel =>
      widget.badgeText ??
      (widget.images.isEmpty
          ? '0/0'
          : '${_activeIndex + 1}/${widget.images.length}');

  void _openGallery() {
    if (widget.onBadgePressed != null) {
      widget.onBadgePressed!();
      return;
    }
    if (widget.images.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => ImageHeaderGalleryPage(
          images: widget.images,
          initialIndex: _activeIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = _buildMedia(context);

    if (widget.expandToParent) {
      return media;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final size = resolveImageHeaderSize(availableWidth: availableWidth);

        // Full width; height from aspect until max 320.
        return SizedBox(
          width: size.width,
          height: size.height,
          child: media,
        );
      },
    );
  }

  Widget _buildMedia(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.images.isEmpty)
            ColoredBox(color: colorScheme.surfaceContainerHighest)
          else
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() => _activeIndex = index);
                },
                itemBuilder: (context, index) {
                  // Cover: fill the box, crop edges, never stretch.
                  return SizedBox.expand(
                    child: Image(
                      image: imageProviderFor(widget.images[index]),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x1A000000),
                    Color(0x00000000),
                    Color(0x33000000),
                  ],
                ),
              ),
            ),
          ),
          if (widget.showBackButton)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 4, top: 4),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      onPressed:
                          widget.onBackPressed ??
                          () {
                            final navigator = Navigator.maybeOf(context);
                            if (navigator != null && navigator.canPop()) {
                              navigator.pop();
                            }
                          },
                      color: colorScheme.onSurface,
                      padding: EdgeInsets.zero,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                        maximumSize: const Size(48, 48),
                        fixedSize: const Size(48, 48),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.standard,
                      ),
                      icon: const Icon(Icons.arrow_back, size: 24),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.images.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: IgnorePointer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _dotCount,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _activeIndex
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.images.isNotEmpty)
            Positioned(
              right: 12,
              bottom: 16,
              child: FilledButton.tonal(
                onPressed: _openGallery,
                style: KpiButtonStyles.labelStyle(
                  context,
                  KpiButtonSize.xs32,
                ).copyWith(
                  backgroundColor: WidgetStatePropertyAll(
                    colorScheme.inverseSurface,
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    colorScheme.onInverseSurface,
                  ),
                ),
                child: Text(_badgeLabel),
              ),
            ),
        ],
      ),
    );
  }
}
