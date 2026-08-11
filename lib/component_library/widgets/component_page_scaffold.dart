import 'package:flutter/material.dart';

import '../../core/theme/app_theme_scope.dart';
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

  /// Spec / docs URL from page meta (kept for registry; not shown in the app bar).
  final String m3SpecUrl;
  final String description;
  final List<ComponentNote> notes;
  final List<PendingVariant> pendingVariants;
  final Widget variantsSection;

  @override
  Widget build(BuildContext context) {
    final themeController = AppThemeScope.of(context);
    final isDark = themeController.isDark(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.light_mode_outlined,
                  size: 20,
                  color: isDark
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.primary,
                ),
                Switch(
                  value: isDark,
                  onChanged: themeController.setDarkMode,
                ),
                Icon(
                  Icons.dark_mode_outlined,
                  size: 20,
                  color: isDark
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
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
}
