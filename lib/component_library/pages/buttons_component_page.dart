import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/kpi_button_styles.dart';
import '../widgets/variant_matrix_table.dart';

/// Buttons from Figma Flutter UI kit (3 sizes × modes × label/icon).
///
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2061-548
class ButtonsComponentPage extends StatefulWidget {
  const ButtonsComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'buttons',
    title: 'Buttons',
    m3SpecUrl:
        'https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2061-548',
    description:
        'Standard M3 buttons (Filled / Outlined / Tonal / Text + IconButton) '
        'with a small size scale from the Flutter UI kit: XS 32, S 40, M 56. '
        'Use Flutter Material widgets; apply `KpiButtonStyles` only when you '
        'need a non-default size.',
  );

  @override
  State<ButtonsComponentPage> createState() => _ButtonsComponentPageState();
}

class _ButtonsComponentPageState extends State<ButtonsComponentPage> {
  bool _showLeadingIcon = false;
  bool _showTrailingIcon = false;

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'M3 buttons',
      m3Behavior:
          'Filled, Outlined, Tonal, Text, IconButton — ColorScheme, states, '
          'icons, and shapes are Material 3.',
      ourImplementation:
          'Same Flutter Material widgets. Theme default height is S 40. '
          'This page is a size reference, not a custom button component.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Size tokens (only delta)',
      m3Behavior: 'Stock Flutter buttons are typically ~40 tall / Label Large.',
      ourImplementation:
          'Kit sizes via `KpiButtonStyles`: XS 32 (pad 12), S 40 (pad 16), '
          'M 56 (pad 24, `titleLarge`). Use `VisualDensity.standard` so '
          'heights stay exact (compact shrinks by 8px).',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[];

  static const _modes = <_ModeSpec>[
    _ModeSpec(KpiButtonMode.filled, 'Filled'),
    _ModeSpec(KpiButtonMode.outlined, 'Outlined'),
    _ModeSpec(KpiButtonMode.tonal, 'Tonal'),
    _ModeSpec(KpiButtonMode.text, 'Text'),
  ];

  static const _sizes = [
    KpiButtonSize.xs32,
    KpiButtonSize.s40,
    KpiButtonSize.m56,
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: ButtonsComponentPage.meta.title,
      m3SpecUrl: ButtonsComponentPage.meta.m3SpecUrl,
      description: ButtonsComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Label button', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Stadium · XS/S Label Large · M Title Large · Enabled over Disabled',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          VariantIconControls(
            showLeadingIcon: _showLeadingIcon,
            showTrailingIcon: _showTrailingIcon,
            onLeadingChanged: (value) =>
                setState(() => _showLeadingIcon = value),
            onTrailingChanged: (value) =>
                setState(() => _showTrailingIcon = value),
          ),
          const SizedBox(height: 12),
          for (final mode in _modes) ...[
            _ModeRow(
              title: mode.label,
              children: [
                for (final size in _sizes)
                  _SizeColumn(
                    sizeLabel: '${size.label} · ${size.typographyToken}',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LabelButtonPreview(
                          mode: mode.mode,
                          size: size,
                          enabled: true,
                          showLeadingIcon: _showLeadingIcon,
                          showTrailingIcon: _showTrailingIcon,
                        ),
                        const SizedBox(height: 8),
                        _LabelButtonPreview(
                          mode: mode.mode,
                          size: size,
                          enabled: false,
                          showLeadingIcon: _showLeadingIcon,
                          showTrailingIcon: _showTrailingIcon,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          Text('Icon button', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Circle · glyph 20 / 20 / 24 · Enabled over Disabled',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          for (final mode in _modes) ...[
            _ModeRow(
              title: mode.label,
              children: [
                for (final size in _sizes)
                  _SizeColumn(
                    sizeLabel: size.label,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _IconButtonPreview(
                          mode: mode.mode,
                          size: size,
                          enabled: true,
                        ),
                        const SizedBox(height: 8),
                        _IconButtonPreview(
                          mode: mode.mode,
                          size: size,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ModeSpec {
  const _ModeSpec(this.mode, this.label);
  final KpiButtonMode mode;
  final String label;
}

class _ModeRow extends StatelessWidget {
  const _ModeRow({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(child: children[i]),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SizeColumn extends StatelessWidget {
  const _SizeColumn({required this.sizeLabel, required this.child});

  final String sizeLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sizeLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _LabelButtonPreview extends StatelessWidget {
  const _LabelButtonPreview({
    required this.mode,
    required this.size,
    required this.enabled,
    required this.showLeadingIcon,
    required this.showTrailingIcon,
  });

  final KpiButtonMode mode;
  final KpiButtonSize size;
  final bool enabled;
  final bool showLeadingIcon;
  final bool showTrailingIcon;

  Widget _child() {
    final gap = size.iconLabelGap;
    final leading = showLeadingIcon
        ? Icon(Icons.close, size: size.leadingIconSize)
        : null;
    final trailing = showTrailingIcon
        ? Icon(Icons.arrow_drop_down, size: size.trailingIconSize)
        : null;

    if (leading == null && trailing == null) {
      return const Text('Button');
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          leading,
          SizedBox(width: gap),
        ],
        const Text('Button'),
        if (trailing != null) ...[
          SizedBox(width: gap),
          trailing,
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final onPressed = enabled ? () {} : null;
    final style = KpiButtonStyles.labelStyle(context, size);
    final child = _child();

    return switch (mode) {
      KpiButtonMode.filled => FilledButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      KpiButtonMode.outlined => OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      KpiButtonMode.tonal => FilledButton.tonal(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      KpiButtonMode.text => TextButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    };
  }
}

class _IconButtonPreview extends StatelessWidget {
  const _IconButtonPreview({
    required this.mode,
    required this.size,
    required this.enabled,
  });

  final KpiButtonMode mode;
  final KpiButtonSize size;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final onPressed = enabled ? () {} : null;
    final style = KpiButtonStyles.iconStyle(size);
    const icon = Icon(Icons.close);

    return switch (mode) {
      KpiButtonMode.filled => IconButton.filled(
        onPressed: onPressed,
        style: style,
        icon: icon,
      ),
      KpiButtonMode.outlined => IconButton.outlined(
        onPressed: onPressed,
        style: style,
        icon: icon,
      ),
      KpiButtonMode.tonal => IconButton.filledTonal(
        onPressed: onPressed,
        style: style,
        icon: icon,
      ),
      KpiButtonMode.text => IconButton(
        onPressed: onPressed,
        style: style,
        icon: icon,
      ),
    };
  }
}
