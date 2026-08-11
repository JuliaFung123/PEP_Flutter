import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/glass_surface.dart';
import '../widgets/image_source.dart';

/// Custom glass / frosted surface (not an M3 component).
class GlassSurfaceComponentPage extends StatelessWidget {
  const GlassSurfaceComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'glass_surface',
    title: 'Glass surface',
    m3SpecUrl:
        'https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html',
    description:
        'Frosted-glass panel: blurs content behind it and tints with a '
        'translucent ColorScheme surface. Not defined by Material 3 — built '
        'with Flutter BackdropFilter. Prefer small clipped regions for '
        'performance.',
    group: ComponentLibraryGroup.effect,
    sortOrder: 1,
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Glass surface',
      m3Behavior: 'No M3 Glass component or token.',
      ourImplementation:
          '`GlassSurface` — `ClipRRect` + `BackdropFilter` (blur) + translucent '
          '`ColorScheme.surface` tint. Normal 20% / strong 40%. Light '
          '`outlineVariant` border. Defaults: sigma 16, radius 16.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Tint / blur / gradient',
      m3Behavior: 'N/A — product visual treatment.',
      ourImplementation:
          'Solid tint via `glassSurfaceTint` (normal/strong), or '
          '`glassBottomCaptionGradient` (clear → same opacity). Blur and '
          'gradient combine on caption bars. `blurSigma: 0` skips '
          'BackdropFilter. Must sit above painted content to show blur.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Performance',
      m3Behavior: 'N/A.',
      ourImplementation:
          'Clip tightly; avoid many nested or full-screen glass panels '
          '(especially in long lists).',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Glass app bar / nav overlay',
      foundIn: 'Product exploration',
      description: 'Translucent scrolling app bar over media.',
      suggestedAction: 'Add when a layout needs frosted chrome',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurfaceVariant;

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
            'Normal · 20% tint',
            style: textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 220,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  buildImageSource(
                    kDemoImageHeaderAssets[4],
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GlassSurface(
                      width: 220,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Glass card',
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Strong · 40% tint',
            style: textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  buildImageSource(
                    kDemoImageHeaderAssets[2],
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: GlassSurface(
                      tint: glassSurfaceTint(colorScheme, strong: true),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Text('Strong glass', style: textTheme.labelLarge),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Caption · blur + gradient (→ 20%)',
            style: textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  buildImageSource(
                    kDemoImageHeaderAssets[1],
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GlassSurface(
                      borderRadius: BorderRadius.zero,
                      borderWidth: 0,
                      width: double.infinity,
                      gradient: glassBottomCaptionGradient(colorScheme),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        'Gradient caption over media',
                        style: textTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Caption · blur + gradient strong (→ 40%)',
            style: textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  buildImageSource(
                    kDemoImageHeaderAssets[1],
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GlassSurface(
                      borderRadius: BorderRadius.zero,
                      borderWidth: 0,
                      width: double.infinity,
                      gradient: glassBottomCaptionGradient(
                        colorScheme,
                        strong: true,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        'Strong gradient caption',
                        style: textTheme.titleSmall,
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
