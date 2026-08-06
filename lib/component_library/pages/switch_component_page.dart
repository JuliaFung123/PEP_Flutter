import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Switch reference — https://m3.material.io/components/switch/specs
class SwitchComponentPage extends StatefulWidget {
  const SwitchComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'switch',
    title: 'Switch',
    m3SpecUrl: 'https://m3.material.io/components/switch/specs',
    description:
        'Toggles a single setting on or off. '
        'Pick switch variants from Part 2 in layouts — do not invent new ones.',
  );

  @override
  State<SwitchComponentPage> createState() => _SwitchComponentPageState();
}

class _SwitchComponentPageState extends State<SwitchComponentPage> {
  final Map<String, bool> _onState = {};

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Switch',
      m3Behavior: 'Standard switch toggles a setting between on and off.',
      ourImplementation: 'Flutter Switch with M3 theme.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Switch with icon',
      m3Behavior: 'Switch displays icons for on and off states in the thumb.',
      ourImplementation: 'Switch with thumbIcon WidgetStateProperty.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Switch with label',
      m3Behavior: 'M3 pairs switch with a text label (layout pattern).',
      ourImplementation: 'Row with Text + Switch — not a switch variant.',
      action: 'Layout pattern',
    ),
  ];

  static const _pending = <PendingVariant>[];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(
      id: 'switch',
      label: 'Switch',
      supportsSelection: true,
      supportsLeadingIcon: false,
    ),
    VariantMatrixRow(
      id: 'switch_with_icon',
      label: 'Switch with icon',
      supportsSelection: true,
      supportsLeadingIcon: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: SwitchComponentPage.meta.title,
      m3SpecUrl: SwitchComponentPage.meta.m3SpecUrl,
      description: SwitchComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: VariantMatrixTable(
        rows: _rows,
        showLeadingIcon: false,
        showTrailingIcon: false,
        selectionState: _onState,
        cellBuilder: _buildCell,
      ),
    );
  }

  bool _isOn(String rowId) => _onState[rowId] ?? false;

  void _setOn(String rowId, bool value) {
    setState(() => _onState[rowId] = value);
  }

  Widget _buildCell(
    BuildContext context,
    VariantMatrixRow row,
    VariantMatrixCell cell,
  ) {
    final isOn = _isOn(row.id);

    return switch (row.id) {
      'switch' => Switch(
        value: isOn,
        onChanged: cell.isEnabled ? (value) => _setOn(row.id, value) : null,
      ),
      'switch_with_icon' => Switch(
        value: isOn,
        onChanged: cell.isEnabled ? (value) => _setOn(row.id, value) : null,
        thumbIcon: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.check, size: 16);
          }
          return const Icon(Icons.close, size: 16);
        }),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
