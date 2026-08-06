import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Checkbox — https://m3.material.io/components/checkbox/specs
class CheckboxComponentPage extends StatefulWidget {
  const CheckboxComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'checkbox',
    title: 'Checkbox',
    m3SpecUrl: 'https://m3.material.io/components/checkbox/specs',
    description:
        'Select one or more items from a set. '
        'Pick checkbox variants from Part 2 — do not invent new ones.',
  );

  @override
  State<CheckboxComponentPage> createState() => _CheckboxComponentPageState();
}

class _CheckboxComponentPageState extends State<CheckboxComponentPage> {
  final Map<String, bool> _checked = {};
  final Map<String, bool?> _triState = {};

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Checkbox',
      m3Behavior: 'Binary checked / unchecked selection.',
      ourImplementation: 'Checkbox widget.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Indeterminate',
      m3Behavior: 'Mixed state for parent of partially selected children.',
      ourImplementation: 'Checkbox with tristate: true, value: null.',
      action: 'Use as-is',
    ),
  ];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(
      id: 'checkbox',
      label: 'Checkbox',
      supportsSelection: true,
      supportsLeadingIcon: false,
    ),
    VariantMatrixRow(
      id: 'indeterminate',
      label: 'Indeterminate',
      supportsSelection: true,
      supportsLeadingIcon: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: CheckboxComponentPage.meta.title,
      m3SpecUrl: CheckboxComponentPage.meta.m3SpecUrl,
      description: CheckboxComponentPage.meta.description,
      notes: _notes,
      pendingVariants: const [],
      variantsSection: VariantMatrixTable(
        rows: _rows,
        showLeadingIcon: false,
        showTrailingIcon: false,
        selectionState: _checked,
        cellBuilder: _buildCell,
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    VariantMatrixRow row,
    VariantMatrixCell cell,
  ) {
    return switch (row.id) {
      'checkbox' => Checkbox(
        value: _checked[row.id] ?? false,
        onChanged: cell.isEnabled
            ? (value) => setState(() => _checked[row.id] = value ?? false)
            : null,
      ),
      'indeterminate' => Checkbox(
        tristate: true,
        value: _triState[row.id],
        onChanged: cell.isEnabled
            ? (value) => setState(() => _triState[row.id] = value)
            : null,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
