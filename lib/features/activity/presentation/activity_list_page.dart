import 'package:flutter/material.dart';

import '../../../component_library/pages/app_bars_component_page.dart'
    show
        kM3AppBarEdgePadding,
        kM3AppBarIconButtonSize,
        kM3AppBarLeadingWidth,
        kM3AppBarTitleGap,
        kM3ToolbarHeight;
import '../../../component_library/widgets/image_source.dart';
import '../../../component_library/widgets/kpi_carousel.dart';
import '../../../core/theme/app_typography.dart';
import 'activity_page.dart';

/// Activity catalog — Figma:
/// https://www.figma.com/design/61SERD0hYvuj7BrwBRv210/PEP_APP-2?node-id=40-1643
///
/// First 活動 page: featured [KpiCarousel] + list. Tap → [ActivityPage].
class ActivityListPage extends StatelessWidget {
  const ActivityListPage({super.key});

  static const _title = 'Items List';

  static const _featured = <_FeaturedItem>[
    _FeaturedItem(
      image: 'assets/images/demo/demo_header_1.png',
      dateBadge: 'Dec 2 - Dec 20',
      title: '聖誕Party將於24日下午1點開始',
    ),
    _FeaturedItem(
      image: 'assets/images/demo/demo_header_2.png',
      dateBadge: 'Dec 14 - Dec 24',
      title: '聖誕Party將於24日下午1點開始',
    ),
    _FeaturedItem(
      image: 'assets/images/demo/demo_header_3.png',
      dateBadge: 'Dec 1 - Dec 31',
      title: '冬季限定活動開放報名中',
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
          SizedBox(
            height: kKpiCarouselFeaturedHeight,
            child: KpiCarousel(
              layout: KpiCarouselLayout.hero,
              onTap: (_) => _openDetail(context),
              children: [
                for (final item in _featured)
                  KpiCarouselFeaturedCard(
                    image: item.image,
                    dateBadge: item.dateBadge,
                    title: item.title,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (var i = 0; i < _list.length; i++) ...[
                  _ActivityListRow(
                    item: _list[i],
                    onTap: () => _openDetail(context),
                  ),
                ],
              ],
            ),
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

/// Temporary stand-in for Figma `List/活動` — pending library review.
class _ActivityListRow extends StatelessWidget {
  const _ActivityListRow({required this.item, required this.onTap});

  final _ListItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 140,
                  height: 128,
                  child: buildImageSource(item.image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.location,
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.dateRange,
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
