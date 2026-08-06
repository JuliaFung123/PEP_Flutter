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
      variant: 'Input field',
      m3Behavior: 'Compact control opens the picker without leaving the page.',
      ourImplementation:
          'KpiTextField — type hex directly; palette trailing icon opens docked sheet.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Docked sheet',
      m3Behavior: 'Picker anchors to the bottom edge for focused selection.',
      ourImplementation: 'Modal bottom sheet with drag handle, Cancel, and Done.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Saturation / value',
      m3Behavior: '2D plane to pick chroma and brightness for the current hue.',
      ourImplementation: 'Gradient plane with draggable handle.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Hue slider',
      m3Behavior: 'Full spectrum slider to change the base hue.',
      ourImplementation: 'Rainbow track with circular thumb.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Hex input',
      m3Behavior: 'Precise color entry for design handoff.',
      ourImplementation:
          'KpiTextField (no label) with color swatch leading icon and hex value.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Transparency',
      m3Behavior: 'Optional alpha slider in some pickers.',
      ourImplementation: 'Not included — opaque colors only.',
      action: 'Use as-is',
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
