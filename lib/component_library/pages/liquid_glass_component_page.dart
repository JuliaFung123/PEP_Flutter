import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
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
        'Requires `LiquidGlassWidgets.initialize()` + `.wrap()` in main.',
    group: ComponentLibraryGroup.effect,
    sortOrder: 2,
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Package',
      m3Behavior: 'No M3 liquid-glass component.',
      ourImplementation:
          '`liquid_glass_widgets` — `GlassCard` / `GlassContainer` with '
          '`GlassQuality.standard` (default). Premium is Impeller-only; '
          'minimal is BackdropFilter-only. Foreground over media: white.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Performance',
      m3Behavior: 'N/A.',
      ourImplementation:
          'Use standard for most UI; premium only on fixed chrome; minimal for '
          'many panels in a scroll. Keep glass sparse (bars / few cards).',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'vs Glass surface',
      m3Behavior: 'N/A.',
      ourImplementation:
          '`GlassSurface` is our light BackdropFilter + tint/gradient. Use '
          'Liquid glass when you want refraction / iOS-26 look; otherwise prefer '
          'Glass surface for captions and small frost panels.',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[];

  /// Foreground on liquid-glass panels over media (light icons/labels).
  static const _glassForeground = Colors.white;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

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
            'Card · standard quality',
            style: textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          _GlassDemoFrame(
            image: kDemoImageHeaderAssets[4],
            child: GlassCard(
              useOwnLayer: true,
              quality: GlassQuality.standard,
              width: 240,
              child: Text(
                'Liquid glass card',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(color: _glassForeground),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Card · minimal (BackdropFilter only)',
            style: textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          _GlassDemoFrame(
            image: kDemoImageHeaderAssets[1],
            child: GlassCard(
              useOwnLayer: true,
              quality: GlassQuality.minimal,
              width: 240,
              child: Text(
                'Minimal glass',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(color: _glassForeground),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Caption bar · GlassContainer',
            style: textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          _GlassDemoFrame(
            height: 180,
            image: kDemoImageHeaderAssets[2],
            alignment: Alignment.bottomCenter,
            child: GlassContainer(
              useOwnLayer: true,
              quality: GlassQuality.standard,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: const LiquidRoundedSuperellipse(borderRadius: 0),
              child: Text(
                'Liquid glass caption',
                style: textTheme.titleSmall?.copyWith(color: _glassForeground),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassDemoFrame extends StatelessWidget {
  const _GlassDemoFrame({
    required this.image,
    required this.child,
    this.height = 220,
    this.alignment = Alignment.center,
  });

  final String image;
  final Widget child;
  final double height;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        child: GlassPage(
          background: buildImageSource(image, fit: BoxFit.cover),
          child: Align(alignment: alignment, child: child),
        ),
      ),
    );
  }
}
