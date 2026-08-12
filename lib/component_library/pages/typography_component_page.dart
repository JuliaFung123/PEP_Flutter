import 'package:flutter/material.dart';

import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_typography.dart';
import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';

/// M3 Typography — https://m3.material.io/styles/typography/overview
///
/// Specs follow Figma Flutter kit:
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2292-268
class TypographyComponentPage extends StatelessWidget {
  const TypographyComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'typography',
    title: 'Typography',
    sortOrder: 2,
    group: ComponentLibraryGroup.theme,
    m3SpecUrl: 'https://m3.material.io/styles/typography/overview',
    description:
        'Figma Flutter kit type scale on Noto Sans TC (CJK + Latin). '
        'Spec rows mark Flutter M3 defaults → kit values in red when they differ.',
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'textTheme / AppTypography',
      spec:
          'englishLike.merge(black|white) → AppFonts (Noto Sans TC). '
          'titleLarge w500; bodySmall tracking 0. Custom titleSemiLarge '
          '18/26 w500 via AppTypography extension.',
      setupCode: '''
final geometry = typography.englishLike;
final colors = brightness == Brightness.light
    ? typography.black
    : typography.white;
final textTheme = AppFonts.textTheme(geometry.merge(colors)).copyWith(
  titleLarge: AppFonts.style(
    textStyle: /* titleLarge */,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  ),
  bodySmall: AppFonts.style(
    textStyle: /* bodySmall */,
    letterSpacing: 0,
  ),
);
extensions: [AppTypography.fromTextTheme(textTheme)],

// Usage
AppTypography.of(context).titleSemiLarge
Theme.of(context).textTheme.titleMedium
''',
    ),
  ];

  static const _pending = <PendingVariant>[];

  static const _styles = <_TypographyStyleRow>[
    _TypographyStyleRow('display_large', 'Display large', _StyleSlot.displayLarge),
    _TypographyStyleRow('display_medium', 'Display medium', _StyleSlot.displayMedium),
    _TypographyStyleRow('display_small', 'Display small', _StyleSlot.displaySmall),
    _TypographyStyleRow('headline_large', 'Headline large', _StyleSlot.headlineLarge),
    _TypographyStyleRow('headline_medium', 'Headline medium', _StyleSlot.headlineMedium),
    _TypographyStyleRow('headline_small', 'Headline small', _StyleSlot.headlineSmall),
    _TypographyStyleRow('title_large', 'Title large', _StyleSlot.titleLarge),
    _TypographyStyleRow(
      'title_semi_large',
      'Title semi large',
      _StyleSlot.titleSemiLarge,
    ),
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
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _WeightProofStrip(),
          const SizedBox(height: 16),
          _TypographyVariantList(styles: _styles),
        ],
      ),
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
  titleSemiLarge,
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

/// Flutter M3 englishLike2021 geometry (family excluded — app keeps Inter).
class _FlutterDefaultSpec {
  const _FlutterDefaultSpec({
    required this.size,
    required this.lineHeight,
    required this.weight,
    required this.tracking,
  });

  final double size;
  final double lineHeight;
  final int weight;
  final double tracking;
}

