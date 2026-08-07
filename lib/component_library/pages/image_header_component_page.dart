import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/image_header_widget.dart';

/// Image header — single size variant.
class ImageHeaderComponentPage extends StatelessWidget {
  const ImageHeaderComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'image_header',
    title: 'Image header',
    m3SpecUrl:
        'https://www.figma.com/design/61SERD0hYvuj7BrwBRv210/PEP_APP-2?node-id=265-6607&t=cri1iqqDqaC4gUf3-4',
    description:
        'Hero image header with pager dots and a floating badge. '
        'Full-width block; height = min(width÷4:3, 320); image BoxFit.cover.',
    group: ComponentLibraryGroup.layoutBlock,
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Size',
      m3Behavior: 'Hero media block before page content.',
      ourImplementation:
          'Always full width. Height = min(width ÷ 4:3, 320). '
          'On wide screens height caps at 320 (box may be wider than 4:3).',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Image fit',
      m3Behavior: 'Media fills the hero frame without distortion.',
      ourImplementation:
          '`BoxFit.cover` — fills the whole box, crops overflow, never stretches. '
          'Full-page gallery still uses contain.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Pager + badge',
      m3Behavior:
          'Shows image position and a compact count or CTA in the bottom-right corner.',
      ourImplementation:
          'Swipeable PageView with live dots; badge shows index/total and opens a full-page gallery.',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Auto-playing carousel header',
      foundIn: 'Destination landing exploration',
      description:
          'Cycles through images automatically and exposes pause/resume behavior.',
      suggestedAction: 'Create only when carousel behavior is finalized',
    ),
    PendingVariant(
      name: 'Sliver-collapsing image header',
      foundIn: '活動 (Activity) page',
      description:
          'Image header as FlexibleSpaceBar background that collapses with a '
          'pinned SliverAppBar; badge still opens the full-page gallery.',
      suggestedAction:
          'Confirm whether this composition is documented under Image header '
          'or App bars',
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
      variantsSection: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ImageHeaderPreviewCard(
            title: 'Full width · height min(w÷4:3, 320) · cover',
            child: ImageHeaderWidget(),
          ),
        ],
      ),
    );
  }
}

class _ImageHeaderPreviewCard extends StatelessWidget {
  const _ImageHeaderPreviewCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Center(child: child),
          ],
        ),
      ),
    );
  }
}
