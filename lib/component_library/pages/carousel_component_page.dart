import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/pep_carousel.dart';

/// Atom: Material 3 Carousel ([CarouselView.weighted]).
class CarouselComponentPage extends StatelessWidget {
  const CarouselComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'carousel',
    title: 'Carousel',
    m3SpecUrl: 'https://m3.material.io/components/carousel/specs',
    description:
        'Horizontal media strip using Flutter Material 3 '
        '`CarouselView.weighted`. Specs: leading/trailing 16, top/bottom 8, '
        'gap 8, small 40–56, radius 28, large dynamic. Layouts: Hero, '
        'Center-aligned hero, Multi-browse. Featured captions live on '
        '`PepCarouselFeaturedCard`. 活動 Items List uses Hero from this kit.',
    group: ComponentLibraryGroup.atom,
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'PepCarousel',
      spec:
          'M3 metrics: edges 16, gap 8, radius 28; small item 40–56. '
          'Featured height = Image header (min(w/(4/3), 320)). '
          'Layouts: hero / centerAlignedHero / multiBrowse.',
      setupCode: '''
PepCarouselFeaturedBox(
  child: PepCarousel(
    layout: PepCarouselLayout.hero,
    itemCount: items.length,
    itemBuilder: (context, index) => PepCarouselFeaturedCard(...),
  ),
)
''',
    ),
    ComponentNote(
      topic: 'PepCarouselFeaturedCard caption',
      spec:
          'Local glass bottom bar on featured items only. glassBrightness from '
          'cover band; title onSurface; badge inverseSurface / onInverseSurface '
          'via GlassMediaInk; padding 16×12; titleMedium.',
      setupCode: '''
PepCarouselFeaturedCard(
  image: assetPath,
  title: 'Featured title',
  dateBadge: 'Mar 12',
)
''',
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
      'assets/images/demo/demo_header_5.png',
      'Feb 1 - Feb 14',
      '情人節甜點體驗工作坊',
    ),
    (
      'assets/images/demo/demo_header_4.png',
      'Jan 5 - Jan 12',
      '新年市集週末限定開幕',
    ),
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
            'Hero · M3 padding 16/8 · gap 8 · radius 28 · small 40–56',
            style: labelStyle,
          ),
          const SizedBox(height: 12),
          PepCarouselFeaturedBox(
            child: PepCarousel(
              layout: PepCarouselLayout.hero,
              onTap: (_) {},
              children: [
                for (final item in _demoItems)
                  PepCarouselFeaturedCard(
                    image: item.$1,
                    dateBadge: item.$2,
                    title: item.$3,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Center-aligned hero · M3 metrics · infinite',
            style: labelStyle,
          ),
          const SizedBox(height: 12),
          PepCarouselFeaturedBox(
            child: PepCarousel(
              layout: PepCarouselLayout.centerAlignedHero,
              onTap: (_) {},
              children: [
                for (final item in _demoItems)
                  PepCarouselFeaturedCard(
                    image: item.$1,
                    dateBadge: item.$2,
                    title: item.$3,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Multi-browse · M3 metrics · infinite',
            style: labelStyle,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: kPepCarouselCompactHeight,
            child: PepCarousel(
              layout: PepCarouselLayout.multiBrowse,
              elevation: 0,
              onTap: (_) {},
              children: [
                for (final item in _demoItems)
                  PepCarouselFeaturedCard(
                    image: item.$1,
                    title: item.$3,
                    showCaption: false,
                  ),
                // Need enough children for 5 visible slots.
                for (final item in _demoItems)
                  PepCarouselFeaturedCard(
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
