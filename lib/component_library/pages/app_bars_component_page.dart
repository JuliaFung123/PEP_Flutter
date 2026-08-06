import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Top app bar — https://m3.material.io/components/app-bars/specs
class AppBarsComponentPage extends StatefulWidget {
  const AppBarsComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'app_bars',
    title: 'App bars',
    m3SpecUrl: 'https://m3.material.io/components/app-bars/specs',
    description:
        'Top app bars display navigation, actions, and titles. '
        'Pick app bar variants from Part 2 — do not invent new ones.',
  );

  @override
  State<AppBarsComponentPage> createState() => _AppBarsComponentPageState();
}

class _AppBarsComponentPageState extends State<AppBarsComponentPage> {
  bool _showNavIcon = true;
  bool _showActions = true;

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Small',
      m3Behavior: 'Default top app bar; title aligned to leading edge.',
      ourImplementation: 'AppBar with default configuration.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Center-aligned',
      m3Behavior: 'Title centered in the app bar.',
      ourImplementation: 'AppBar with centerTitle: true.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Medium flexible',
      m3Behavior: 'Taller bar; title in flexible space when expanded.',
      ourImplementation: 'SliverAppBar with expandedHeight: 112.',
      action: 'Modify or create variant',
    ),
    ComponentNote(
      variant: 'Large flexible',
      m3Behavior: 'Largest flexible bar for prominent screens.',
      ourImplementation: 'SliverAppBar with expandedHeight: 152.',
      action: 'Modify or create variant',
    ),
    ComponentNote(
      variant: 'On scroll',
      m3Behavior: 'Elevation and surface tint when content scrolls under bar.',
      ourImplementation: 'scrolledUnderElevation on AppBar / pinned SliverAppBar.',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Bottom app bar',
      foundIn: 'M3 app bars spec',
      description: 'Separate M3 component — navigation at bottom.',
      suggestedAction: 'Create new page when needed',
    ),
    PendingVariant(
      name: 'Search app bar',
      foundIn: 'M3 search patterns',
      description: 'App bar with integrated search field.',
      suggestedAction: 'Promote to Part 2 or layout pattern',
    ),
  ];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(id: 'small', label: 'Small'),
    VariantMatrixRow(id: 'center_aligned', label: 'Center-aligned'),
    VariantMatrixRow(
      id: 'medium_flexible',
      label: 'Medium flexible',
      supportsTrailingIcon: true,
    ),
    VariantMatrixRow(
      id: 'large_flexible',
      label: 'Large flexible',
      supportsTrailingIcon: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: AppBarsComponentPage.meta.title,
      m3SpecUrl: AppBarsComponentPage.meta.m3SpecUrl,
      description: AppBarsComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VariantIconControls(
            showLeadingIcon: _showNavIcon,
            showTrailingIcon: _showActions,
            leadingLabel: 'Navigation icon',
            trailingLabel: 'Action icons',
            onLeadingChanged: (v) => setState(() => _showNavIcon = v),
            onTrailingChanged: (v) => setState(() => _showActions = v),
          ),
          const SizedBox(height: 12),
          _AppBarVariantTable(
            rows: _rows,
            showNavIcon: _showNavIcon,
            showActions: _showActions,
          ),
        ],
      ),
    );
  }
}

/// App bars use Default / Scrolled columns instead of Enabled / Disabled.
class _AppBarVariantTable extends StatelessWidget {
  const _AppBarVariantTable({
    required this.rows,
    required this.showNavIcon,
    required this.showActions,
  });

