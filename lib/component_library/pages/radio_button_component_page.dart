import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Radio button — https://m3.material.io/components/radio-button/specs
class RadioButtonComponentPage extends StatefulWidget {
  const RadioButtonComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'radio_button',
    title: 'Radio button',
    m3SpecUrl: 'https://m3.material.io/components/radio-button/specs',
    description:
        'Select exactly one option from a set. '
        'Pick radio variants from Part 2 — do not invent new ones.',
  );

  @override
  State<RadioButtonComponentPage> createState() =>
      _RadioButtonComponentPageState();
}

class _RadioButtonComponentPageState extends State<RadioButtonComponentPage> {
  final Map<String, int> _groupValue = {};

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Radio',
      m3Behavior: 'Single selection within a radio group.',
      ourImplementation: 'Radio widget with groupValue.',
      action: 'Use as-is',
    ),
  ];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(
      id: 'radio',
      label: 'Radio',
      supportsSelection: true,
      supportsLeadingIcon: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: RadioButtonComponentPage.meta.title,
      m3SpecUrl: RadioButtonComponentPage.meta.m3SpecUrl,
      description: RadioButtonComponentPage.meta.description,
      notes: _notes,
      pendingVariants: const [],
      variantsSection: VariantMatrixTable(
        rows: _rows,
        showLeadingIcon: false,
        showTrailingIcon: false,
        selectionState: const {},
        cellBuilder: _buildCell,
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    VariantMatrixRow row,
    VariantMatrixCell cell,
  ) {
    final selected = _groupValue[row.id] ?? 0;

    return IgnorePointer(
      ignoring: !cell.isEnabled,
      child: Opacity(
        opacity: cell.isEnabled ? 1 : 0.38,
        child: RadioGroup<int>(
          groupValue: selected,
          onChanged: (value) =>
              setState(() => _groupValue[row.id] = value ?? 0),
          child: const Radio<int>(value: 1),
        ),
      ),
    );
  }
}
