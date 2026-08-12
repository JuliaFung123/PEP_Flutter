import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/scroll_nav.dart';

/// In-page scroll navigation — primary TabBar UI, single long page.
class ScrollNavComponentPage extends StatefulWidget {
  const ScrollNavComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'scroll_nav',
    title: 'scroll nav',
    m3SpecUrl: 'https://m3.material.io/components/tabs/specs',
    description:
        'Section jumper for one long scrolling page. Tap a tab to scroll to '
        'that [ScrollNavSection]; scrolling updates the active tab via '
        '[ScrollNavLinker].',
    group: ComponentLibraryGroup.layoutBlock,
  );

  @override
  State<ScrollNavComponentPage> createState() => _ScrollNavComponentPageState();
}

class _ScrollNavComponentPageState extends State<ScrollNavComponentPage> {
  static const _labels = ['Ticket', '圖文', 'additional_info'];

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'ScrollNav / ScrollNavSection / ScrollNavLinker',
      spec:
          'Primary TabBar chrome only. Section padding 16/20/16/24 '
          '(no bg/outline/radius). Linker: tap → scroll; scroll → tab.',
      setupCode: '''
ScrollNav(
  labels: labels,
  selectedIndex: index,
  onDestinationSelected: (i) {},
)
ScrollNavSection(
  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
  child: content,
)
''',
    ),
  ];

  static const _pending = <PendingVariant>[];

  final _scrollController = ScrollController();
  final _listViewportKey = GlobalKey();
  final _navLinker = ScrollNavLinker(sectionCount: 3);

  @override
  void initState() {
    super.initState();
    _navLinker.addListener(_onLinkerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navLinker.attach(
        scrollController: _scrollController,
        pinnedExtent: _listTop,
      );
      _navLinker.syncFromScroll();
    });
  }

  @override
  void dispose() {
    _navLinker
      ..removeListener(_onLinkerChanged)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onLinkerChanged() {
    if (mounted) setState(() {});
  }

  double _listTop() {
    final box =
        _listViewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return 0;
    return box.localToGlobal(Offset.zero).dy;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ComponentPageScaffold(
      title: ScrollNavComponentPage.meta.title,
      m3SpecUrl: ScrollNavComponentPage.meta.m3SpecUrl,
      description: ScrollNavComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Demo', style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Tap a tab to jump. Scroll the list to move the active tab.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: colorScheme.surface,
            child: SizedBox(
              height: 480,
              child: Column(
                children: [
                  ScrollNav(
                    labels: _labels,
                    selectedIndex: _navLinker.index,
                    onDestinationSelected: _navLinker.select,
                  ),
                  Expanded(
                    child: KeyedSubtree(
                      key: _listViewportKey,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          for (var i = 0; i < _labels.length; i++)
                            ScrollNavSection(
                              key: _navLinker.sectionKeys[i],
                              child: SizedBox(
                                height: 420,
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '${_labels[i]}\n\n'
                                    'Scroll within this demo — each section is taller '
                                    'than the visible area so you can try jump + scroll spy.',
                                    style: textTheme.titleLarge,
                                  ),
                                ),
                              ),
                            ),
                        ],
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
