import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'image_source.dart';
import 'kpi_button_styles.dart';

/// Full-screen image gallery opened from [ImageHeaderWidget] or [PhotoGallery].
///
/// Close returns to the previous route (thumbnail grid / header). Drag / swipe
/// left/right changes photo (touch + Chrome mouse). Double-tap to zoom; when
/// zoomed, pan the image; pinch/zoom out to 1× restores paging.
class ImageHeaderGalleryPage extends StatefulWidget {
  const ImageHeaderGalleryPage({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<ImageHeaderGalleryPage> createState() => _ImageHeaderGalleryPageState();
}

class _ImageHeaderGalleryPageState extends State<ImageHeaderGalleryPage> {
  late final PageController _pageController;
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.initialIndex.clamp(0, widget.images.length - 1);
    _pageController = PageController(initialPage: _activeIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Flutter web PageView ignores mouse drag unless enabled here.
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
              itemCount: total,
              onPageChanged: (index) => setState(() => _activeIndex = index),
              itemBuilder: (context, index) {
                return _ZoomableGalleryImage(
                  key: ValueKey<String>(
                    'gallery-$index-${widget.images[index]}',
                  ),
                  source: widget.images[index],
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        tooltip: 'Close',
                        style: KpiButtonStyles.iconStyle(KpiButtonSize.s40)
                            .copyWith(
                          foregroundColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.black.withValues(alpha: 0.45),
                          ),
                        ),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                  const Spacer(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        '${_activeIndex + 1} / $total',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// At 1×: no [InteractiveViewer] (it steals mouse drag even when pan is off).
/// Double-tap enters zoom; zoom out to 1× restores PageView paging.
class _ZoomableGalleryImage extends StatefulWidget {
  const _ZoomableGalleryImage({super.key, required this.source});

  final String source;

  @override
  State<_ZoomableGalleryImage> createState() => _ZoomableGalleryImageState();
}

class _ZoomableGalleryImageState extends State<_ZoomableGalleryImage> {
  final TransformationController _transform = TransformationController();
  bool _zoomed = false;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _enterZoom() {
    setState(() {
      _zoomed = true;
      _transform.value = Matrix4.identity()..scaleByDouble(2.0, 2.0, 2.0, 1.0);
    });
  }

  void _maybeExitZoom() {
    if (_transform.value.getMaxScaleOnAxis() <= 1.01) {
      _transform.value = Matrix4.identity();
      if (_zoomed) setState(() => _zoomed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = Center(
      child: buildImageSource(
        widget.source,
        fit: BoxFit.contain,
      ),
    );

    if (!_zoomed) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: _enterZoom,
        child: SizedBox.expand(child: image),
      );
    }

    return InteractiveViewer(
      transformationController: _transform,
      minScale: 1,
      maxScale: 4,
      onInteractionEnd: (_) => _maybeExitZoom(),
      child: SizedBox.expand(child: image),
    );
  }
}
