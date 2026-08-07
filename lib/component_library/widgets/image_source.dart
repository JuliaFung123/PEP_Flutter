import 'package:flutter/material.dart';

/// Builds an [Image] from a network URL or local asset path.
///
/// Prefer [BoxFit.cover] for framed areas (fills without distortion; may crop)
/// and [BoxFit.contain] for full-page viewers (no crop).
Widget buildImageSource(
  String source, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  Alignment alignment = Alignment.center,
}) {
  final isNetwork =
      source.startsWith('http://') || source.startsWith('https://');
  if (isNetwork) {
    return Image.network(
      source,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: Icon(Icons.broken_image_outlined)),
      ),
    );
  }
  return Image.asset(
    source,
    fit: fit,
    width: width,
    height: height,
    alignment: alignment,
    errorBuilder: (context, error, stackTrace) => ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.broken_image_outlined)),
    ),
  );
}

/// Demo images bundled with the app for Image header previews.
const kDemoImageHeaderAssets = <String>[
  'assets/images/demo/demo_header_1.png',
  'assets/images/demo/demo_header_2.png',
  'assets/images/demo/demo_header_3.png',
  'assets/images/demo/demo_header_4.png',
];

/// [ImageProvider] for a network URL or local asset path.
ImageProvider imageProviderFor(String source) {
  final isNetwork =
      source.startsWith('http://') || source.startsWith('https://');
  return isNetwork ? NetworkImage(source) : AssetImage(source);
}
