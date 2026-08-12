import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/pep_chip_styles.dart';
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
        'Sizes: Default 32 (radius 8) and Small 24 (stadium / fully rounded). '
        'Pick chip variants from Part 2 in layouts — do not invent new ones.',
  );

  @override
  State<ChipsComponentPage> createState() => _ChipsComponentPageState();
}

enum _ChipLeadingKind { none, leadingIcon, avatar }

class _ChipsComponentPageState extends State<ChipsComponentPage> {
  _ChipLeadingKind _leadingKind = _ChipLeadingKind.none;
  bool _showTrailingIcon = false;
  PepChipSize _size = PepChipSize.medium;
  final Map<String, bool> _selection = {};

  bool get _showLeadingIcon =>
      _leadingKind == _ChipLeadingKind.leadingIcon;

  bool get _showAvatar => _leadingKind == _ChipLeadingKind.avatar;

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'chipTheme',
      spec:
          'Default: labelLarge, icon 18, leading slot 24×24, outlineVariant '
          'side, radius 8. Small: labelMedium, icon 16, leading slot 18×18, '
          'StadiumBorder. Leading/delete icons match label. Selected Filter → '
          'secondaryContainer, no border.',
      setupCode: '''
chipTheme: ChipThemeData(
  labelStyle: textTheme.labelLarge,
  iconTheme: IconThemeData(size: 18, color: colorScheme.onSurface),
  deleteIconColor: colorScheme.onSurface,
  avatarBoxConstraints: BoxConstraints.tightFor(width: 24, height: 24),
  side: BorderSide(color: colorScheme.outlineVariant),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
),
// Small:
ChipTheme(
  data: PepChipStyles.themeOf(context, PepChipSize.small),
  child: ...,
)
''',
    ),
    ComponentNote(
      topic: 'PepChipSize',
      spec:
          'medium (Default 32, radius 8) · small (24, stadium). Use '
          '`PepChipStyles.themeOf` to apply.',
      setupCode: '''
ChipTheme(
  data: PepChipStyles.themeOf(context, PepChipSize.small),
  child: FilterChip(label: Text('Small'), onSelected: (_) {}),
)
''',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Chip group scroll fade',
      foundIn: 'PEP filter bar (draft)',
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
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final sizeLabelStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: muted);

    return ComponentPageScaffold(
      title: ChipsComponentPage.meta.title,
      m3SpecUrl: ChipsComponentPage.meta.m3SpecUrl,
      description: ChipsComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Size', style: sizeLabelStyle),
          const SizedBox(height: 8),
          SegmentedButton<PepChipSize>(
            segments: [
              for (final size in PepChipSize.values)
                ButtonSegment(
                  value: size,
                  label: Text(size.label),
                ),
            ],
            selected: {_size},
            onSelectionChanged: (next) {
              if (next.isEmpty) return;
              setState(() => _size = next.first);
            },
          ),
          const SizedBox(height: 16),
          Text('Leading', style: sizeLabelStyle),
          const SizedBox(height: 4),
          RadioGroup<_ChipLeadingKind>(
            groupValue: _leadingKind,
            onChanged: (value) {
              setState(() => _leadingKind = value ?? _ChipLeadingKind.none);
            },
            child: Wrap(
              spacing: 24,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _leadingRadio(
                  context,
                  value: _ChipLeadingKind.none,
                  label: 'None',
                ),
                _leadingRadio(
                  context,
                  value: _ChipLeadingKind.leadingIcon,
                  label: 'Leading icon',
                ),
                _leadingRadio(
                  context,
                  value: _ChipLeadingKind.avatar,
                  label: 'Avatar',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          VariantIconControls(
            showLeadingIcon: false,
            showTrailingIcon: _showTrailingIcon,
            showLeadingToggle: false,
            trailingLabel: 'Trailing icon',
            onLeadingChanged: (_) {},
            onTrailingChanged: (value) =>
                setState(() => _showTrailingIcon = value),
          ),
          const SizedBox(height: 12),
          ChipTheme(
            data: PepChipStyles.themeOf(context, _size),
            child: VariantMatrixTable(
              rows: _rows,
              showLeadingIcon: _showLeadingIcon,
              showAvatar: _showAvatar,
              showTrailingIcon: _showTrailingIcon,
              selectionState: _selection,
              cellBuilder: _buildCell,
            ),
          ),
        ],
      ),
    );
  }

  Widget _leadingRadio(
    BuildContext context, {
    required _ChipLeadingKind value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<_ChipLeadingKind>(value: value),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }

  bool _isRowSelected(String rowId) => _selection[rowId] ?? false;

  void _setRowSelected(String rowId, bool selected) {
    setState(() => _selection[rowId] = selected);
  }

  TextStyle? _labelStyle(BuildContext context, Color foreground) =>
      _size.labelStyleOf(context)?.copyWith(color: foreground);

  /// Chip `avatar:` slot — circular avatar preferred over leading icon.
  Widget? _chipAvatarSlot(VariantMatrixCell cell) {
    if (cell.showAvatar) {
      return chipAvatar(true, size: _size.avatarSize);
    }
    return chipLeadingIcon(
      cell.showLeadingIcon,
      size: _size.iconSize,
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required VariantMatrixRow row,
    required VariantMatrixCell cell,
    bool elevated = false,
  }) {
    final isSelected = _isRowSelected(row.id);
    final fg = _chipForeground(
      context,
      enabled: cell.isEnabled,
      selected: isSelected,
    );
    final iconTheme = _chipIconTheme(fg);
    // Selected = filled, no outline (M3 filter selected).
    final BorderSide? side = !cell.isEnabled
        ? BorderSide(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.12),
          )
        : isSelected
            ? BorderSide.none
            : null;
    final avatar = _chipAvatarSlot(cell);
    final chip = elevated
        ? FilterChip.elevated(
            label: chipLabel(
              context,
              'Label',
              style: _labelStyle(context, fg),
            ),
            avatar: avatar,
            iconTheme: iconTheme,
            labelStyle: _labelStyle(context, fg),
            selected: isSelected,
            showCheckmark: true,
            checkmarkColor: fg,
            side: side,
            shape: _size.shape,
            avatarBoxConstraints: _size.avatarBoxConstraints,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onSelected: cell.isEnabled
                ? (value) => _setRowSelected(row.id, value)
                : null,
            deleteIcon: chipFilterTrailingIcon(
              cell.showTrailingIcon,
              size: _size.iconSize,
            ),
            deleteIconColor: fg,
            onDeleted: cell.showTrailingIcon && cell.isEnabled ? () {} : null,
          )
        : FilterChip(
            label: chipLabel(
              context,
              'Label',
              style: _labelStyle(context, fg),
            ),
            avatar: avatar,
            iconTheme: iconTheme,
            labelStyle: _labelStyle(context, fg),
            selected: isSelected,
            showCheckmark: true,
            checkmarkColor: fg,
            side: side ??
                BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
            shape: _size.shape,
            avatarBoxConstraints: _size.avatarBoxConstraints,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onSelected: cell.isEnabled
                ? (value) => _setRowSelected(row.id, value)
                : null,
            deleteIcon: chipFilterTrailingIcon(
              cell.showTrailingIcon,
              size: _size.iconSize,
            ),
            deleteIconColor: fg,
            onDeleted: cell.showTrailingIcon && cell.isEnabled ? () {} : null,
          );

    return elevated
        ? ChipTheme(
            data: ChipTheme.of(context).copyWith(
              side: side,
              selectedColor:
                  Theme.of(context).colorScheme.secondaryContainer,
              shape: _size.shape,
              padding: _size.padding,
              labelPadding: _size.labelPadding,
              avatarBoxConstraints: _size.avatarBoxConstraints,
            ),
            child: chip,
          )
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
    final foreground = !enabled
        ? colors.onSurface.withValues(alpha: 0.38)
        : selected
            ? colors.onSecondaryContainer
            : colors.onSurface;

    return base.copyWith(
      backgroundColor: Colors.transparent,
      disabledColor: Colors.transparent,
      selectedColor: selected ? colors.secondaryContainer : Colors.transparent,
      side: !enabled
          ? BorderSide(color: colors.onSurface.withValues(alpha: 0.12))
          : selected
              ? BorderSide.none
              : BorderSide(color: colors.outlineVariant),
      elevation: 0,
      pressElevation: 0,
      shape: _size.shape,
      padding: _size.padding,
      labelPadding: _size.labelPadding,
      avatarBoxConstraints: _size.avatarBoxConstraints,
      labelStyle: _size.labelStyleOf(context)?.copyWith(color: foreground),
      iconTheme: IconThemeData(size: _size.iconSize, color: foreground),
      deleteIconColor: foreground,
    );
  }

  /// Foreground for elevated chips — matches label ink.
  Color _chipForeground(
    BuildContext context, {
    required bool enabled,
    bool selected = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    if (!enabled) return colors.onSurface.withValues(alpha: 0.38);
    if (selected) return colors.onSecondaryContainer;
    return colors.onSurface;
  }

  IconThemeData _chipIconTheme(Color foreground) =>
      IconThemeData(size: _size.iconSize, color: foreground);

  Widget _buildCell(
    BuildContext context,
    VariantMatrixRow row,
    VariantMatrixCell cell,
  ) {
    final fg = _chipForeground(context, enabled: cell.isEnabled);
    final label = chipLabel(
      context,
      'Label',
      style: _labelStyle(context, fg),
    );
    final leading = _chipAvatarSlot(cell);
    final trailing = chipTrailingIcon(
      cell.showTrailingIcon,
      size: _size.iconSize,
    );
    final onPressed = cell.isEnabled ? () {} : null;
    final iconTheme = _chipIconTheme(fg);

    return switch (row.id) {
      'assist' => _withFlatChipTheme(
        context: context,
        selected: false,
        enabled: cell.isEnabled,
        child: ActionChip(
          label: label,
          avatar: leading,
          iconTheme: iconTheme,
          labelStyle: _labelStyle(context, fg),
          shape: _size.shape,
          avatarBoxConstraints: _size.avatarBoxConstraints,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          onPressed: onPressed,
        ),
      ),
      'assist_elevated' => ActionChip.elevated(
        label: label,
        avatar: leading,
        iconTheme: iconTheme,
        labelStyle: _labelStyle(context, fg),
        shape: _size.shape,
        avatarBoxConstraints: _size.avatarBoxConstraints,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
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
          iconTheme: iconTheme,
          labelStyle: _labelStyle(context, fg),
          shape: _size.shape,
          avatarBoxConstraints: _size.avatarBoxConstraints,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          onPressed: onPressed,
          onDeleted: cell.showTrailingIcon && cell.isEnabled ? () {} : null,
          deleteIcon: trailing,
          deleteIconColor: fg,
        ),
      ),
      'suggestion' => _withFlatChipTheme(
        context: context,
        selected: false,
        enabled: cell.isEnabled,
        child: ChoiceChip(
          label: label,
          avatar: leading,
          iconTheme: iconTheme,
          labelStyle: _labelStyle(context, fg),
          shape: _size.shape,
          avatarBoxConstraints: _size.avatarBoxConstraints,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          selected: false,
          onSelected: cell.isEnabled ? (_) {} : null,
        ),
      ),
      'suggestion_elevated' => ChoiceChip.elevated(
        label: label,
        avatar: leading,
        iconTheme: iconTheme,
        labelStyle: _labelStyle(context, fg),
        shape: _size.shape,
        avatarBoxConstraints: _size.avatarBoxConstraints,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        selected: false,
        onSelected: cell.isEnabled ? (_) {} : null,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
