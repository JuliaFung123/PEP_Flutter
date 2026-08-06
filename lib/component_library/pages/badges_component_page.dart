import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Badges — https://m3.material.io/components/badges/specs
class BadgesComponentPage extends StatelessWidget {
  const BadgesComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'badges',
    title: 'Badges',
    m3SpecUrl: 'https://m3.material.io/components/badges/specs',
    description:
        'Show notifications, counts, or status on icons, avatars, and labels. '
        'Pick badge variants from Part 2 — do not invent new ones.',
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Small badge',
      m3Behavior: 'Small badge on icon or avatar; shows count or dot.',
      ourImplementation: 'Badge widget wrapping Icon.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Large badge',
      m3Behavior: 'Large badge with label text for counts.',
      ourImplementation: 'Badge with label property.',
      action: 'Use as-is',
    ),
  ];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(
      id: 'small',
      label: 'Small badge',
      supportsLeadingIcon: false,
    ),
    VariantMatrixRow(
      id: 'large',
      label: 'Large badge',
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
    final child = Icon(
      Icons.notifications_outlined,
      color: cell.isEnabled
          ? Theme.of(context).colorScheme.onSurfaceVariant
          : Theme.of(context).disabledColor,
    );

    return switch (row.id) {
      'small' => Badge(
        isLabelVisible: cell.isEnabled,
        child: child,
      ),
      'large' => Badge(
        label: Text(cell.isEnabled ? '3' : '0'),
        child: child,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
