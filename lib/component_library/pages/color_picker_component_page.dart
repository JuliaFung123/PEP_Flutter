import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/docked_color_picker.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Color picker reference — saturation/value plane + hue slider.
class ColorPickerComponentPage extends StatefulWidget {
  const ColorPickerComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'color_picker',
    title: 'Color picker',
    sortOrder: 3,
    m3SpecUrl: 'https://m3.material.io/styles/color/overview',
    description:
        'Hex color input with a docked picker opened from the trailing palette icon. '
        'Saturation/value plane, hue slider, and hex input — no transparency.',
  );

  @override
  State<ColorPickerComponentPage> createState() => _ColorPickerComponentPageState();
}

class _ColorPickerComponentPageState extends State<ColorPickerComponentPage> {
  Color _color = AppColors.seed;

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'M3ColorPicker / PepTextField',
      spec:
          'Hex field + palette icon; docked bottomSheetTheme (drag handle, '
          'radius 20). Opaque only — no alpha. SV plane + hue slider.',
      setupCode: '''
// Field opens modal bottom sheet (inherits bottomSheetTheme).
showModalBottomSheet(
  context: context,
  showDragHandle: true,
  builder: (_) => /* picker sheet */,
);
''',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Eyedropper',
      foundIn: 'Design tools',
      description: 'Sample color from screen — not in this atom.',
      suggestedAction: 'Platform plugin if needed',
    ),
  ];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(
      id: 'docked',
      label: 'Docked picker',
      supportsLeadingIcon: false,
      supportsTrailingIcon: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: ColorPickerComponentPage.meta.title,
      m3SpecUrl: ColorPickerComponentPage.meta.m3SpecUrl,
      description: ColorPickerComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
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
    return ColorPickerInputField(
      value: _color,
      enabled: cell.isEnabled,
      onChanged: (color) => setState(() => _color = color),
    );
  }
}
