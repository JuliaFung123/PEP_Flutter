import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/act_list_item.dart';
import '../widgets/component_page_scaffold.dart';

/// Layout block: activity catalog list row (Figma List/活動).
class ActListComponentPage extends StatelessWidget {
  const ActListComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'act_list',
    title: 'Act. List',
    m3SpecUrl:
        'https://www.figma.com/design/61SERD0hYvuj7BrwBRv210/PEP_APP-2?node-id=40-1643',
    description:
        'Activity catalog list row (Figma List/活動). Thumb + title + '
        'location/date metadata. Used on 活動 Items List.',
    group: ComponentLibraryGroup.layoutBlock,
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'ActListItem',
      spec:
          'Thumb 140×128 (radius 16); titleMedium max 3 lines (onSurface); '
          'location + date bodyMedium (onSurfaceVariant); padding 16×8; gap 8.',
      setupCode: '''
ActListItem(
  image: imageUrl,
  title: title,
  location: location,
  dateRange: dateRange,
  onTap: () {},
);
''',
    ),
  ];

  static const _pending = <PendingVariant>[];

  static const _demo = <(String image, String title, String location, String date)>[
    (
      'assets/images/demo/demo_header_4.png',
      '聖誕Party將於24日下午1點開始',
      'Location Name',
      '12月14日 - 12月20日',
    ),
    (
      'assets/images/demo/demo_header_2.png',
      '活動標題最多3行。獨家優惠：香港文華東方酒店度假住宿連餐飲優惠活動標題最多3行。香港文華東方酒店度假住宿連餐飲優惠',
      'Location Name',
      '12月14日 - 12月20日',
    ),
    (
      'assets/images/demo/demo_header_3.png',
      '聖誕Party將於24日下午1點開始',
      'Location Name',
      '12月14日 - 12月20日',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            'List example · titleMedium · bodyMedium · padding 16×8 · no radius',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              for (final item in _demo)
                ActListItem(
                  image: item.$1,
                  title: item.$2,
                  location: item.$3,
                  dateRange: item.$4,
                  onTap: () {},
                ),
            ],
          ),
        ],
      ),
    );
  }
}
