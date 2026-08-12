import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/timeslot_selection_chip.dart';

/// Figma reference for the custom timeslot selection widget.
class TimeslotSelectionComponentPage extends StatefulWidget {
  const TimeslotSelectionComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'timeslot_selection',
    title: 'timeslot selection',
    m3SpecUrl:
        'https://www.figma.com/design/61SERD0hYvuj7BrwBRv210/PEP_APP-2?node-id=246-5611&t=cri1iqqDqaC4gUf3-4',
    description:
        'A custom booking selector used for choosing date, time, color-coded '
        'slots, or plain text slots. Outlined pill with enabled (toggle '
        'selected), and disabled states.',
    group: ComponentLibraryGroup.layoutBlock,
  );

  @override
  State<TimeslotSelectionComponentPage> createState() =>
      _TimeslotSelectionComponentPageState();
}

class _TimeslotSelectionComponentPageState
    extends State<TimeslotSelectionComponentPage> {
  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'TimeslotSelectionChip',
      spec:
          'Radius 10; pad 12 (date py 8). Selected: inverseSurface / '
          'onInverseSurface; else surface + outlineVariant. Date: bodySmall + '
          'titleSmall. Time/Text/Color: minH 40, titleSmall w600. Swatch 20×20.',
      setupCode: '''
TimeslotSelectionChip.date(
  day: 'Mon',
  date: '3/12',
  status: TimeslotSelectionStatus.selected,
  onPressed: () {},
)
TimeslotSelectionChip.time(
  label: '10:00',
  status: TimeslotSelectionStatus.enabled,
  onPressed: () {},
)
TimeslotSelectionChip.color(
  label: 'Zone A',
  swatchColor: Color(0xFF4CAF50),
  status: TimeslotSelectionStatus.enabled,
  onPressed: () {},
)
TimeslotSelectionChip.text(
  label: 'Morning',
  status: TimeslotSelectionStatus.disabled,
)
''',
    ),
  ];

  static const _pending = <PendingVariant>[
    PendingVariant(
      name: 'Multi-select timeslot groups',
      foundIn: 'Booking flow exploration',
      description:
          'Allows more than one slot to stay active at once inside one section.',
      suggestedAction: 'Create only when product behavior is confirmed',
    ),
  ];

  /// Per-variant selected flag for the Enabled column.
  final Map<String, bool> _selected = {
    'Date': false,
    'Time': false,
    'Color': false,
    'Text': false,
  };

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: TimeslotSelectionComponentPage.meta.title,
      m3SpecUrl: TimeslotSelectionComponentPage.meta.m3SpecUrl,
      description: TimeslotSelectionComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: _TimeslotSelectionTable(
        selected: _selected,
        onToggle: (label) {
          setState(() => _selected[label] = !(_selected[label] ?? false));
        },
      ),
    );
  }
}

class _TimeslotSelectionTable extends StatelessWidget {
  const _TimeslotSelectionTable({
    required this.selected,
    required this.onToggle,
  });

  final Map<String, bool> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    final labelStyle = Theme.of(context).textTheme.labelLarge;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    final rows = <(String, Widget Function(TimeslotSelectionStatus, VoidCallback?))>[
      ('Date', _date),
      ('Time', _time),
      ('Color', _color),
      ('Text', _text),
    ];

    return SizedBox(
      width: double.infinity,
      child: Table(
        border: TableBorder.all(color: borderColor),
        columnWidths: const {
          0: FlexColumnWidth(1.3),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              _cell(
                child: Text('Variant', style: labelStyle),
                alignment: Alignment.centerLeft,
              ),
              _cell(
                child: Text(
                  'Enabled',
                  style: labelStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              _cell(
                child: Text(
                  'Disabled',
                  style: labelStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          for (final row in rows)
            TableRow(
              children: [
                _cell(
                  child: Text(row.$1, style: bodyStyle),
                  alignment: Alignment.centerLeft,
                ),
                _cell(
                  child: row.$2(
                    (selected[row.$1] ?? false)
                        ? TimeslotSelectionStatus.selected
                        : TimeslotSelectionStatus.enabled,
                    () => onToggle(row.$1),
                  ),
                ),
                _cell(
                  child: row.$2(TimeslotSelectionStatus.disabled, null),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static Widget _date(
    TimeslotSelectionStatus status,
    VoidCallback? onPressed,
  ) {
    return TimeslotSelectionChip.date(
      day: 'WED',
      date: '3月4',
      status: status,
      onPressed: onPressed,
    );
  }

  static Widget _time(
    TimeslotSelectionStatus status,
    VoidCallback? onPressed,
  ) {
    return TimeslotSelectionChip.time(
      label: switch (status) {
        TimeslotSelectionStatus.selected => '18:00',
        TimeslotSelectionStatus.disabled => '12:00',
        TimeslotSelectionStatus.enabled => '08:00',
      },
      status: status,
      onPressed: onPressed,
    );
  }

  static Widget _color(
    TimeslotSelectionStatus status,
    VoidCallback? onPressed,
  ) {
    return TimeslotSelectionChip.color(
      label: 'Name',
      swatchColor: status == TimeslotSelectionStatus.disabled
          ? const Color(0xFFB77179)
          : const Color(0xFFC10007),
      status: status,
      onPressed: onPressed,
    );
  }

  static Widget _text(
    TimeslotSelectionStatus status,
    VoidCallback? onPressed,
  ) {
    return TimeslotSelectionChip.text(
      label: 'Name',
      status: status,
      onPressed: onPressed,
    );
  }

  Widget _cell({
    required Widget child,
    Alignment alignment = Alignment.center,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Align(alignment: alignment, child: child),
      ),
    );
  }
}
