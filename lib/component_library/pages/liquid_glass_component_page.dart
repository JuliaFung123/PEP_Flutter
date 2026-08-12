import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/glass_media_brightness.dart';
import '../widgets/image_source.dart';

/// Apple-style liquid glass via [liquid_glass_widgets] (shader + blur).
class LiquidGlassComponentPage extends StatelessWidget {
  const LiquidGlassComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'liquid_glass',
    title: 'Liquid glass',
    m3SpecUrl: 'https://pub.dev/packages/liquid_glass_widgets',
    description:
        'iOS 26–style liquid glass from `liquid_glass_widgets`: shader '
        'refraction / blur on Impeller, lightweight shader on Skia/Web. Prefer '
        'for navigation chrome and a few static panels — not every list row. '
        'Requires `LiquidGlassWidgets.initialize()` + `.wrap()` in main. '
        'Light/dark follows the background image or color, not app theme.',
    group: ComponentLibraryGroup.effect,
    sortOrder: 2,
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'GlassCard / GlassContainer',
      spec:
          'liquid_glass_widgets; prefer GlassQuality.standard. Premium = '
          'Impeller-only. Wrap container child in GlassMediaInk once.',
      setupCode: '''
GlassContainer(
  quality: GlassQuality.standard,
  child: child,
)
''',
    ),
  ];

  static const _pending = <PendingVariant>[];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final labelStyle = textTheme.bodySmall?.copyWith(color: muted);

    return ComponentPageScaffold(
      title: meta.title,
      m3SpecUrl: meta.m3SpecUrl,
      description: meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Card · standard · dark image', style: labelStyle),
          const SizedBox(height: 12),
          GlassMediaAwareFrame(
            image: kDemoImageHeaderAssets[4],
            builder: (context, mediaBrightness) {
              return GlassCard(
                useOwnLayer: true,
                quality: GlassQuality.standard,
                width: 240,
                child: Text(
                  'Liquid glass card',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text('Card · minimal · lighter image', style: labelStyle),
          const SizedBox(height: 12),
          GlassMediaAwareFrame(
            image: kDemoImageHeaderAssets[1],
            builder: (context, mediaBrightness) {
              return GlassCard(
                useOwnLayer: true,
                quality: GlassQuality.minimal,
                width: 240,
                child: Text(
                  'Minimal glass',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text('Card · pale solid color bg', style: labelStyle),
          const SizedBox(height: 12),
          GlassMediaAwareFrame(
            color: const Color(0xFFE8E4DC),
            builder: (context, mediaBrightness) {
              return GlassCard(
                useOwnLayer: true,
                quality: GlassQuality.standard,
                width: 240,
                child: Text(
                  'Over pale color',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
