import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Tabs reference — https://m3.material.io/components/tabs/specs
///
/// Vertical style (Figma):
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2110-2592
class TabsComponentPage extends StatefulWidget {
  const TabsComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'tabs',
    title: 'Tabs',
    m3SpecUrl:
        'https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2110-2592',
    description:
        'Tabs organize peer views under a shared parent. '
        'Primary, secondary, scrollable, and vertical (icon over label) styles.',
  );

  @override
  State<TabsComponentPage> createState() => _TabsComponentPageState();
}

class _TabsComponentPageState extends State<TabsComponentPage> {
  bool _showLeadingIcon = false;
  bool _showBadge = false;

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Primary',
      m3Behavior: 'Prominent top-level section switcher with active indicator.',
      ourImplementation: 'Use `TabBar` with the default primary styling.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Secondary',
      m3Behavior: 'Lower-emphasis tabs nested under another context.',
      ourImplementation: 'Use `TabBar.secondary` for subordinate navigation.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Scrollable',
      m3Behavior: 'Allows more tabs than fit the available width.',
      ourImplementation: 'Use `TabBar` with `isScrollable: true`.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Vertical',
      m3Behavior:
          'Icon stacked above label (Figma Style=Vertical) — height 64, '
          'icon 24, gap 4, bottom indicator.',
      ourImplementation:
          '`Tab` with column layout (icon over label). Always shows icon; '
          'badge overlays the icon (top-right) when Badge is on. '
          'Figma: Flutter UI Material 3 Tab node 2110:2592.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Typography',
      m3Behavior: 'Tab labels use Label Large (14 / Medium / 20).',
      ourImplementation:
          '`textTheme.labelLarge` for all tab labels (horizontal + vertical). '
          'Badge count uses `labelSmall` (11 / Medium / 16).',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Selected color',
      m3Behavior: 'Active tab uses primary for indicator and content.',
      ourImplementation:
          'Selected label + icon use `colorScheme.primary`; unselected use '
          '`onSurfaceVariant`.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Badge',
      m3Behavior:
          'Figma Tab badge: horizontal inline after label; vertical on icon. '
          'Selected primary/onPrimary; unselected inverseSurface/'
          'onInverseSurface; disabled onSurface/onPrimary.',
      ourImplementation:
          'Toggle “Badge”. Horizontal: pill after title (gap 4). Vertical: '
          '`Badge` on the 24px icon. Colors follow Figma Tab node 2110:2592.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Disabled tab',
      m3Behavior: 'Individual tabs can be non-interactive.',
      ourImplementation:
          'Last tab (“More”) is disabled in each preview '
          '(dimmed, taps ignored).',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Segmented tab chips',
      foundIn: 'Filter exploration mocks',
      description:
          'Pill-like segmented controls that behave like tabs but visually match chips.',
      suggestedAction: 'Keep as a separate pattern, not a Tab variant',
    ),
    PendingVariant(
      name: 'In-page section scroll (moved)',
      foundIn: '活動 (Activity) page',
      description:
          'Tab-looking bar that jumps within one long page. Implemented as '
          'Layout Block “scroll nav”, not a Tabs variant.',
      suggestedAction:
          'Use scroll nav library page; remove this pending when confirmed',
    ),
  ];

  static const _variants = <(_TabsPreviewType, String)>[
    (_TabsPreviewType.primary, 'Primary'),
    (_TabsPreviewType.secondary, 'Secondary'),
    (_TabsPreviewType.scrollable, 'Scrollable'),
    (_TabsPreviewType.vertical, 'Vertical'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ComponentPageScaffold(
      title: TabsComponentPage.meta.title,
      m3SpecUrl: TabsComponentPage.meta.m3SpecUrl,
      description: TabsComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VariantIconControls(
            showLeadingIcon: _showLeadingIcon,
            showTrailingIcon: _showBadge,
            leadingLabel: 'Leading icon',
            trailingLabel: 'Badge',
            onLeadingChanged: (value) =>
                setState(() => _showLeadingIcon = value),
            onTrailingChanged: (value) => setState(() => _showBadge = value),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _variants.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _variants[i].$2,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _TabsPreview(
                    type: _variants[i].$1,
                    showIcons: _showLeadingIcon,
                    showBadge: _showBadge,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _TabsPreviewType { primary, secondary, scrollable, vertical }

class _TabsPreview extends StatefulWidget {
  const _TabsPreview({
    required this.type,
    required this.showIcons,
    required this.showBadge,
  });

  final _TabsPreviewType type;
  final bool showIcons;
  final bool showBadge;

  @override
  State<_TabsPreview> createState() => _TabsPreviewState();
}

class _TabsPreviewState extends State<_TabsPreview>
    with SingleTickerProviderStateMixin {
  /// Last tab (“More”) is disabled.
  static const _disabledIndex = 3;

  /// Figma Vertical tab height.
  static const _verticalTabHeight = 64.0;

  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: 1,
    )..addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isVertical => widget.type == _TabsPreviewType.vertical;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelLarge;
    final tabs = _isVertical
        ? _buildVerticalTabs(context)
        : _buildHorizontalTabs(context);

    final tabBar = switch (widget.type) {
      _TabsPreviewType.primary => TabBar(
        controller: _controller,
        onTap: _onTap,
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        labelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,
        tabs: tabs,
      ),
      _TabsPreviewType.secondary => TabBar.secondary(
        controller: _controller,
        onTap: _onTap,
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        labelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,
        tabs: tabs,
      ),
      _TabsPreviewType.scrollable => TabBar(
        controller: _controller,
        isScrollable: true,
        onTap: _onTap,
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        labelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,
        tabs: tabs,
      ),
      _TabsPreviewType.vertical => TabBar(
        controller: _controller,
        onTap: _onTap,
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,
        tabs: tabs,
      ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        tabBar,
        const SizedBox(height: 12),
        Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${widget.type.name} content',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _onTap(int index) {
    if (index == _disabledIndex) {
      _controller.index = _controller.previousIndex;
    }
  }

  List<Widget> _buildHorizontalTabs(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selectedIndex = _controller.index;

    return [
      for (var i = 0; i < _tabs.length; i++)
        Tab(
          child: Opacity(
            opacity: i == _disabledIndex ? 0.38 : 1,
            child: _horizontalContent(
              context: context,
              index: i,
              color: i == selectedIndex
                  ? scheme.primary
                  : scheme.onSurfaceVariant,
            ),
          ),
        ),
    ];
  }

  Widget _horizontalContent({
    required BuildContext context,
    required int index,
    required Color color,
  }) {
    final selected = index == _controller.index;
    final disabled = index == _disabledIndex;

    // Figma content_hori: LeadingIcon → Label → TrailingIcon → Badge (gap 4).
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showIcons) ...[
          Icon(_tabs[index].icon, size: 24, color: color),
          const SizedBox(width: 4),
        ],
        Text(
          _tabs[index].label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
        ),
        if (widget.showBadge) ...[
          const SizedBox(width: 4),
          _tabBadge(
            context,
            selected: selected,
            disabled: disabled,
            text: '${index + 1}',
          ),
        ],
      ],
    );
  }

  /// Figma Style=Vertical: icon 24 above label, gap 4, height 64.
  /// Badge overlays icon (top-right), not inline with the label.
  List<Widget> _buildVerticalTabs(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selectedIndex = _controller.index;

    return [
      for (var i = 0; i < _tabs.length; i++)
        Tab(
          height: _verticalTabHeight,
          child: Opacity(
            opacity: i == _disabledIndex ? 0.38 : 1,
            child: _verticalContent(
              context: context,
              index: i,
              color: i == selectedIndex
                  ? scheme.primary
                  : scheme.onSurfaceVariant,
            ),
          ),
        ),
    ];
  }

  Widget _verticalContent({
    required BuildContext context,
    required int index,
    required Color color,
  }) {
    final selected = index == _controller.index;
    final disabled = index == _disabledIndex;
    final (bg, fg) = _badgeColors(context, selected: selected, disabled: disabled);

    Widget icon = Icon(_tabs[index].icon, size: 24, color: color);
    if (widget.showBadge) {
      icon = Badge(
        backgroundColor: bg,
        textColor: fg,
        label: Text(
          '${index + 1}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg),
        ),
        child: icon,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 4),
          Text(
            _tabs[index].label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Figma Tab badge colors (node 2110:2592 / Badge 2836:834).
  (Color, Color) _badgeColors(
    BuildContext context, {
    required bool selected,
    required bool disabled,
  }) {
    final scheme = Theme.of(context).colorScheme;
    if (disabled) {
      return (scheme.onSurface, scheme.onPrimary);
    }
    if (selected) {
      return (scheme.primary, scheme.onPrimary);
    }
    return (scheme.inverseSurface, scheme.onInverseSurface);
  }

  /// Inline pill for horizontal / secondary tabs (min 16, pad 4, radius 12).
  /// Do not set [Container.alignment] — it expands to the Tab row height.
  Widget _tabBadge(
    BuildContext context, {
    required bool selected,
    required bool disabled,
    required String text,
  }) {
    final (background, foreground) = _badgeColors(
      context,
      selected: selected,
      disabled: disabled,
    );

    return UnconstrainedBox(
      child: Container(
        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: foreground,
            height: 16 / 11,
          ),
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.icon);

  final String label;
  final IconData icon;
}

const _tabs = <_TabSpec>[
  _TabSpec('Ticket', Icons.confirmation_number_outlined),
  _TabSpec('圖文', Icons.article_outlined),
  _TabSpec('Info', Icons.info_outline),
  _TabSpec('More', Icons.more_horiz),
];
