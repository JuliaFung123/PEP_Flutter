import 'package:flutter/material.dart';

/// M3 docked calendar — month grid for picking a single date.
///
/// Spec: https://m3.material.io/components/date-pickers/specs
class M3DatePicker extends StatelessWidget {
  const M3DatePicker({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
  });

  final DateTime value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: CalendarDatePicker(
          initialDate: value,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: DateTime.now(),
          onDateChanged: onChanged,
        ),
      ),
    );
  }
}
