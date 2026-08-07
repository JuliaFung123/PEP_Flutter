import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 small / search top app bar height.
/// https://m3.material.io/components/app-bars/specs
const double kM3ToolbarHeight = 64;

/// Figma / M3 redline paddings (Flutter kit AppBar).
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2073-130
const double kM3AppBarEdgePadding = 4;
const double kM3AppBarIconButtonSize = 48;
const double kM3AppBarTitleGap = 4;
const double kM3AppBarTitleInset = 16;
const double kM3AppBarFlexibleTitleBottom = 12;
const double kM3AppBarIconToolbarHeight = 56;
const double kM3AppBarIconToolbarTopInset = 8;
const double kM3SearchAppBarGap = 8;
const double kM3MediumFlexibleHeight = 112;
const double kM3LargeFlexibleHeight = 120;

/// Leading slot = edge padding + 48 icon button.
double get kM3AppBarLeadingWidth =>
    kM3AppBarEdgePadding + kM3AppBarIconButtonSize;

/// M3 Top app bar — https://m3.material.io/components/app-bars/specs
///
/// Figma typography + padding:
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2073-130
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
  bool _showSubtitle = false;

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Padding / gap',
      m3Behavior:
          'Small: 4dp edge, 48 icon buttons, ~4dp title gap. '
          'Flexible: 4dp icon edge, 8dp top icon inset, 16dp title inset, '
          '12dp title bottom. Search: 4 / 8 / 8 / 4.',
      ourImplementation:
          'Overrides Flutter defaults (leadingWidth 56, titleSpacing 16). '
          'Uses leadingWidth 52 (4+48), titleSpacing 4 (or 16 without leading), '
          'actionsPadding end 4. Flexible titlePadding start 16 / bottom 12; '
          'Large height 120 (not baseline 152).',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Small / Center-aligned title',
      m3Behavior: 'Compact 64dp bar; title vertically centered.',
      ourImplementation:
          'Title = `AppTypography.titleSemiLarge` (18/26 · w500). '
          'Subtitle = `TextTheme.titleSmall`. AppBarTheme matches this.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Medium flexible title',
      m3Behavior: 'Expanded title in flexible space · 112dp.',
      ourImplementation:
          'Title = `TextTheme.headlineMedium` (28/36 · w400). '
          'Subtitle = `TextTheme.titleSmall` · gap 4.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Large flexible title',
      m3Behavior: 'Largest expanded title · 120dp (flexible, not baseline 152).',
      ourImplementation:
          'Title = `TextTheme.displaySmall` (36/44 · w400). '
          'Subtitle = `TextTheme.titleMedium` · gap 8.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Search',
      m3Behavior: '64dp bar with search field · 4/8/8/4 gaps.',
      ourImplementation:
          '`SearchAnchor.bar` hint/text = `TextTheme.bodyLarge`; '
          'titleSpacing 8 with leading.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Collapsing medium → small',
      m3Behavior:
          'Default M3 Medium (and Large) top app bar: expanded title under '
          'the icon row; on scroll collapses to Small (64) with the title in '
          'the toolbar. Requires scroll wiring — not automatic alone.',
      ourImplementation:
          '`SliverAppBar` pinned · expanded ≈ Medium 112 · toolbar 64. '
          'Expanded title = `headlineMedium` (wrap OK); collapsed = '
          '`titleSemiLarge` single line. Live demo below (scroll inside). '
          'Used on Ticket details.',
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
      name: 'Immersive collapsing AppBar + image header',
      foundIn: '活動 (Activity) page',
      description:
          'Pinned SliverAppBar over ImageHeader: no title at rest (back only); '
          'when the page headline scrolls under the bar, that text becomes the '
          'AppBar title and the bar becomes opaque.',
      suggestedAction:
          'Review whether this is an App bars layout pattern, an Image header '
          'composition, or both — then promote a documented recipe',
    ),
  ];

  static const _variants = <_AppBarVariant>[
    _AppBarVariant(id: 'small', label: 'Small'),
    _AppBarVariant(id: 'center_aligned', label: 'Center-aligned'),
    _AppBarVariant(
      id: 'medium_flexible',
      label: 'Medium flexible',
      supportsActions: true,
    ),
    _AppBarVariant(
      id: 'large_flexible',
      label: 'Large flexible',
      supportsActions: true,
    ),
    _AppBarVariant(id: 'search', label: 'Search', supportsActions: true),
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
            showHelperText: _showSubtitle,
            helperTextLabel: 'Subtitle',
            onHelperTextChanged: (v) => setState(() => _showSubtitle = v),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _variants.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _AppBarPreview(
              variant: _variants[i],
              showNavIcon: _showNavIcon,
              showActions: _showActions && _variants[i].supportsActions,
              showSubtitle: _showSubtitle,
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Collapsing medium → small',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'M3 default Medium collapse. Scroll inside the frame — hard to '
            'show as a static matrix cell.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _CollapsingMediumDemo(
            showNavIcon: _showNavIcon,
            showActions: _showActions,
          ),
        ],
      ),
    );
  }
}

