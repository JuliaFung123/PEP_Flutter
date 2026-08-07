import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/image_source.dart';
import '../widgets/photo_gallery.dart';

/// Layout block: thumbnail grid → full-page swipe gallery.
class PhotoGalleryComponentPage extends StatelessWidget {
  const PhotoGalleryComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'photo_gallery',
    title: 'Photo gallery',
    m3SpecUrl: 'https://m3.material.io/components/image-lists/overview',
    description:
        'Thumbnail grid of photos. Tap a thumb to open a full-page viewer; '
        'swipe left/right for the next image. Shared fullscreen page with '
        'Image header badge gallery.',
    group: ComponentLibraryGroup.layoutBlock,
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Thumbnails',
      m3Behavior: 'Image list / grid of media previews.',
      ourImplementation:
          '`PhotoGallery` — GridView (default 3 columns), `BoxFit.cover`, '
          '12dp corners. Pass `images` as asset paths or network URLs.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Full-page viewer',
      m3Behavior: 'Immersive media viewer with paging.',
      ourImplementation:
          'Opens `ImageHeaderGalleryPage`: black scaffold, top close (48) '
          'returns to the grid; drag/swipe (touch + mouse) for next/prev; '
          'double-tap to zoom (InteractiveViewer only while zoomed).',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Caption / credit under thumb',
      foundIn: 'Content detail exploration',
      description: 'Optional title or credit line below each thumbnail.',
      suggestedAction: 'Add when product needs labeled gallery cells',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: meta.title,
      m3SpecUrl: meta.m3SpecUrl,
      description: meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '3-column thumbnails · tap to open · swipe in full page',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          const PhotoGallery(images: kDemoImageHeaderAssets),
        ],
      ),
    );
  }
}
