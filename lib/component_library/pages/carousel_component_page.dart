import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/kpi_carousel.dart';

/// Atom: Material 3 Carousel ([CarouselView.weighted]).
class CarouselComponentPage extends StatelessWidget {
  const CarouselComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'carousel',
    title: 'Carousel',
    m3SpecUrl: 'https://m3.material.io/components/carousel/specs',
    description:
        'Horizontal media strip using Flutter Material 3 '
        '`CarouselView.weighted`. Kit layouts match M3 Hero, Center-aligned '
        'hero, and Multi-browse. Item content uses '
        '`KpiCarouselFeaturedCard`.',
    group: ComponentLibraryGroup.atom,
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Hero',
      m3Behavior:
          'At least one large and one small item. '
          'https://m3.material.io/components/carousel/specs',
      ourImplementation:
          '`KpiCarousel(layout: hero)` — large then small. Small item width '
          'locked to M3 40–56dp (target 56); `shrinkExtent: 40`. Caption only '
          'when item width > 56.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Center-aligned hero',
      m3Behavior:
          'Large item centered with small peeks on both sides. '
          'https://m3.material.io/components/carousel/specs',
      ourImplementation:
          '`KpiCarousel(layout: centerAlignedHero)` — small · large · small. '
          'Small peeks 40–56dp; no caption on small.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Multi-browse',
      m3Behavior:
          'At least one large, medium, and small item visible. '
          'https://m3.material.io/components/carousel/specs',
      ourImplementation:
          '`KpiCarousel(layout: multiBrowse)` — large/medium/small. Small '
          'slots 40–56dp (`consumeMaxWeight: false`). Compact strips use '
          '`showCaption: false`.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Featured card',
      m3Behavior: 'Carousel item content is app-defined.',
      ourImplementation:
          '`KpiCarouselFeaturedCard` — cover image; liquid-glass caption with '
          'content-aware title color (white on dark media, `onSurface` on '
          'light). Small items are image-only. Badge: `surface` / `onSurface`.',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Auto-playing carousel',
      foundIn: 'Destination landing exploration',
      description: 'Auto-advance timer between items.',
      suggestedAction: 'Add when product needs timed playback',
    ),
  ];

  static const _demoItems = <(String image, String badge, String title)>[
    (
      'assets/images/demo/demo_header_1.png',
      'Dec 2 - Dec 20',
      '聖誕Party將於24日下午1點開始',
    ),
    (
      'assets/images/demo/demo_header_2.png',
      'Dec 14 - Dec 24',
      '聖誕Party將於24日下午1點開始',
    ),
    (
      'assets/images/demo/demo_header_3.png',
      'Dec 1 - Dec 31',
      '冬季限定活動開放報名中',
    ),
    (
      'assets/images/demo/demo_header_4.png',
      'Jan 5 - Jan 12',
      '新年市集週末限定開幕',
    ),
    (
      'assets/images/demo/demo_header_5.png',
      'Feb 1 - Feb 14',
      '情人節甜點體驗工作坊',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final labelStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: muted);

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
            'Hero · large then small (small 40–56dp)',
            style: labelStyle,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: kKpiCarouselFeaturedHeight,
            child: KpiCarousel(
              layout: KpiCarouselLayout.hero,
              onTap: (_) {},
              children: [
                for (final item in _demoItems)
                  KpiCarouselFeaturedCard(
                    image: item.$1,
                    dateBadge: item.$2,
                    title: item.$3,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Center-aligned hero · small · large · small (small 40–56dp)',
            style: labelStyle,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: kKpiCarouselFeaturedHeight,
            child: KpiCarousel(
              layout: KpiCarouselLayout.centerAlignedHero,
              onTap: (_) {},
              children: [
                for (final item in _demoItems)
                  KpiCarouselFeaturedCard(
                    image: item.$1,
                    dateBadge: item.$2,
                    title: item.$3,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Multi-browse · large / medium / small (small 40–56dp)',
            style: labelStyle,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: kKpiCarouselCompactHeight,
            child: KpiCarousel(
              layout: KpiCarouselLayout.multiBrowse,
              elevation: 0,
              onTap: (_) {},
              children: [
                for (final item in _demoItems)
                  KpiCarouselFeaturedCard(
                    image: item.$1,
                    title: item.$3,
                    showCaption: false,
                  ),
                // Need enough children for 5 visible slots.
                for (final item in _demoItems)
                  KpiCarouselFeaturedCard(
                    image: item.$1,
                    title: item.$3,
                    showCaption: false,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
