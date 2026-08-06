import 'package:flutter/material.dart';

import '../models/pending_variant.dart';
import 'component_empty_hint.dart';

/// Part 3 — variants found in layouts but not yet promoted to Part 2.
class PendingVariantsTable extends StatelessWidget {
  const PendingVariantsTable({super.key, required this.items});

  final List<PendingVariant> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const ComponentEmptyHint(
        'No pending variants. Layout-only elements will appear here.',
      );
    }

    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    final headerStyle = Theme.of(context).textTheme.labelLarge;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return SizedBox(
      width: double.infinity,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1.4),
          3: FlexColumnWidth(1),
        },
        border: TableBorder.all(color: borderColor),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
            TableRow(
              children: [
                _headerCell(
                  child: Text('Name', style: headerStyle),
                  alignment: Alignment.centerLeft,
                ),
                _headerCell(
                  child: Text('Found in', style: headerStyle),
                ),
                _headerCell(
                  child: Text('Description', style: headerStyle),
                ),
                _headerCell(
                  child: Text('Suggested action', style: headerStyle),
                ),
              ],
            ),
            for (final item in items)
              TableRow(
                children: [
                  _bodyCell(
                    alignment: Alignment.centerLeft,
                    child: Text(item.name, style: bodyStyle),
                  ),
                  _bodyCell(child: Text(item.foundIn, style: bodyStyle)),
                  _bodyCell(child: Text(item.description, style: bodyStyle)),
                  _bodyCell(child: Text(item.suggestedAction ?? '—', style: bodyStyle)),
                ],
              ),
        ],
      ),
    );
  }

  Widget _headerCell({
    required Widget child,
    Alignment alignment = Alignment.center,
  }) {
    return TableCell(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        alignment: alignment,
        child: child,
      ),
    );
  }

  Widget _bodyCell({
    required Widget child,
    Alignment alignment = Alignment.center,
  }) {
    return TableCell(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        alignment: alignment,
        child: child,
      ),
    );
  }
}