class _AppBarVariant {
  const _AppBarVariant({
    required this.id,
    required this.label,
    this.supportsActions = true,
  });

  final String id;
  final String label;
  final bool supportsActions;
}

class _AppBarPreview extends StatelessWidget {
  const _AppBarPreview({
    required this.variant,
    required this.showNavIcon,
    required this.showActions,
    required this.showSubtitle,
  });

  final _AppBarVariant variant;
  final bool showNavIcon;
  final bool showActions;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    final height = _previewHeight;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: switch (variant.id) {
          'small' || 'center_aligned' => _SmallAppBarPreview(
            title: variant.label,
            centerTitle: variant.id == 'center_aligned',
            showNavIcon: showNavIcon,
            showActions: showActions,
            showSubtitle: showSubtitle,
            toolbarHeight: height,
          ),
          'medium_flexible' || 'large_flexible' => _FlexibleAppBarPreview(
            title: variant.label,
            expandedHeight: height,
            showNavIcon: showNavIcon,
            showActions: showActions,
            showSubtitle: showSubtitle,
            isLarge: variant.id == 'large_flexible',
          ),
          'search' => _SearchAppBarPreview(
            title: 'Body Large',
            showNavIcon: showNavIcon,
            showActions: showActions,
            toolbarHeight: height,
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  double get _previewHeight => switch (variant.id) {
    'medium_flexible' => kM3MediumFlexibleHeight,
    'large_flexible' => kM3LargeFlexibleHeight,
    _ => kM3ToolbarHeight,
  };
}

Widget _m3AppBarIconButton({
  required IconData icon,
  required VoidCallback onPressed,
}) {
  // SizedBox locks the hit target — AppBar leading/actions otherwise stretch
  // to the full toolbar (or flexible) height.
  return SizedBox(
    width: kM3AppBarIconButtonSize,
    height: kM3AppBarIconButtonSize,
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
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
    ),
  );
}

Widget? _m3Leading({
  required bool show,
  required IconData icon,
}) {
  if (!show) return null;
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: kM3AppBarEdgePadding),
    child: Center(
      child: _m3AppBarIconButton(icon: icon, onPressed: _noop),
    ),
  );
}

List<Widget>? _m3Actions({required bool show}) {
  if (!show) return null;
  return [
    Center(child: _m3AppBarIconButton(icon: Icons.search, onPressed: _noop)),
    Center(
      child: _m3AppBarIconButton(icon: Icons.calendar_today, onPressed: _noop),
    ),
  ];
}

class _SmallAppBarPreview extends StatelessWidget {
  const _SmallAppBarPreview({
    required this.title,
    required this.centerTitle,
    required this.showNavIcon,
    required this.showActions,
    required this.showSubtitle,
    required this.toolbarHeight,
  });

  final String title;
  final bool centerTitle;
  final bool showNavIcon;
  final bool showActions;
  final bool showSubtitle;
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    final typography = AppTypography.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      // Isolated preview — do not inset for status bar (would un-center content).
      primary: false,
      elevation: 0,
      scrolledUnderElevation: 3,
      toolbarHeight: toolbarHeight,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leadingWidth: showNavIcon ? kM3AppBarLeadingWidth : 0,
      // M3 Small: 4dp gap after leading; 16dp inset when no leading.
      titleSpacing: showNavIcon ? kM3AppBarTitleGap : kM3AppBarTitleInset,
      actionsPadding: const EdgeInsetsDirectional.only(end: kM3AppBarEdgePadding),
      leading: _m3Leading(show: showNavIcon, icon: Icons.arrow_back),
      title: _AppBarTitleBlock(
        title: title,
        centerTitle: centerTitle,
        showSubtitle: showSubtitle,
        titleStyle: typography.titleSemiLarge,
        subtitleStyle: textTheme.titleSmall,
        titleSubtitleGap: 0,
      ),
      actions: _m3Actions(show: showActions),
    );
  }
}

