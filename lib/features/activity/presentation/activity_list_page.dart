import 'package:flutter/material.dart';

import '../../../component_library/pages/app_bars_component_page.dart'
    show
        kM3AppBarEdgePadding,
        kM3AppBarIconButtonSize,
        kM3AppBarLeadingWidth,
        kM3AppBarTitleGap,
        kM3ToolbarHeight;
import '../../../component_library/widgets/act_list_item.dart';
import '../../../component_library/widgets/pep_carousel.dart';
import '../../../core/theme/app_typography.dart';
import 'activity_page.dart';

/// Activity catalog — Figma:
/// https://www.figma.com/design/61SERD0hYvuj7BrwBRv210/PEP_APP-2?node-id=40-1643
///
/// First 活動 page:
/// - Featured strip: library Atom → Carousel Hero
///   (`PepCarouselFeaturedBox` + `PepCarousel` + `PepCarouselFeaturedCard`)
/// - List rows: library Layout Block → Act. List (`ActListItem`)
/// Tap → [ActivityPage].
class ActivityListPage extends StatelessWidget {
  const ActivityListPage({super.key});

  static const _title = 'Items List';

  static const _featured = <_FeaturedItem>[
    _FeaturedItem(
      // Bottom band reads light → dark caption ink (strawberry demo).
      image: 'assets/images/demo/demo_header_5.png',
      dateBadge: 'Dec 2 - Dec 20',
      title: '聖誕Party將於24日下午1點開始',
    ),
    _FeaturedItem(
      // Bottom band reads dark → light caption ink.
      image: 'assets/images/demo/demo_header_4.png',
      dateBadge: 'Jan 5 - Jan 12',
      title: '新年市集週末限定開幕',
    ),
  ];

  static const _list = <_ListItem>[
    _ListItem(
      image: 'assets/images/demo/demo_header_4.png',
      title: '聖誕Party將於24日下午1點開始',
      location: 'Location Name',
      dateRange: '12月14日 - 12月20日',
    ),
    _ListItem(
      image: 'assets/images/demo/demo_header_2.png',
      title:
          '活動標題最多3行。獨家優惠：香港文華東方酒店度假住宿連餐飲優惠活動標題最多3行。香港文華東方酒店度假住宿連餐飲優惠',
      location: 'Location Name',
      dateRange: '12月14日 - 12月20日',
    ),
    _ListItem(
      image: 'assets/images/demo/demo_header_3.png',
      title: '聖誕Party將於24日下午1點開始',
      location: 'Location Name',
      dateRange: '12月14日 - 12月20日',
    ),
  ];

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ActivityPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final typography = AppTypography.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: kM3ToolbarHeight,
        scrolledUnderElevation: 3,
        leadingWidth: kM3AppBarLeadingWidth,
        titleSpacing: kM3AppBarTitleGap,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: kM3AppBarEdgePadding),
          child: Align(
            child: SizedBox(
              width: kM3AppBarIconButtonSize,
              height: kM3AppBarIconButtonSize,
              child: IconButton(
                onPressed: () => Navigator.maybeOf(context)?.maybePop(),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  foregroundColor: colorScheme.onSurface,
                  minimumSize: const Size(
                    kM3AppBarIconButtonSize,
                    kM3AppBarIconButtonSize,
                  ),
                  maximumSize: const Size(
                    kM3AppBarIconButtonSize,
                    kM3AppBarIconButtonSize,
                  ),
                  fixedSize: const Size(
                    kM3AppBarIconButtonSize,
                    kM3AppBarIconButtonSize,
                  ),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.standard,
                ),
                icon: const Icon(Icons.arrow_back, size: 24),
              ),
            ),
          ),
        ),
        title: Text(
          _title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: typography.titleSemiLarge,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          PepCarouselFeaturedBox(
            child: PepCarousel(
              layout: PepCarouselLayout.hero,
              onTap: (_) => _openDetail(context),
              children: [
                for (final item in _featured)
                  PepCarouselFeaturedCard(
                    image: item.image,
                    dateBadge: item.dateBadge,
                    title: item.title,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              for (final item in _list)
                ActListItem(
                  image: item.image,
                  title: item.title,
                  location: item.location,
                  dateRange: item.dateRange,
                  onTap: () => _openDetail(context),
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FeaturedItem {
  const _FeaturedItem({
    required this.image,
    required this.dateBadge,
    required this.title,
  });

  final String image;
  final String dateBadge;
  final String title;
}

class _ListItem {
  const _ListItem({
    required this.image,
    required this.title,
    required this.location,
    required this.dateRange,
  });

  final String image;
  final String title;
  final String location;
  final String dateRange;
}
