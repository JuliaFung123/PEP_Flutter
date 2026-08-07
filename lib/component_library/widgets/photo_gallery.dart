import 'package:flutter/material.dart';

import 'image_header_gallery_page.dart';
import 'image_source.dart';

/// Thumbnail grid that opens a full-page swipeable gallery on tap.
///
/// Full-screen viewer reuses [ImageHeaderGalleryPage] (contain fit, page dots count).
class PhotoGallery extends StatelessWidget {
  const PhotoGallery({
    super.key,
    required this.images,
    this.crossAxisCount = 3,
    this.spacing = 8,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.childAspectRatio = 1,
  });

  final List<String> images;

  /// Thumbnail columns (default 3).
  final int crossAxisCount;

  final double spacing;
  final BorderRadius borderRadius;
  final double childAspectRatio;

  void _openGallery(BuildContext context, int index) {
    if (images.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ImageHeaderGalleryPage(
          images: images,
          initialIndex: index.clamp(0, images.length - 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const SizedBox(
          height: 120,
          child: Center(child: Icon(Icons.photo_outlined)),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        return Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _openGallery(context, index),
            child: buildImageSource(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      },
    );
  }
}
