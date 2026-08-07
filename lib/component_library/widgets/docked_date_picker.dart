import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kpi_button_styles.dart';
import 'kpi_text_field.dart';
import 'm3_date_picker.dart';

/// Opens a bottom-docked date picker sheet and returns the chosen date.
Future<DateTime?> showDockedDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  var date = initialDate;

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

          return Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                M3DatePicker(
                  value: date,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onChanged: (value) => setSheetState(() => date = value),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        style: KpiButtonStyles.labelStyle(
                          sheetContext,
                          KpiButtonSize.s40,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(sheetContext).pop(date),
                        style: KpiButtonStyles.labelStyle(
                          sheetContext,
                          KpiButtonSize.s40,
                        ),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

/// KPI text field for dates — type directly or open docked picker from trailing icon.
class DatePickerInputField extends StatefulWidget {
  const DatePickerInputField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
  });

  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<DatePickerInputField> createState() => _DatePickerInputFieldState();
}

class _DatePickerInputFieldState extends State<DatePickerInputField> {
  late final TextEditingController _controller;
  bool _editingText = false;

  DateTime get _firstDate => widget.firstDate ?? DateTime(1900);
  DateTime get _lastDate => widget.lastDate ?? DateTime(2100);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _displayDate(widget.value));
  }

  @override
  void didUpdateWidget(DatePickerInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_editingText) return;
    final text = _displayDate(widget.value);
    if (_controller.text != text) {
      _controller.text = text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _displayDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day/${date.year}';
  }

  static DateTime? _parseDate(String raw) {
    final parts = raw.trim().split('/');
    if (parts.length != 3) return null;

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (month == null || day == null || year == null) return null;

    try {
      final parsed = DateTime(year, month, day);
      if (parsed.year != year || parsed.month != month || parsed.day != day) {
        return null;
      }
      return parsed;
    } on ArgumentError {
      return null;
    }
  }

  bool _isInRange(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final first = DateTime(_firstDate.year, _firstDate.month, _firstDate.day);
    final last = DateTime(_lastDate.year, _lastDate.month, _lastDate.day);
    return !day.isBefore(first) && !day.isAfter(last);
  }

  void _applyDate(String raw) {
    _editingText = false;
    final parsed = _parseDate(raw);
    if (parsed != null && _isInRange(parsed)) {
      widget.onChanged(parsed);
    }
  }

  Future<void> _open(BuildContext context) async {
    final initial = _isInRange(widget.value) ? widget.value : DateTime.now();
    final picked = await showDockedDatePicker(
      context,
      initialDate: initial,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null) {
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KpiTextField(
      showExternalLabel: false,
      showHelperText: false,
      hintText: 'MM/DD/YYYY',
      controller: _controller,
      enabled: widget.enabled,
      prefixIcon: const Icon(Icons.calendar_today_outlined),
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_month_outlined),
        style: KpiButtonStyles.iconStyle(KpiButtonSize.s40),
        onPressed: widget.enabled ? () => _open(context) : null,
      ),
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
        LengthLimitingTextInputFormatter(10),
      ],
      onTap: () => _editingText = true,
      onChanged: (raw) {
        if (raw.length == 10) _applyDate(raw);
      },
      onSubmitted: _applyDate,
      onEditingComplete: () => _editingText = false,
    );
  }
}
