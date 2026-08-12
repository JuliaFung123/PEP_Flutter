import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Sliders — https://m3.material.io/components/sliders/specs
class SlidersComponentPage extends StatefulWidget {
  const SlidersComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'sliders',
    title: 'Sliders',
    m3SpecUrl: 'https://m3.material.io/components/sliders/specs',
    description:
        'Select a value from a continuous or discrete range. '
        'Pick slider variants from Part 2 — do not invent new ones.',
  );

  @override
  State<SlidersComponentPage> createState() => _SlidersComponentPageState();
}

class _SlidersComponentPageState extends State<SlidersComponentPage> {
  final Map<String, double> _values = {};
  final Map<String, RangeValues> _rangeValues = {};

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'sliderTheme',
      spec:
          'AppTheme does not override — ColorScheme primary / surfaceContainerHighest. '
          'Slider and RangeSlider.',
      setupCode: '''
Slider(value: value, onChanged: (v) {})
RangeSlider(
  values: RangeValues(start, end),
  onChanged: (v) {},
)
''',
    ),
  ];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(
      id: 'slider',
      label: 'Slider',
      supportsLeadingIcon: false,
    ),
    VariantMatrixRow(
      id: 'range_slider',
      label: 'Range slider',
      supportsLeadingIcon: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: SlidersComponentPage.meta.title,
      m3SpecUrl: SlidersComponentPage.meta.m3SpecUrl,
      description: SlidersComponentPage.meta.description,
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
    return SizedBox(
      width: double.infinity,
      child: switch (row.id) {
        'slider' => Slider(
          value: _values[row.id] ?? 0.4,
          onChanged: cell.isEnabled
              ? (value) => setState(() => _values[row.id] = value)
              : null,
        ),
        'range_slider' => RangeSlider(
          values: _rangeValues[row.id] ?? const RangeValues(0.2, 0.7),
          onChanged: cell.isEnabled
              ? (value) => setState(() => _rangeValues[row.id] = value)
              : null,
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
