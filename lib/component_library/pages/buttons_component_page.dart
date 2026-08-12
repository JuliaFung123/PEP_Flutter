import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/pep_button_styles.dart';
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
        'Use Flutter Material widgets; apply `PepButtonStyles` only when you '
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
      topic: 'filledButtonTheme / elevated / outlined / text / icon',
      spec:
          'Default S 40: min height 40, pad 16, labelLarge, StadiumBorder. '
          'IconButton fixed 40×40, iconSize 20. Colors from ColorScheme.',
      setupCode: '''
filledButtonTheme: FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    minimumSize: const Size(0, 40),
    maximumSize: const Size(double.infinity, 40),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    textStyle: textTheme.labelLarge,
    shape: const StadiumBorder(),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.standard,
  ),
),
// elevated / outlined / text: same S 40 geometry
// iconButtonTheme: Size(40, 40), iconSize 20
''',
    ),
    ComponentNote(
      topic: 'PepButtonStyles',
      spec:
          'XS 32 (pad 12, labelLarge), S 40 (pad 16, labelLarge), '
          'M 56 (pad 24, titleLarge). Use VisualDensity.standard.',
      setupCode: '''
FilledButton(
  style: PepButtonStyles.labelStyle(context, PepButtonSize.xs32),
  onPressed: () {},
  child: const Text('XS'),
)
IconButton(
  style: PepButtonStyles.iconStyle(PepButtonSize.m56),
  onPressed: () {},
  icon: const Icon(Icons.add),
)
''',
    ),
  ];

  static const _pending = <PendingVariant>[];

  static const _modes = <_ModeSpec>[
    _ModeSpec(PepButtonMode.filled, 'Filled'),
    _ModeSpec(PepButtonMode.outlined, 'Outlined'),
    _ModeSpec(PepButtonMode.tonal, 'Tonal'),
    _ModeSpec(PepButtonMode.text, 'Text'),
  ];

  static const _sizes = [
    PepButtonSize.xs32,
    PepButtonSize.s40,
    PepButtonSize.m56,
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
  final PepButtonMode mode;
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

  final PepButtonMode mode;
  final PepButtonSize size;
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
    final style = PepButtonStyles.labelStyle(context, size);
    final child = _child();

    return switch (mode) {
      PepButtonMode.filled => FilledButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      PepButtonMode.outlined => OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      PepButtonMode.tonal => FilledButton.tonal(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      PepButtonMode.text => TextButton(
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

  final PepButtonMode mode;
  final PepButtonSize size;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final onPressed = enabled ? () {} : null;
    final style = PepButtonStyles.iconStyle(size);
    const icon = Icon(Icons.close);

    return switch (mode) {
      PepButtonMode.filled => IconButton.filled(
        onPressed: onPressed,
        style: style,
        icon: icon,
      ),
      PepButtonMode.outlined => IconButton.outlined(
        onPressed: onPressed,
        style: style,
        icon: icon,
      ),
      PepButtonMode.tonal => IconButton.filledTonal(
        onPressed: onPressed,
        style: style,
        icon: icon,
      ),
      PepButtonMode.text => IconButton(
        onPressed: onPressed,
        style: style,
        icon: icon,
      ),
    };
  }
}
