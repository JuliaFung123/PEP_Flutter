import 'package:flutter/material.dart';

import '../models/component_note.dart';
import 'component_empty_hint.dart';

/// Part 1 — programmer notes comparing our implementation to M3.
class ComponentNoteTable extends StatelessWidget {
  const ComponentNoteTable({super.key, required this.notes});

  final List<ComponentNote> notes;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const ComponentEmptyHint('No notes yet. Document M3 differences here.');
    }

    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    final headerStyle = Theme.of(context).textTheme.labelLarge;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    final actionStyle = Theme.of(context).textTheme.labelLarge;

    return SizedBox(
      width: double.infinity,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1.4),
          2: FlexColumnWidth(1.4),
          3: FlexColumnWidth(1),
        },
        border: TableBorder.all(color: borderColor),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
            TableRow(
              children: [
                _headerCell(
                  child: Text('Variant', style: headerStyle),
                  alignment: Alignment.centerLeft,
                ),
                _headerCell(
                  child: Text('M3 behavior', style: headerStyle),
                ),
                _headerCell(
                  child: Text('Our implementation', style: headerStyle),
                ),
                _headerCell(
                  child: Text('Action', style: headerStyle),
                ),
              ],
            ),
            for (final note in notes)
              TableRow(
                children: [
                  _bodyCell(
                    alignment: Alignment.centerLeft,
                    child: Text(note.variant, style: bodyStyle),
                  ),
                  _bodyCell(child: Text(note.m3Behavior, style: bodyStyle)),
                  _bodyCell(child: Text(note.ourImplementation, style: bodyStyle)),
                  _bodyCell(
                    child: Text(
                      note.action,
                      style: actionStyle?.copyWith(
                        color: _actionColor(context, note.action),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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

  Color _actionColor(BuildContext context, String action) {
    final scheme = Theme.of(context).colorScheme;
    final lower = action.toLowerCase();
    if (lower.contains('create') || lower.contains('new')) {
      return scheme.error;
    }
    if (lower.contains('modify') || lower.contains('theme')) {
      return scheme.tertiary;
    }
    return scheme.primary;
  }
}
