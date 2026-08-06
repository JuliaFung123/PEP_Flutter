import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/docked_date_picker.dart';
import '../widgets/variant_matrix_table.dart';

/// M3 Date pickers — https://m3.material.io/components/date-pickers/specs
class DatePickerComponentPage extends StatefulWidget {
  const DatePickerComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'date_picker',
    title: 'Date picker',
    sortOrder: 4,
    m3SpecUrl: 'https://m3.material.io/components/date-pickers/specs',
    description:
        'Date input with a docked calendar opened from the trailing calendar icon. '
        'Type MM/DD/YYYY directly or pick from the month grid.',
  );

  @override
  State<DatePickerComponentPage> createState() => _DatePickerComponentPageState();
}

class _DatePickerComponentPageState extends State<DatePickerComponentPage> {
  DateTime _date = DateTime.now();

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Input field',
      m3Behavior: 'Compact field for the selected date with a picker affordance.',
      ourImplementation:
          'KpiTextField — type MM/DD/YYYY; trailing calendar icon opens docked sheet.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Docked sheet',
      m3Behavior: 'Calendar anchors to the bottom edge for focused date selection.',
      ourImplementation: 'Modal bottom sheet with drag handle, Cancel, and Done.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Calendar grid',
      m3Behavior: 'Month view with selectable day cells per M3 date picker specs.',
      ourImplementation: 'CalendarDatePicker in a rounded container.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Date range',
      m3Behavior: 'Optional start/end selection for ranges.',
      ourImplementation: 'Single date only in this atom.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Dialog picker',
      m3Behavior: 'Modal date picker dialog for compact layouts.',
      ourImplementation:
          'Use showDatePicker — inherits DatePickerThemeData from AppTheme.',
      action: 'Use showDatePicker when needed',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Date range picker',
      foundIn: 'M3 date pickers',
      description: 'Select start and end dates — not in this atom.',
      suggestedAction: 'Add when product needs ranges',
    ),
    PendingVariant(
      name: 'Full-screen picker',
      foundIn: 'M3 date pickers',
      description: 'Full-screen modal on compact widths.',
      suggestedAction: 'Use showDatePicker if needed',
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
      title: DatePickerComponentPage.meta.title,
      m3SpecUrl: DatePickerComponentPage.meta.m3SpecUrl,
      description: DatePickerComponentPage.meta.description,
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
    return DatePickerInputField(
      value: _date,
      enabled: cell.isEnabled,
      onChanged: (date) => setState(() => _date = date),
    );
  }
}
