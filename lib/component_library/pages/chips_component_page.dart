import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';
import '../widgets/variant_preview.dart';

/// M3 Chips reference — https://m3.material.io/components/chips/specs
class ChipsComponentPage extends StatefulWidget {
  const ChipsComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'chips',
    title: 'Chips',
    m3SpecUrl: 'https://m3.material.io/components/chips/specs',
    description:
        'Compact elements for actions, filters, inputs, and suggestions. '
        'Pick chip variants from Part 2 in layouts — do not invent new ones.',
  );

  @override
  State<ChipsComponentPage> createState() => _ChipsComponentPageState();
}

class _ChipsComponentPageState extends State<ChipsComponentPage> {
  bool _showLeadingIcon = false;
  bool _showTrailingIcon = false;
  final Map<String, bool> _selection = {};

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Assist',
      m3Behavior: 'Assist chips represent smart or automated actions.',
      ourImplementation: 'ActionChip with transparent background and outline border.',
      action: 'Modify theme',
    ),
    ComponentNote(
      variant: 'Assist elevated',
      m3Behavior: 'Assist chip with elevation for more emphasis.',
      ourImplementation:
          'ActionChip.elevated with M3 surface container fill and 1dp elevation.',
      action: 'Modify theme',
    ),
    ComponentNote(
      variant: 'Filter',
      m3Behavior: 'Filter chips tag and filter content; toggle selected.',
      ourImplementation:
          'FilterChip with transparent background when unselected; selected uses secondary container.',
      action: 'Modify theme',
    ),
    ComponentNote(
      variant: 'Filter elevated',
      m3Behavior: 'Elevated filter chip for emphasis.',
      ourImplementation:
          'FilterChip.elevated with M3 surface container fill and 1dp elevation.',
      action: 'Modify theme',
    ),
    ComponentNote(
      variant: 'Input',
      m3Behavior: 'Input chips represent discrete info (e.g. contacts).',
      ourImplementation: 'InputChip with transparent background and outline border.',
      action: 'Modify theme',
    ),
    ComponentNote(
      variant: 'Suggestion',
      m3Behavior: 'Suggestion chips help users complete an action.',
      ourImplementation:
          'ChoiceChip with transparent background and outline border.',
      action: 'Modify theme',
    ),
    ComponentNote(
      variant: 'Suggestion elevated',
      m3Behavior: 'Elevated suggestion chip for extra separation on busy backgrounds.',
      ourImplementation:
          'ChoiceChip.elevated with M3 surface container fill and 1dp elevation.',
      action: 'Modify theme',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Chip group scroll fade',
      foundIn: 'KPI filter bar (draft)',
      description:
          'Horizontal chip row with edge fade mask — not a chip variant.',
      suggestedAction: 'Layout pattern, not a chip atom',
    ),
  ];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(id: 'assist', label: 'Assist'),
    VariantMatrixRow(
      id: 'assist_elevated',
      label: 'Assist elevated',
    ),
    VariantMatrixRow(
      id: 'filter',
      label: 'Filter',
      supportsSelection: true,
      supportsTrailingIcon: true,
    ),
    VariantMatrixRow(
      id: 'filter_elevated',
      label: 'Filter elevated',
      supportsSelection: true,
      supportsTrailingIcon: true,
    ),
    VariantMatrixRow(
      id: 'input',
      label: 'Input',
      supportsTrailingIcon: true,
    ),
    VariantMatrixRow(id: 'suggestion', label: 'Suggestion'),
    VariantMatrixRow(id: 'suggestion_elevated', label: 'Suggestion elevated'),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: ChipsComponentPage.meta.title,
      m3SpecUrl: ChipsComponentPage.meta.m3SpecUrl,
      description: ChipsComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VariantIconControls(
            showLeadingIcon: _showLeadingIcon,
            showTrailingIcon: _showTrailingIcon,
            trailingLabel: 'Trailing / delete icon',
            onLeadingChanged: (value) => setState(() => _showLeadingIcon = value),
            onTrailingChanged: (value) => setState(() => _showTrailingIcon = value),
          ),
          const SizedBox(height: 12),
          VariantMatrixTable(
            rows: _rows,
            showLeadingIcon: _showLeadingIcon,
            showTrailingIcon: _showTrailingIcon,
            selectionState: _selection,
            cellBuilder: _buildCell,
          ),
        ],
      ),
    );
  }

  bool _isRowSelected(String rowId) => _selection[rowId] ?? false;

  void _setRowSelected(String rowId, bool selected) {
    setState(() => _selection[rowId] = selected);
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required VariantMatrixRow row,
    required VariantMatrixCell cell,
    bool elevated = false,
  }) {
    final isSelected = _isRowSelected(row.id);
    final chip = elevated
        ? FilterChip.elevated(
            label: chipLabel(context, 'Label'),
            avatar: chipLeadingIcon(cell.showLeadingIcon),
            selected: isSelected,
            showCheckmark: true,
            onSelected: cell.isEnabled
                ? (value) => _setRowSelected(row.id, value)
                : null,
            deleteIcon: chipTrailingIcon(cell.showTrailingIcon),
            onDeleted: cell.showTrailingIcon && cell.isEnabled ? () {} : null,
          )
        : FilterChip(
            label: chipLabel(context, 'Label'),
            avatar: chipLeadingIcon(cell.showLeadingIcon),
            selected: isSelected,
            showCheckmark: true,
            onSelected: cell.isEnabled
                ? (value) => _setRowSelected(row.id, value)
                : null,
            deleteIcon: chipTrailingIcon(cell.showTrailingIcon),
            onDeleted: cell.showTrailingIcon && cell.isEnabled ? () {} : null,
          );

    return elevated
        ? chip
        : _withFlatChipTheme(
            context: context,
            selected: isSelected,
            enabled: cell.isEnabled,
            child: chip,
          );
  }

  /// M3 flat chips are outlined with no emphasized fill.
  Widget _withFlatChipTheme({
    required BuildContext context,
    required bool selected,
    required bool enabled,
    required Widget child,
  }) {
    return ChipTheme(
      data: _flatChipTheme(
        context,
        enabled: enabled,
        selected: selected,
      ),
      child: child,
    );
  }

  ChipThemeData _flatChipTheme(
    BuildContext context, {
    required bool enabled,
    required bool selected,
  }) {
    final colors = Theme.of(context).colorScheme;
    final base = ChipTheme.of(context);

    return base.copyWith(
      backgroundColor: Colors.transparent,
      disabledColor: Colors.transparent,
      selectedColor: selected ? colors.secondaryContainer : Colors.transparent,
      side: BorderSide(
        color: enabled
            ? (selected ? Colors.transparent : colors.outline)
            : colors.onSurface.withValues(alpha: 0.12),
      ),
      elevation: 0,
      pressElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildCell(
    BuildContext context,
    VariantMatrixRow row,
    VariantMatrixCell cell,
  ) {
    final label = chipLabel(context, 'Label');
    final leading = chipLeadingIcon(cell.showLeadingIcon);
    final trailing = chipTrailingIcon(cell.showTrailingIcon);
    final onPressed = cell.isEnabled ? () {} : null;

    return switch (row.id) {
      'assist' => _withFlatChipTheme(
        context: context,
        selected: false,
        enabled: cell.isEnabled,
        child: ActionChip(
          label: label,
          avatar: leading,
          onPressed: onPressed,
        ),
      ),
      'assist_elevated' => ActionChip.elevated(
        label: label,
        avatar: leading,
        onPressed: onPressed,
      ),
      'filter' => _buildFilterChip(context: context, row: row, cell: cell),
      'filter_elevated' => _buildFilterChip(
        context: context,
        row: row,
        cell: cell,
        elevated: true,
      ),
      'input' => _withFlatChipTheme(
        context: context,
        selected: false,
        enabled: cell.isEnabled,
        child: InputChip(
          label: label,
          avatar: leading,
          onPressed: onPressed,
          onDeleted: cell.showTrailingIcon && cell.isEnabled ? () {} : null,
          deleteIcon: trailing,
        ),
      ),
      'suggestion' => _withFlatChipTheme(
        context: context,
        selected: false,
        enabled: cell.isEnabled,
        child: ChoiceChip(
          label: label,
          avatar: leading,
          selected: false,
          onSelected: cell.isEnabled ? (_) {} : null,
        ),
      ),
      'suggestion_elevated' => ChoiceChip.elevated(
        label: label,
        avatar: leading,
        selected: false,
        onSelected: cell.isEnabled ? (_) {} : null,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
