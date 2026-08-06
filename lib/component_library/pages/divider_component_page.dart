import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Divider — https://m3.material.io/components/divider/specs
class DividerComponentPage extends StatelessWidget {
  const DividerComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'divider',
    title: 'Divider',
    m3SpecUrl: 'https://m3.material.io/components/divider/specs',
    description:
        'Separate content into clear groups. '
        'Pick divider variants from Part 2 — do not invent new ones.',
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Full-width',
      m3Behavior: 'Divider spans the full container width.',
      ourImplementation: 'Divider() default.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Inset',
      m3Behavior: 'Divider inset from the leading edge.',
      ourImplementation: 'Divider with indent.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Middle inset',
      m3Behavior: 'Divider inset from both edges.',
      ourImplementation: 'Divider with indent and endIndent.',
      action: 'Use as-is',
    ),
  ];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(
      id: 'full_width',
      label: 'Full-width',
      supportsLeadingIcon: false,
    ),
    VariantMatrixRow(
      id: 'inset',
      label: 'Inset',
      supportsLeadingIcon: false,
    ),
    VariantMatrixRow(
      id: 'middle_inset',
      label: 'Middle inset',
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
    final color = cell.isEnabled
        ? null
        : Theme.of(context).disabledColor.withValues(alpha: 0.38);

    return SizedBox(
      width: double.infinity,
      child: switch (row.id) {
        'full_width' => Divider(color: color),
        'inset' => Divider(indent: 16, color: color),
        'middle_inset' => Divider(indent: 16, endIndent: 16, color: color),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
