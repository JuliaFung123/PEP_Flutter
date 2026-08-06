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
      variant: 'Linear determinate',
      m3Behavior: 'Shows known progress along a track.',
      ourImplementation: 'LinearProgressIndicator with value.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Linear indeterminate',
      m3Behavior: 'Shows ongoing activity with unknown duration.',
      ourImplementation: 'LinearProgressIndicator without value.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Circular determinate',
      m3Behavior: 'Circular indicator with known progress.',
      ourImplementation: 'CircularProgressIndicator with value.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Circular indeterminate',
      m3Behavior: 'Circular indicator for ongoing activity.',
      ourImplementation: 'CircularProgressIndicator without value.',
      action: 'Use as-is',
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
