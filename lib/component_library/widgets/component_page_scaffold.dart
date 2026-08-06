import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/component_note.dart';
import '../models/pending_variant.dart';
import 'component_note_table.dart';
import 'component_section.dart';
import 'pending_variants_table.dart';

/// Shell for all component reference pages (Parts 1–3).
class ComponentPageScaffold extends StatelessWidget {
  const ComponentPageScaffold({
    super.key,
    required this.title,
    required this.m3SpecUrl,
    required this.description,
    required this.notes,
    required this.pendingVariants,
    required this.variantsSection,
  });

  final String title;
  final String m3SpecUrl;
  final String description;
  final List<ComponentNote> notes;
  final List<PendingVariant> pendingVariants;
  final Widget variantsSection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton.icon(
            onPressed: () => _openSpec(m3SpecUrl),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: Text('M3 spec', style: Theme.of(context).textTheme.labelLarge),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          ComponentSection(
            title: '1. Note',
            subtitle:
                'Programmer reference — differences from M3. '
                'Decide whether to use as-is, modify, or create a variant.',
            child: ComponentNoteTable(notes: notes),
          ),
          const SizedBox(height: 32),
          ComponentSection(
            title: '2. Variants',
            subtitle:
                'Component library. All layouts must pick variants from here. '
                'Use switches above the matrix to preview leading and trailing icons.',
            child: variantsSection,
          ),
          const SizedBox(height: 32),
          ComponentSection(
            title: '3. Variants (pending)',
            subtitle:
                'Layout-only elements not yet in Part 2. '
                'Promote to Part 2 when approved, then add a note in Part 1.',
            child: PendingVariantsTable(items: pendingVariants),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _openSpec(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
