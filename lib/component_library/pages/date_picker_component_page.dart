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
        'Single date or date range — type MM/DD/YYYY directly (single) or tap to '
        'pick a range from the month grid.',
  );

  @override
  State<DatePickerComponentPage> createState() => _DatePickerComponentPageState();
}

class _DatePickerComponentPageState extends State<DatePickerComponentPage> {
  DateTime _date = DateTime.now();
  late DateTimeRange _dateRange;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _dateRange = DateTimeRange(
      start: today,
      end: today.add(const Duration(days: 7)),
    );
  }

  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'datePickerTheme',
      spec:
          'RoundedRectangleBorder radius 20. Single date and date range share '
          'the same theme.',
      setupCode: '''
datePickerTheme: DatePickerThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
),
''',
    ),
    ComponentNote(
      topic: 'bottomSheetTheme',
      spec:
          'Docked calendar sheet: showDragHandle, top radius 20. Used by '
          'showDockedDatePicker and showDockedDateRangePicker.',
      setupCode: '''
bottomSheetTheme: BottomSheetThemeData(
  showDragHandle: true,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
),
''',
    ),
    ComponentNote(
      topic: 'DateRangePickerInputField',
      spec:
          'Read-only PEP field; opens docked DateRangePickerDialog '
          '(calendarOnly). Display MM/DD/YYYY – MM/DD/YYYY.',
      setupCode: '''
DateRangePickerInputField(
  value: dateRange,
  onChanged: (range) {},
)
''',
    ),
  ];

  static const _pending = <PendingVariant>[
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
    VariantMatrixRow(
      id: 'docked_range',
      label: 'Date range picker',
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
    return switch (row.id) {
      'docked' => DatePickerInputField(
        value: _date,
        enabled: cell.isEnabled,
        onChanged: (date) => setState(() => _date = date),
      ),
      'docked_range' => DateRangePickerInputField(
        value: _dateRange,
        enabled: cell.isEnabled,
        onChanged: (range) => setState(() => _dateRange = range),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