class _SearchAppBarPreview extends StatelessWidget {
  const _SearchAppBarPreview({
    required this.title,
    required this.showNavIcon,
    required this.showActions,
    required this.toolbarHeight,
  });

  final String title;
  final bool showNavIcon;
  final bool showActions;
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final onVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return AppBar(
      primary: false,
      elevation: 0,
      scrolledUnderElevation: 3,
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: false,
      leadingWidth: showNavIcon ? kM3AppBarLeadingWidth : 0,
      // Search redline 4/8/8/4 — 8 between leading↔field and field↔actions.
      titleSpacing: showNavIcon ? kM3SearchAppBarGap : kM3AppBarTitleInset,
      actionsPadding: const EdgeInsetsDirectional.only(end: kM3AppBarEdgePadding),
      leading: _m3Leading(show: showNavIcon, icon: Icons.menu),
      title: SearchAnchor.bar(
        barHintText: title,
        barHintStyle: WidgetStatePropertyAll(
          bodyLarge?.copyWith(color: onVariant),
        ),
        barTextStyle: WidgetStatePropertyAll(bodyLarge),
        suggestionsBuilder: (context, controller) {
          if (controller.text.isEmpty) {
            return const <Widget>[
              ListTile(title: Text('Recent searches appear here')),
            ];
          }
          return [
            for (final tip in ['Ticket', '圖文', 'Activity'])
              if (tip.toLowerCase().contains(controller.text.toLowerCase()))
                ListTile(
                  title: Text(tip),
                  onTap: () => controller.closeView(tip),
                ),
          ];
        },
      ),
      actions: showActions
          ? [
              Center(
                child: _m3AppBarIconButton(
                  icon: Icons.more_vert,
                  onPressed: _noop,
                ),
              ),
            ]
          : null,
    );
  }
}

class _FlexibleAppBarPreview extends StatelessWidget {
  const _FlexibleAppBarPreview({
    required this.title,
    required this.expandedHeight,
    required this.showNavIcon,
    required this.showActions,
    required this.showSubtitle,
    required this.isLarge,
  });

  final String title;
  final double expandedHeight;
  final bool showNavIcon;
  final bool showActions;
  final bool showSubtitle;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Figma Medium = HeadlineMedium; Large = DisplaySmall.
    // Figma Medium subtitle = TitleSmall; Large subtitle = TitleMedium.
    final titleStyle = isLarge ? textTheme.displaySmall : textTheme.headlineMedium;
    final subtitleStyle = isLarge ? textTheme.titleMedium : textTheme.titleSmall;
    // Medium title↔subtitle gap 4; Large gap 8.
    final titleSubtitleGap = isLarge ? 8.0 : 4.0;

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // Icon row = 56 (8 top inset + 48 buttons); total 112 / 120.
        SliverAppBar(
          primary: false,
          pinned: true,
          toolbarHeight: kM3AppBarIconToolbarHeight,
          expandedHeight: expandedHeight,
          scrolledUnderElevation: 3,
          automaticallyImplyLeading: false,
          leadingWidth: showNavIcon ? kM3AppBarLeadingWidth : 0,
          titleSpacing: 0,
          actionsPadding: const EdgeInsetsDirectional.only(
            end: kM3AppBarEdgePadding,
          ),
          leading: showNavIcon
              ? Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: kM3AppBarEdgePadding,
                    top: kM3AppBarIconToolbarTopInset,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _m3AppBarIconButton(
                      icon: Icons.arrow_back,
                      onPressed: _noop,
                    ),
                  ),
                )
              : null,
          actions: showActions
              ? [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: kM3AppBarIconToolbarTopInset,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _m3AppBarIconButton(
                          icon: Icons.search,
                          onPressed: _noop,
                        ),
                        _m3AppBarIconButton(
                          icon: Icons.calendar_today,
                          onPressed: _noop,
                        ),
                      ],
                    ),
                  ),
                ]
              : null,
          flexibleSpace: FlexibleSpaceBar(
            title: _AppBarTitleBlock(
              title: title,
              centerTitle: false,
              showSubtitle: showSubtitle,
              titleStyle: titleStyle,
              subtitleStyle: subtitleStyle,
              titleSubtitleGap: titleSubtitleGap,
            ),
            titlePadding: const EdgeInsetsDirectional.only(
              start: kM3AppBarTitleInset,
              end: kM3AppBarTitleInset,
              bottom: kM3AppBarFlexibleTitleBottom,
            ),
            centerTitle: false,
            expandedTitleScale: 1,
          ),
        ),
      ],
    );
  }
}

