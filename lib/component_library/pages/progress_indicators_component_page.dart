import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Progress indicators — https://m3.material.io/components/progress-indicators/specs
class ProgressIndicatorsComponentPage extends StatelessWidget {
  const ProgressIndicatorsComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'progress_indicators',
    title: 'Progress indicators',
    m3SpecUrl: 'https://m3.material.io/components/progress-indicators/specs',
    description:
        'Show the status of a process in progress. '
        'Pick progress indicator variants from Part 2 — do not invent new ones.',
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'progressIndicatorTheme',
      spec:
          'AppTheme does not override — ColorScheme.primary track. '
          'Linear/Circular; determinate (value) or indeterminate.',
      setupCode: '''
LinearProgressIndicator(value: 0.6)
LinearProgressIndicator() // indeterminate
CircularProgressIndicator(value: 0.6)
CircularProgressIndicator()
''',
    ),
  ];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(
      id: 'linear_determinate',
      label: 'Linear determinate',
      supportsLeadingIcon: false,
    ),
    VariantMatrixRow(
      id: 'linear_indeterminate',
      label: 'Linear indeterminate',
      supportsLeadingIcon: false,
    ),
    VariantMatrixRow(
      id: 'circular_determinate',
      label: 'Circular determinate',
      supportsLeadingIcon: false,
    ),
    VariantMatrixRow(
      id: 'circular_indeterminate',
      label: 'Circular indeterminate',
      supportsLeadingIcon: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: meta.title,
      m3SpecUrl: meta.m3SpecUrl,
      description: meta.description,
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

  static Widget _buildCell(
    BuildContext context,
    VariantMatrixRow row,
    VariantMatrixCell cell,
  ) {
    final color = cell.isEnabled ? null : Theme.of(context).disabledColor;

    return SizedBox(
      width: row.id.startsWith('linear') ? double.infinity : null,
      child: switch (row.id) {
        'linear_determinate' => LinearProgressIndicator(
          value: 0.6,
          color: color,
        ),
        'linear_indeterminate' => LinearProgressIndicator(color: color),
        'circular_determinate' => CircularProgressIndicator(
          value: 0.6,
          color: color,
        ),
        'circular_indeterminate' => CircularProgressIndicator(color: color),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