const _flutterDefaults = <_StyleSlot, _FlutterDefaultSpec>{
  _StyleSlot.displayLarge: _FlutterDefaultSpec(
    size: 57,
    lineHeight: 64,
    weight: 400,
    tracking: -0.25,
  ),
  _StyleSlot.displayMedium: _FlutterDefaultSpec(
    size: 45,
    lineHeight: 52,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.displaySmall: _FlutterDefaultSpec(
    size: 36,
    lineHeight: 44,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.headlineLarge: _FlutterDefaultSpec(
    size: 32,
    lineHeight: 40,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.headlineMedium: _FlutterDefaultSpec(
    size: 28,
    lineHeight: 36,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.headlineSmall: _FlutterDefaultSpec(
    size: 24,
    lineHeight: 32,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.titleLarge: _FlutterDefaultSpec(
    size: 22,
    lineHeight: 28,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.titleMedium: _FlutterDefaultSpec(
    size: 16,
    lineHeight: 24,
    weight: 500,
    tracking: 0.15,
  ),
  _StyleSlot.titleSmall: _FlutterDefaultSpec(
    size: 14,
    lineHeight: 20,
    weight: 500,
    tracking: 0.1,
  ),
  _StyleSlot.bodyLarge: _FlutterDefaultSpec(
    size: 16,
    lineHeight: 24,
    weight: 400,
    tracking: 0.5,
  ),
  _StyleSlot.bodyMedium: _FlutterDefaultSpec(
    size: 14,
    lineHeight: 20,
    weight: 400,
    tracking: 0.25,
  ),
  _StyleSlot.bodySmall: _FlutterDefaultSpec(
    size: 12,
    lineHeight: 16,
    weight: 400,
    tracking: 0.4,
  ),
  _StyleSlot.labelLarge: _FlutterDefaultSpec(
    size: 14,
    lineHeight: 20,
    weight: 500,
    tracking: 0.1,
  ),
  _StyleSlot.labelMedium: _FlutterDefaultSpec(
    size: 12,
    lineHeight: 16,
    weight: 500,
    tracking: 0.5,
  ),
  _StyleSlot.labelSmall: _FlutterDefaultSpec(
    size: 11,
    lineHeight: 16,
    weight: 500,
    tracking: 0.5,
  ),
};

/// Figma Flutter kit targets (family excluded).
const _figmaSpecs = <_StyleSlot, _FlutterDefaultSpec>{
  _StyleSlot.displayLarge: _FlutterDefaultSpec(
    size: 57,
    lineHeight: 64,
    weight: 400,
    tracking: -0.25,
  ),
  _StyleSlot.displayMedium: _FlutterDefaultSpec(
    size: 45,
    lineHeight: 52,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.displaySmall: _FlutterDefaultSpec(
    size: 36,
    lineHeight: 44,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.headlineLarge: _FlutterDefaultSpec(
    size: 32,
    lineHeight: 40,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.headlineMedium: _FlutterDefaultSpec(
    size: 28,
    lineHeight: 36,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.headlineSmall: _FlutterDefaultSpec(
    size: 24,
    lineHeight: 32,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.titleLarge: _FlutterDefaultSpec(
    size: 22,
    lineHeight: 28,
    weight: 500,
    tracking: 0,
  ),
  _StyleSlot.titleSemiLarge: _FlutterDefaultSpec(
    size: 18,
    lineHeight: 26,
    weight: 500,
    tracking: 0,
  ),
  _StyleSlot.titleMedium: _FlutterDefaultSpec(
    size: 16,
    lineHeight: 24,
    weight: 500,
    tracking: 0.15,
  ),
  _StyleSlot.titleSmall: _FlutterDefaultSpec(
    size: 14,
    lineHeight: 20,
    weight: 500,
    tracking: 0.1,
  ),
  _StyleSlot.bodyLarge: _FlutterDefaultSpec(
    size: 16,
    lineHeight: 24,
    weight: 400,
    tracking: 0.5,
  ),
  _StyleSlot.bodyMedium: _FlutterDefaultSpec(
    size: 14,
    lineHeight: 20,
    weight: 400,
    tracking: 0.25,
  ),
  _StyleSlot.bodySmall: _FlutterDefaultSpec(
    size: 12,
    lineHeight: 16,
    weight: 400,
    tracking: 0,
  ),
  _StyleSlot.labelLarge: _FlutterDefaultSpec(
    size: 14,
    lineHeight: 20,
    weight: 500,
    tracking: 0.1,
  ),
  _StyleSlot.labelMedium: _FlutterDefaultSpec(
    size: 12,
    lineHeight: 16,
    weight: 500,
    tracking: 0.5,
  ),
  _StyleSlot.labelSmall: _FlutterDefaultSpec(
    size: 11,
    lineHeight: 16,
    weight: 500,
    tracking: 0.5,
  ),
};

class _WeightProofStrip extends StatelessWidget {
  const _WeightProofStrip();

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    Widget row(String label, FontWeight weight) {
      return Text(
        '$label  繁中 Aa',
        style: TextStyle(
          fontFamily: AppFonts.familyFor(weight),
          fontWeight: weight,
          fontSize: 22,
          height: 28 / 22,
          color: onSurface,
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight check (w400 vs w500 should differ)',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: muted,
                  ),
            ),
            const SizedBox(height: 8),
            row('Regular w400', FontWeight.w400),
            row('Medium  w500', FontWeight.w500),
            row('Bold    w700', FontWeight.w700),
          ],
        ),
      ),
    );
  }
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
    final baseStyle = _resolveStyle(context, slot);
    if (baseStyle == null) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;
    final style = baseStyle.copyWith(color: colors.onSurface);
    final tokenPrefix = slot == _StyleSlot.titleSemiLarge
        ? 'AppTypography'
        : 'TextTheme';
    final family = _displayFontFamily(baseStyle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '繁體中文  简体中文  English',
          style: style,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        _SpecLine(
          tokenPrefix: tokenPrefix,
          tokenName: tokenName,
          family: family,
          slot: slot,
          muted: colors.onSurfaceVariant,
        ),
      ],
    );
  }

  TextStyle? _resolveStyle(BuildContext context, _StyleSlot slot) {
    final theme = Theme.of(context).textTheme;
    return switch (slot) {
      _StyleSlot.displayLarge => theme.displayLarge,
      _StyleSlot.displayMedium => theme.displayMedium,
      _StyleSlot.displaySmall => theme.displaySmall,
      _StyleSlot.headlineLarge => theme.headlineLarge,
      _StyleSlot.headlineMedium => theme.headlineMedium,
      _StyleSlot.headlineSmall => theme.headlineSmall,
      _StyleSlot.titleLarge => theme.titleLarge,
      _StyleSlot.titleSemiLarge => AppTypography.of(context).titleSemiLarge,
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

String _displayFontFamily(TextStyle style) {
  return AppFonts.displayName;
}

class _SpecLine extends StatelessWidget {
  const _SpecLine({
    required this.tokenPrefix,
    required this.tokenName,
    required this.family,
    required this.slot,
    required this.muted,
  });

  final String tokenPrefix;
  final String tokenName;
  final String family;
  final _StyleSlot slot;
  final Color muted;

  static const _diff = Color(0xFFFF0000);

  @override
  Widget build(BuildContext context) {
    final figma = _figmaSpecs[slot]!;
    final flutter = _flutterDefaults[slot];
    final base = Theme.of(context).textTheme.labelSmall;
    final mutedStyle = base?.copyWith(color: muted);
    final redStyle = base?.copyWith(color: _diff);

    String sizeLabel(_FlutterDefaultSpec s) =>
        '${s.size.toStringAsFixed(0)}px / ${s.lineHeight.toStringAsFixed(0)}px';

    String trackValue(double t) {
      if (t == t.roundToDouble()) return t.toStringAsFixed(0);
      return t.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    }

    String trackPretty(double t) => 'tracking ${trackValue(t)}';

    TextSpan span(String text, {required bool diff}) {
      return TextSpan(text: text, style: diff ? redStyle : mutedStyle);
    }

    TextSpan sep() => TextSpan(text: ' · ', style: mutedStyle);

    final spans = <InlineSpan>[
      span('$tokenPrefix.$tokenName', diff: flutter == null),
      sep(),
      span(family, diff: false),
      sep(),
    ];

    if (flutter == null) {
      spans.addAll([
        span('—→${sizeLabel(figma)}', diff: true),
        sep(),
        span('—→w${figma.weight}', diff: true),
        sep(),
        span('—→${trackPretty(figma.tracking)}', diff: true),
      ]);
    } else {
      final sizeDiff =
          flutter.size != figma.size || flutter.lineHeight != figma.lineHeight;
      final weightDiff = flutter.weight != figma.weight;
      final trackDiff = flutter.tracking != figma.tracking;

      spans.add(
        span(
          sizeDiff
              ? '${sizeLabel(flutter)}→${sizeLabel(figma)}'
              : sizeLabel(figma),
          diff: sizeDiff,
        ),
      );
      spans.add(sep());
      spans.add(
        span(
          weightDiff ? 'w${flutter.weight}→w${figma.weight}' : 'w${figma.weight}',
          diff: weightDiff,
        ),
      );
      spans.add(sep());
      spans.add(
        span(
          trackDiff
              ? 'tracking ${trackValue(flutter.tracking)}→${trackValue(figma.tracking)}'
              : trackPretty(figma.tracking),
          diff: trackDiff,
        ),
      );
    }

    return Text.rich(TextSpan(children: spans));
  }
}