class _AppBarTitleBlock extends StatelessWidget {
  const _AppBarTitleBlock({
    required this.title,
    required this.centerTitle,
    required this.showSubtitle,
    required this.titleSubtitleGap,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String title;
  final bool centerTitle;
  final bool showSubtitle;
  final double titleSubtitleGap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    final typography = AppTypography.of(context);
    final textTheme = Theme.of(context).textTheme;
    final resolvedTitle = titleStyle ?? typography.titleSemiLarge;
    final resolvedSubtitle = subtitleStyle ?? textTheme.titleSmall;
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: resolvedTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showSubtitle) ...[
          if (titleSubtitleGap > 0) SizedBox(height: titleSubtitleGap),
          Text(
            'Subtitle',
            style: resolvedSubtitle?.copyWith(color: colors.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

void _noop() {}

/// Scrollable mini-demo — matrix cells can't show Medium→Small collapse.
class _CollapsingMediumDemo extends StatelessWidget {
  const _CollapsingMediumDemo({
    required this.showNavIcon,
    required this.showActions,
  });

  final bool showNavIcon;
  final bool showActions;

  static const _demoTitle =
      'Ticket name — long title wraps when expanded, ellipsis when collapsed';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          height: 280,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                primary: false,
                pinned: true,
                toolbarHeight: kM3ToolbarHeight,
                expandedHeight: kM3MediumFlexibleHeight + 24,
                scrolledUnderElevation: 3,
                backgroundColor: scheme.surface,
                surfaceTintColor: scheme.surfaceTint,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                leadingWidth: showNavIcon ? kM3AppBarLeadingWidth : 0,
                actionsPadding: const EdgeInsetsDirectional.only(
                  end: kM3AppBarEdgePadding,
                ),
                leading: showNavIcon
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: kM3AppBarEdgePadding,
                        ),
                        child: Align(
                          child: _m3AppBarIconButton(
                            icon: Icons.arrow_back,
                            onPressed: _noop,
                          ),
                        ),
                      )
                    : null,
                actions: showActions
                    ? [
                        _m3AppBarIconButton(
                          icon: Icons.search,
                          onPressed: _noop,
                        ),
                      ]
                    : null,
                flexibleSpace: Builder(
                  builder: (context) {
                    final settings = context
                        .dependOnInheritedWidgetOfExactType<
                            FlexibleSpaceBarSettings>();
                    final collapsed = settings == null ||
                        settings.currentExtent <= settings.minExtent + 1;
                    final typography = AppTypography.of(context);

                    return FlexibleSpaceBar(
                      centerTitle: false,
                      expandedTitleScale: 1,
                      titlePadding: EdgeInsetsDirectional.only(
                        start: collapsed
                            ? (showNavIcon
                                ? kM3AppBarEdgePadding +
                                    kM3AppBarIconButtonSize
                                : kM3AppBarTitleInset)
                            : kM3AppBarTitleInset,
                        end: kM3AppBarTitleInset,
                        bottom: collapsed
                            ? (kM3ToolbarHeight - 26) / 2
                            : kM3AppBarFlexibleTitleBottom,
                      ),
                      title: Text(
                        _demoTitle,
                        maxLines: collapsed ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: collapsed
                            ? typography.titleSemiLarge
                            : textTheme.headlineMedium,
                      ),
                    );
                  },
                ),
              ),
              SliverList.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      'Scroll content ${index + 1}',
                      style: textTheme.bodyMedium,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
