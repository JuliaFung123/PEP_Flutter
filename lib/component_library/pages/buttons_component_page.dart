import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/kpi_button_styles.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Buttons — https://m3.material.io/components/buttons/specs
class ButtonsComponentPage extends StatefulWidget {
  const ButtonsComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'buttons',
    title: 'Buttons',
    m3SpecUrl: 'https://m3.material.io/components/buttons/specs',
    description:
        'Help people take actions. Default colors use M3 tokens from the app theme '
        '(ColorScheme + button themes). Toggle states are preview overrides only.',
  );

  @override
  State<ButtonsComponentPage> createState() => _ButtonsComponentPageState();
}

class _ButtonsComponentPageState extends State<ButtonsComponentPage> {
  bool _showIcon = false;
  KpiButtonColorState _colorState = KpiButtonColorState.defaultState;

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Theme tokens',
      m3Behavior:
          'Button colors are M3 ColorScheme roles (e.g. outlineVariant, onSurfaceVariant).',
      ourImplementation:
          'AppTheme wires *ButtonTheme from colorScheme — Figma hex values resolve from seed.',
      action: 'Use theme',
    ),
    ComponentNote(
      variant: 'Elevated',
      m3Behavior: 'Adds emphasis with shadow; lower emphasis than filled.',
      ourImplementation: 'ElevatedButtonTheme — surfaceContainerLow + primary.',
      action: 'Use theme',
    ),
    ComponentNote(
      variant: 'Filled',
      m3Behavior: 'Highest emphasis for primary actions.',
      ourImplementation: 'FilledButtonTheme — primary + onPrimary.',
      action: 'Use theme',
    ),
    ComponentNote(
      variant: 'Filled tonal',
      m3Behavior: 'Medium emphasis with tonal container color.',
      ourImplementation:
          'FilledButton.tonal — secondaryContainer + onSecondaryContainer from theme.',
      action: 'Use theme',
    ),
    ComponentNote(
      variant: 'Outlined',
      m3Behavior: 'Medium emphasis with outline border.',
      ourImplementation:
          'OutlinedButtonTheme — outlineVariant border, onSurfaceVariant label/icon.',
      action: 'Use theme',
    ),
    ComponentNote(
      variant: 'Text',
      m3Behavior: 'Lowest emphasis for optional actions.',
      ourImplementation: 'TextButtonTheme — primary label.',
      action: 'Use theme',
    ),
    ComponentNote(
      variant: 'Toggle states',
      m3Behavior: 'Toggle unselected/selected swap container and label tokens.',
      ourImplementation:
          'Preview-only overrides in KpiButtonStyles — not in standard button themes.',
      action: 'Use for toggle demos',
    ),
    ComponentNote(
      variant: 'Icon',
      m3Behavior: 'Compact icon-only action.',
      ourImplementation: 'IconButton.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'FAB',
      m3Behavior: 'Prominent action floating above content.',
      ourImplementation: 'FloatingActionButton.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Extended FAB',
      m3Behavior: 'FAB with text label.',
      ourImplementation: 'FloatingActionButton.extended.',
      action: 'Use as-is',
    ),
  ];

  static const _sizes = <_ButtonSizeSpec>[
    _ButtonSizeSpec(
      label: 'X Small',
      height: 32,
      horizontalPadding: 12,
      iconSize: 20,
      iconGap: 4,
    ),
    _ButtonSizeSpec(
      label: 'Small',
      height: 40,
      horizontalPadding: 16,
      iconSize: 20,
      iconGap: 8,
    ),
    _ButtonSizeSpec(
      label: 'Medium',
      height: 56,
      horizontalPadding: 24,
      iconSize: 24,
      iconGap: 8,
    ),
    _ButtonSizeSpec(
      label: 'Large',
      height: 96,
      horizontalPadding: 48,
      iconSize: 32,
      iconGap: 12,
    ),
    _ButtonSizeSpec(
      label: 'X Large',
      height: 136,
      horizontalPadding: 64,
      iconSize: 40,
      iconGap: 16,
    ),
  ];

  static const _rows = <_ButtonVariantRow>[
    _ButtonVariantRow(id: 'elevated', label: 'Elevated'),
    _ButtonVariantRow(id: 'elevated_disabled', label: 'Elevated (disabled)'),
    _ButtonVariantRow(id: 'filled', label: 'Filled'),
    _ButtonVariantRow(id: 'filled_disabled', label: 'Filled (disabled)'),
    _ButtonVariantRow(id: 'filled_tonal', label: 'Filled tonal'),
    _ButtonVariantRow(
      id: 'filled_tonal_disabled',
      label: 'Filled tonal (disabled)',
    ),
    _ButtonVariantRow(id: 'outlined', label: 'Outlined'),
    _ButtonVariantRow(id: 'outlined_disabled', label: 'Outlined (disabled)'),
    _ButtonVariantRow(id: 'text', label: 'Text'),
    _ButtonVariantRow(id: 'text_disabled', label: 'Text (disabled)'),
    _ButtonVariantRow(
      id: 'icon',
      label: 'Icon',
      supportsIcons: false,
    ),
    _ButtonVariantRow(
      id: 'icon_disabled',
      label: 'Icon (disabled)',
      supportsIcons: false,
    ),
    _ButtonVariantRow(
      id: 'fab',
      label: 'FAB',
      supportsIcons: false,
    ),
    _ButtonVariantRow(
      id: 'fab_disabled',
      label: 'FAB (disabled)',
      supportsIcons: false,
    ),
    _ButtonVariantRow(
      id: 'extended_fab',
      label: 'Extended FAB',
      supportsIcons: false,
    ),
    _ButtonVariantRow(
      id: 'extended_fab_disabled',
      label: 'Extended FAB (disabled)',
      supportsIcons: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: ButtonsComponentPage.meta.title,
      m3SpecUrl: ButtonsComponentPage.meta.m3SpecUrl,
      description: ButtonsComponentPage.meta.description,
      notes: _notes,
      pendingVariants: const [],
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VariantIconControls(
            showLeadingIcon: _showIcon,
            showTrailingIcon: false,
            leadingLabel: 'Icon',
            showTrailingToggle: false,
            onLeadingChanged: (v) => setState(() => _showIcon = v),
            onTrailingChanged: (_) {},
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: SegmentedButton<KpiButtonColorState>(
              segments: const [
                ButtonSegment(
                  value: KpiButtonColorState.defaultState,
                  label: Text('Default'),
                ),
                ButtonSegment(
                  value: KpiButtonColorState.toggleUnselected,
                  label: Text('Toggle unselected'),
                ),
                ButtonSegment(
                  value: KpiButtonColorState.toggleSelected,
                  label: Text('Toggle selected'),
                ),
              ],
              selected: {_colorState},
              onSelectionChanged: (selection) {
                setState(() => _colorState = selection.first);
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildVariantTable(context),
        ],
      ),
    );
  }

  Widget _buildVariantTable(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    final labelStyle = Theme.of(context).textTheme.labelLarge;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return LayoutBuilder(
        builder: (context, constraints) {
          final minWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth.clamp(1180.0, double.infinity).toDouble()
              : 1180.0;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minWidth),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.8),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                  4: FlexColumnWidth(),
                  5: FlexColumnWidth(),
                },
                border: TableBorder.all(color: borderColor),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      _tableCell(
                        child: Text('Variant', style: labelStyle),
                        alignment: Alignment.centerLeft,
                      ),
                      for (final size in _sizes)
                        _tableCell(
                          child: Text(
                            size.label,
                            style: labelStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                  for (final row in _rows)
                    TableRow(
                      children: [
                        _tableCell(
                          child: Text(row.label, style: bodyStyle),
                          alignment: Alignment.centerLeft,
                        ),
                        for (final size in _sizes)
                          _tableCell(
                            child: _buildCell(
                              context: context,
                              row: row,
                              size: size,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
    );
  }

  Widget _tableCell({
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

  Widget _buildCell({
    required BuildContext context,
    required _ButtonVariantRow row,
    required _ButtonSizeSpec size,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = !row.id.endsWith('_disabled');
    final onPressed = enabled ? () {} : null;
    final showIcon = _showIcon && row.supportsIcons;
    final baseId = row.id.replaceFirst('_disabled', '');

    ButtonStyle labelStyle(KpiButtonVariant v) => KpiButtonStyles.style(
          scheme: scheme,
          variant: v,
          colorState: _colorState,
          height: size.height,
          horizontalPadding: size.horizontalPadding,
          iconSize: size.iconSize,
        );

    Widget labelButton({
      required Widget Function({
        required VoidCallback? onPressed,
        required Widget child,
        ButtonStyle? style,
      })
      builder,
      required KpiButtonVariant buttonVariant,
    }) {
      const label = Text('Label');
      final style = labelStyle(buttonVariant);
      if (showIcon) {
        return builder(
          onPressed: onPressed,
          style: style,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: size.iconSize),
              SizedBox(width: size.iconGap),
              label,
            ],
          ),
        );
      }
      return builder(onPressed: onPressed, child: label, style: style);
    }

    return switch (baseId) {
      'elevated' => labelButton(
        builder: ElevatedButton.new,
        buttonVariant: KpiButtonVariant.elevated,
      ),
      'filled' => labelButton(
        builder: FilledButton.new,
        buttonVariant: KpiButtonVariant.filled,
      ),
      'filled_tonal' => labelButton(
        builder: FilledButton.tonal,
        buttonVariant: KpiButtonVariant.filledTonal,
      ),
      'outlined' => labelButton(
        builder: OutlinedButton.new,
        buttonVariant: KpiButtonVariant.outlined,
      ),
      'text' => labelButton(
        builder: TextButton.new,
        buttonVariant: KpiButtonVariant.text,
      ),
      'icon' => IconButton(
        onPressed: onPressed,
        iconSize: size.iconSize,
        style: IconButton.styleFrom(
          minimumSize: Size(size.height, size.height),
          maximumSize: Size(size.height, size.height),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: scheme.onSurfaceVariant,
        ),
        icon: const Icon(Icons.edit_outlined),
      ),
      'fab' => SizedBox(
        width: size.height,
        height: size.height,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Icon(Icons.add, size: size.iconSize),
        ),
      ),
      'extended_fab' => SizedBox(
        height: size.height,
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          icon: Icon(Icons.add, size: size.iconSize),
          label: const Text('Label'),
          extendedIconLabelSpacing: size.iconGap,
          extendedPadding:
              EdgeInsets.symmetric(horizontal: size.horizontalPadding),
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _ButtonVariantRow {
  const _ButtonVariantRow({
    required this.id,
    required this.label,
    this.supportsIcons = true,
  });

  final String id;
  final String label;
  final bool supportsIcons;
}

class _ButtonSizeSpec {
  const _ButtonSizeSpec({
    required this.label,
    required this.height,
    required this.horizontalPadding,
    required this.iconSize,
    required this.iconGap,
  });

  final String label;
  final double height;
  final double horizontalPadding;
  final double iconSize;
  final double iconGap;
}
