import 'package:flutter/material.dart';

import '../models/variant_status.dart';

typedef VariantCellBuilder = Widget Function(
  BuildContext context,
  VariantMatrixRow row,
  VariantMatrixCell cell,
);

/// One row in the Part 2 variant matrix (e.g. Assist, Filter elevated).
class VariantMatrixRow {
  const VariantMatrixRow({
    required this.id,
    required this.label,
    this.supportsSelection = false,
    this.supportsLeadingIcon = true,
    this.supportsTrailingIcon = false,
  });

  final String id;
  final String label;
  final bool supportsSelection;
  final bool supportsLeadingIcon;
  final bool supportsTrailingIcon;
}

/// Identifies a single cell in the matrix.
class VariantMatrixCell {
  const VariantMatrixCell({
    required this.row,
    this.isSelected = false,
    this.showLeadingIcon = false,
    this.showTrailingIcon = false,
    this.showHelperText = true,
    this.isEnabled = true,
    this.isError = false,
  });

  final VariantMatrixRow row;
  final bool isSelected;
  final bool showLeadingIcon;
  final bool showTrailingIcon;
  final bool showHelperText;
  final bool isEnabled;
  final bool isError;
}

/// Shared controls for icon visibility across the matrix.
class VariantIconControls extends StatelessWidget {
  const VariantIconControls({
    super.key,
    required this.showLeadingIcon,
    required this.showTrailingIcon,
    required this.onLeadingChanged,
    required this.onTrailingChanged,
    this.leadingLabel = 'Leading icon',
    this.trailingLabel = 'Trailing icon',
    this.showLeadingToggle = true,
    this.showTrailingToggle = true,
    this.showHelperText,
    this.onHelperTextChanged,
    this.helperTextLabel = 'Helper text',
  });

  final bool showLeadingIcon;
  final bool showTrailingIcon;
  final ValueChanged<bool> onLeadingChanged;
  final ValueChanged<bool> onTrailingChanged;
  final String leadingLabel;
  final String trailingLabel;
  final bool showLeadingToggle;
  final bool showTrailingToggle;
  final bool? showHelperText;
  final ValueChanged<bool>? onHelperTextChanged;
  final String helperTextLabel;

  bool get _showHelperTextToggle =>
      showHelperText != null && onHelperTextChanged != null;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 32,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (showLeadingToggle)
          _labeledSwitch(
            context: context,
            label: leadingLabel,
            value: showLeadingIcon,
            onChanged: onLeadingChanged,
          ),
        if (showTrailingToggle)
          _labeledSwitch(
            context: context,
            label: trailingLabel,
            value: showTrailingIcon,
            onChanged: onTrailingChanged,
          ),
        if (_showHelperTextToggle)
          _labeledSwitch(
            context: context,
            label: helperTextLabel,
            value: showHelperText!,
            onChanged: onHelperTextChanged!,
          ),
      ],
    );
  }

  Widget _labeledSwitch({
    required BuildContext context,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(width: 8),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

/// Part 2 — variant matrix with configurable status columns.
class VariantMatrixTable extends StatelessWidget {
  const VariantMatrixTable({
    super.key,
    required this.rows,
    required this.cellBuilder,
    required this.showLeadingIcon,
    required this.showTrailingIcon,
    required this.selectionState,
    this.showHelperText = true,
    this.cellBackgroundColor,
    this.statuses = const [
      VariantStaticStatus.enabled,
      VariantStaticStatus.disabled,
    ],
  });

  final List<VariantMatrixRow> rows;
  final VariantCellBuilder cellBuilder;
  final bool showLeadingIcon;
  final bool showTrailingIcon;
  final bool showHelperText;
  final Map<String, bool> selectionState;
  /// When set, paints every table cell (header and body) for contrast checks.
  final Color? cellBackgroundColor;
  final List<VariantStaticStatus> statuses;

  Map<int, TableColumnWidth> get _columnWidths => {
    0: const FlexColumnWidth(1.4),
    for (var i = 0; i < statuses.length; i++) i + 1: const FlexColumnWidth(1),
  };

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;

    return SizedBox(
      width: double.infinity,
      child: Table(
        columnWidths: _columnWidths,
        border: TableBorder.all(color: borderColor),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _headerRow(context),
          ...rows.map((row) => _dataRow(context, row)),
        ],
      ),
    );
  }

  TableRow _headerRow(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;

    return TableRow(
      children: [
        _headerCell(
          child: Text('Variant', style: style),
          alignment: Alignment.centerLeft,
          backgroundColor: cellBackgroundColor,
        ),
        ...statuses.map(
          (status) => _headerCell(
            child: Text(_label(status), style: style, textAlign: TextAlign.center),
            backgroundColor: cellBackgroundColor,
          ),
        ),
      ],
    );
  }

  TableRow _dataRow(BuildContext context, VariantMatrixRow row) {
    final isSelected = selectionState[row.id] ?? false;

    return TableRow(
      children: [
        _bodyCell(
          alignment: Alignment.centerLeft,
          backgroundColor: cellBackgroundColor,
          child: Text(row.label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        ...statuses.map((status) {
          final cell = VariantMatrixCell(
            row: row,
            isSelected: isSelected,
            showLeadingIcon: showLeadingIcon && row.supportsLeadingIcon,
            showTrailingIcon: showTrailingIcon && row.supportsTrailingIcon,
            showHelperText: showHelperText,
            isEnabled: status != VariantStaticStatus.disabled,
            isError: status == VariantStaticStatus.error,
          );

          return _bodyCell(
            backgroundColor: cellBackgroundColor,
            child: cellBuilder(context, row, cell),
          );
        }),
      ],
    );
  }

  Widget _headerCell({
    required Widget child,
    Alignment alignment = Alignment.center,
    Color? backgroundColor,
  }) {
    return TableCell(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        alignment: alignment,
        color: backgroundColor,
        child: child,
      ),
    );
  }

  Widget _bodyCell({
    required Widget child,
    Alignment alignment = Alignment.center,
    Color? backgroundColor,
  }) {
    return TableCell(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        alignment: alignment,
        color: backgroundColor,
        child: child,
      ),
    );
  }

  String _label(VariantStaticStatus status) => switch (status) {
    VariantStaticStatus.enabled => 'Enabled',
    VariantStaticStatus.disabled => 'Disabled',
    VariantStaticStatus.error => 'Error',
  };
}