  final List<VariantMatrixRow> rows;
  final bool showNavIcon;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    final labelStyle = Theme.of(context).textTheme.labelLarge;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return SizedBox(
      width: double.infinity,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.4),
          1: FlexColumnWidth(1.6),
          2: FlexColumnWidth(1.6),
        },
        border: TableBorder.all(color: borderColor),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
            TableRow(
              children: [
                _cell(
                  child: Text('Variant', style: labelStyle),
                  alignment: Alignment.centerLeft,
                ),
                _cell(
                  child: Text('Default', style: labelStyle, textAlign: TextAlign.center),
                ),
                _cell(
                  child: Text('Scrolled', style: labelStyle, textAlign: TextAlign.center),
                ),
              ],
            ),
            for (final row in rows)
              TableRow(
                children: [
                  _cell(
                    child: Text(row.label, style: bodyStyle),
                    alignment: Alignment.centerLeft,
                  ),
                  _cell(
                    child: _AppBarPreview(
                      variantId: row.id,
                      scrolled: false,
                      showNavIcon: showNavIcon && row.supportsLeadingIcon,
                      showActions: showActions && row.supportsTrailingIcon,
                    ),
                  ),
                  _cell(
                    child: _AppBarPreview(
                      variantId: row.id,
                      scrolled: true,
                      showNavIcon: showNavIcon && row.supportsLeadingIcon,
                      showActions: showActions && row.supportsTrailingIcon,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _cell({
    required Widget child,
    Alignment alignment = Alignment.center,
  }) {
    return TableCell(
      child: Container(
        width: double.infinity,
        alignment: alignment,
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}

class _AppBarPreview extends StatelessWidget {
  const _AppBarPreview({
    required this.variantId,
    required this.scrolled,
    required this.showNavIcon,
    required this.showActions,
  });

  final String variantId;
  final bool scrolled;
  final bool showNavIcon;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: _previewHeight,
        child: switch (variantId) {
          'small' || 'center_aligned' => _SmallAppBarPreview(
            centerTitle: variantId == 'center_aligned',
            scrolled: scrolled,
            showNavIcon: showNavIcon,
            showActions: showActions,
          ),
          'medium_flexible' || 'large_flexible' => _FlexibleAppBarPreview(
            expandedHeight: variantId == 'large_flexible' ? 152 : 112,
            scrolled: scrolled,
            showNavIcon: showNavIcon,
            showActions: showActions,
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  double get _previewHeight => switch (variantId) {
    'medium_flexible' => 112,
    'large_flexible' => 152,
    _ => 64,
  };
}

class _SmallAppBarPreview extends StatelessWidget {
  const _SmallAppBarPreview({
    required this.centerTitle,
    required this.scrolled,
    required this.showNavIcon,
    required this.showActions,
  });

  final bool centerTitle;
  final bool scrolled;
  final bool showNavIcon;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: scrolled ? 3 : 0,
      scrolledUnderElevation: 3,
      centerTitle: centerTitle,
      automaticallyImplyLeading: showNavIcon,
      leading: showNavIcon ? null : const SizedBox.shrink(),
      title: Text('Title', style: Theme.of(context).textTheme.titleLarge),
      actions: showActions ? _actionIcons : null,
    );
  }
}

class _FlexibleAppBarPreview extends StatefulWidget {
  const _FlexibleAppBarPreview({
    required this.expandedHeight,
    required this.scrolled,
    required this.showNavIcon,
    required this.showActions,
  });

  final double expandedHeight;
  final bool scrolled;
  final bool showNavIcon;
  final bool showActions;

  @override
  State<_FlexibleAppBarPreview> createState() => _FlexibleAppBarPreviewState();
}

class _FlexibleAppBarPreviewState extends State<_FlexibleAppBarPreview> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: _collapseOffset,
    );
  }

  @override
  void didUpdateWidget(_FlexibleAppBarPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrolled != widget.scrolled ||
        oldWidget.expandedHeight != widget.expandedHeight) {
      _controller.jumpTo(_collapseOffset);
    }
  }

  double get _collapseOffset =>
      widget.scrolled ? widget.expandedHeight - kToolbarHeight : 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: widget.expandedHeight,
          scrolledUnderElevation: 3,
          forceElevated: widget.scrolled,
          automaticallyImplyLeading: widget.showNavIcon,
          leading: widget.showNavIcon ? null : const SizedBox.shrink(),
          actions: widget.showActions ? _actionIcons : null,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Title',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
            centerTitle: false,
            expandedTitleScale: 1,
          ),
        ),
      ],
    );
  }
}

const _actionIcons = [
  IconButton(onPressed: _noop, icon: Icon(Icons.search)),
  IconButton(onPressed: _noop, icon: Icon(Icons.more_vert)),
];

void _noop() {}
