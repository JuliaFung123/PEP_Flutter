import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/component_note.dart';
import 'component_empty_hint.dart';

/// Part 1 — theme / kit setup notes with expandable code.
class ComponentNoteTable extends StatelessWidget {
  const ComponentNoteTable({super.key, required this.notes});

  final List<ComponentNote> notes;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const ComponentEmptyHint('No theme/setup notes yet.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < notes.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _NoteExpansionTile(note: notes[i]),
        ],
      ],
    );
  }
}

class _NoteExpansionTile extends StatelessWidget {
  const _NoteExpansionTile({required this.note});

  final ComponentNote note;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final code = note.setupCode?.trim();
    final hasCode = code != null && code.isNotEmpty;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            note.topic,
            style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              note.spec,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          children: [
            if (hasCode)
              _SetupCodeBlock(code: code)
            else
              Text(
                'No theme slot — use the widget / kit API only.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SetupCodeBlock extends StatelessWidget {
  const _SetupCodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 40, 12),
            child: SelectableText(
              code,
              style: textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              tooltip: 'Copy',
              visualDensity: VisualDensity.compact,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied setup code'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(
                Icons.copy_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
