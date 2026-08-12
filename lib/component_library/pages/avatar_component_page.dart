import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/image_source.dart';
import '../widgets/pep_avatar.dart';

/// Avatar atom — Figma Flutter UI kit.
///
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2064-617
class AvatarComponentPage extends StatefulWidget {
  const AvatarComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'avatar',
    title: 'Avatar',
    m3SpecUrl:
        'https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2064-617',
    description:
        'Circular avatars from the Flutter UI kit: Primary (primary / '
        'onPrimary initials), Secondary (surfaceContainerHighest / onSurface), '
        'Image. Sizes: 24, XS 32, S 40, M 48, L 56, XL 72. Also Avatar Group '
        'and Avatar Name compositions.',
    group: ComponentLibraryGroup.atom,
  );

  @override
  State<AvatarComponentPage> createState() => _AvatarComponentPageState();
}

class _AvatarComponentPageState extends State<AvatarComponentPage> {
  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'PepAvatar',
      spec:
          'Figma types Primary / Secondary / Image. Sizes 24·32·40·48·56·72. '
          'Initials use bodyMedium (≤48), larger type at L/XL. Colors from '
          'ColorScheme.',
      setupCode: '''
PepAvatar(
  size: PepAvatarSize.m48,
  type: PepAvatarType.primary,
  initials: 'S',
)
PepAvatar(
  size: PepAvatarSize.s40,
  type: PepAvatarType.image,
  image: AssetImage('...'),
)
''',
    ),
    ComponentNote(
      topic: 'PepAvatarGroup',
      spec:
          'Overlapping stack (−4 overlap, 2dp surface ring) + optional +N. '
          'Group sizes 32 / 40 / 48.',
      setupCode: '''
PepAvatarGroup(
  size: PepAvatarSize.m48,
  images: [...],
  maxVisible: 5,
  overflowCount: 99,
)
''',
    ),
    ComponentNote(
      topic: 'PepAvatarName',
      spec:
          'Avatar + name (+ subtitle). Gap 8. Name titleMedium; subtitle '
          'bodyMedium (40/48) or bodySmall (32).',
      setupCode: '''
PepAvatarName(
  size: PepAvatarSize.s40,
  name: 'Name',
  subtitle: 'Subtitle',
  image: AssetImage('...'),
)
''',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Avatar + Badge',
      foundIn: 'Profile / notifications',
      description: 'Status or count badge on avatar corner.',
      suggestedAction: 'Compose Badge over PepAvatar when product needs it',
    ),
  ];

  static final _demoImage = AssetImage(kDemoImageHeaderAssets[0]);

  static final _groupImages = <ImageProvider>[
    for (var i = 0; i < 5; i++) AssetImage(kDemoImageHeaderAssets[i % 5]),
  ];

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final labelStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: muted);

    return ComponentPageScaffold(
      title: AvatarComponentPage.meta.title,
      m3SpecUrl: AvatarComponentPage.meta.m3SpecUrl,
      description: AvatarComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Types × sizes · PepAvatar', style: labelStyle),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final size in PepAvatarSize.values) ...[
                  _sizeColumn(
                    context,
                    size: size,
                    labelStyle: labelStyle,
                  ),
                  const SizedBox(width: 16),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('Avatar Group · PepAvatarGroup', style: labelStyle),
          const SizedBox(height: 12),
          for (final size in [
            PepAvatarSize.m48,
            PepAvatarSize.xs32,
            PepAvatarSize.s40,
          ]) ...[
            Text(size.label, style: labelStyle),
            const SizedBox(height: 8),
            PepAvatarGroup(
              size: size,
              images: _groupImages,
              maxVisible: 5,
              overflowCount: 99,
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 16),
          Text('Avatar Name · PepAvatarName', style: labelStyle),
          const SizedBox(height: 12),
          for (final size in [
            PepAvatarSize.m48,
            PepAvatarSize.s40,
            PepAvatarSize.xs32,
          ]) ...[
            PepAvatarName(
              size: size,
              name: 'Name',
              subtitle: 'Subtitle',
              image: _demoImage,
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _sizeColumn(
    BuildContext context, {
    required PepAvatarSize size,
    required TextStyle? labelStyle,
  }) {
    return Column(
      children: [
        Text(size.label, style: labelStyle),
        const SizedBox(height: 8),
        PepAvatar(
          size: size,
          type: PepAvatarType.primary,
          initials: 'S',
        ),
        const SizedBox(height: 8),
        PepAvatar(
          size: size,
          type: PepAvatarType.secondary,
          initials: 'S',
        ),
        const SizedBox(height: 8),
        PepAvatar(
          size: size,
          type: PepAvatarType.image,
          image: _demoImage,
        ),
      ],
    );
  }
}
