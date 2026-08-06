import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';

/// M3 Typography — https://m3.material.io/styles/typography/overview
class TypographyComponentPage extends StatelessWidget {
  const TypographyComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'typography',
    title: 'Typography',
    sortOrder: 2,
    group: ComponentLibraryGroup.theme,
    m3SpecUrl: 'https://m3.material.io/styles/typography/overview',
    description:
        'Material 3 type scale for display, headlines, titles, body, and labels. '
        'Uses the app Inter text theme from AppTheme.',
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Display',
      m3Behavior: 'Large, prominent text for short, high-impact content.',
      ourImplementation: 'TextTheme displayLarge / displayMedium / displaySmall.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Headline',
      m3Behavior: 'High-emphasis text for short, important content.',
      ourImplementation: 'TextTheme headlineLarge / headlineMedium / headlineSmall.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Title',
      m3Behavior: 'Medium-emphasis text for titles and subtitles.',
      ourImplementation: 'TextTheme titleLarge / titleMedium / titleSmall.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Body',
      m3Behavior: 'Readable text for paragraphs and descriptions.',
      ourImplementation: 'TextTheme bodyLarge / bodyMedium / bodySmall.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Label',
      m3Behavior: 'Smaller utilitarian text for buttons, chips, captions.',
      ourImplementation: 'TextTheme labelLarge / labelMedium / labelSmall.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Font family',
      m3Behavior: 'Roboto is the default M3 typeface on Android.',
      ourImplementation:
          'Flutter default Material typography (platform font, not custom).',
      action: 'Use as-is on this page',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Brand typography',
      foundIn: 'App theme (Inter via google_fonts)',
      description: 'Global app theme overrides default with Inter.',
      suggestedAction: 'Document in layout or promote variant',
    ),
  ];

  static const _styles = <_TypographyStyleRow>[
    _TypographyStyleRow('display_large', 'Display large', _StyleSlot.displayLarge),
    _TypographyStyleRow('display_medium', 'Display medium', _StyleSlot.displayMedium),
    _TypographyStyleRow('display_small', 'Display small', _StyleSlot.displaySmall),
    _TypographyStyleRow('headline_large', 'Headline large', _StyleSlot.headlineLarge),
    _TypographyStyleRow('headline_medium', 'Headline medium', _StyleSlot.headlineMedium),
    _TypographyStyleRow('headline_small', 'Headline small', _StyleSlot.headlineSmall),
    _TypographyStyleRow('title_large', 'Title large', _StyleSlot.titleLarge),
    _TypographyStyleRow('title_medium', 'Title medium', _StyleSlot.titleMedium),
    _TypographyStyleRow('title_small', 'Title small', _StyleSlot.titleSmall),
    _TypographyStyleRow('body_large', 'Body large', _StyleSlot.bodyLarge),
    _TypographyStyleRow('body_medium', 'Body medium', _StyleSlot.bodyMedium),
    _TypographyStyleRow('body_small', 'Body small', _StyleSlot.bodySmall),
    _TypographyStyleRow('label_large', 'Label large', _StyleSlot.labelLarge),
    _TypographyStyleRow('label_medium', 'Label medium', _StyleSlot.labelMedium),
    _TypographyStyleRow('label_small', 'Label small', _StyleSlot.labelSmall),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: meta.title,
      m3SpecUrl: meta.m3SpecUrl,
      description: meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: _TypographyVariantList(styles: _styles),
    );
  }
}

enum _StyleSlot {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

class _TypographyStyleRow {
  const _TypographyStyleRow(this.id, this.label, this.slot);

  final String id;
  final String label;
  final _StyleSlot slot;
}

class _TypographyVariantList extends StatelessWidget {
  const _TypographyVariantList({required this.styles});

  final List<_TypographyStyleRow> styles;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: styles.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final style = styles[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _TypographySample(
              label: style.label,
              slot: style.slot,
              tokenName: style.id,
            ),
          );
        },
      ),
    );
  }
}

class _TypographySample extends StatelessWidget {
  const _TypographySample({
    required this.label,
    required this.slot,
    required this.tokenName,
  });

  final String label;
  final _StyleSlot slot;
  final String tokenName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final baseStyle = _resolveStyle(textTheme, slot);
    if (baseStyle == null) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;
    final style = baseStyle.copyWith(color: colors.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(
          'TextTheme.$tokenName · '
          '${baseStyle.fontSize?.toStringAsFixed(0)}sp · '
          'w${baseStyle.fontWeight?.value ?? 400} · '
          '${baseStyle.letterSpacing?.toStringAsFixed(1) ?? 0} tracking',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  TextStyle? _resolveStyle(TextTheme theme, _StyleSlot slot) {
    return switch (slot) {
      _StyleSlot.displayLarge => theme.displayLarge,
      _StyleSlot.displayMedium => theme.displayMedium,
      _StyleSlot.displaySmall => theme.displaySmall,
      _StyleSlot.headlineLarge => theme.headlineLarge,
      _StyleSlot.headlineMedium => theme.headlineMedium,
      _StyleSlot.headlineSmall => theme.headlineSmall,
      _StyleSlot.titleLarge => theme.titleLarge,
      _StyleSlot.titleMedium => theme.titleMedium,
      _StyleSlot.titleSmall => theme.titleSmall,
      _StyleSlot.bodyLarge => theme.bodyLarge,
      _StyleSlot.bodyMedium => theme.bodyMedium,
      _StyleSlot.bodySmall => theme.bodySmall,
      _StyleSlot.labelLarge => theme.labelLarge,
      _StyleSlot.labelMedium => theme.labelMedium,
      _StyleSlot.labelSmall => theme.labelSmall,
    };
  }
}
