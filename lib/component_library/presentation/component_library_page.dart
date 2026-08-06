import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_page_meta.dart';
import '../registry/component_registry.dart';

class ComponentLibraryPage extends StatelessWidget {
  const ComponentLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = ComponentRegistry.sections;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Component library')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _itemCount(sections),
        itemBuilder: (context, index) {
          final item = _resolveItem(sections, index);

          return switch (item) {
            _SectionHeader(:final title, :final isFirst) => Padding(
              padding: EdgeInsets.only(
                top: isFirst ? 0 : 20,
                bottom: 8,
              ),
              child: Text(
                title,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            _SectionEntry(:final page, :final number) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: SizedBox(
                    width: 28,
                    child: Text(
                      '$number',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  title: Text(
                    page.title,
                    style: textTheme.titleMedium,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: page.pageBuilder,
                      ),
                    );
                  },
                ),
              ),
            ),
          };
        },
      ),
    );
  }

  static int _itemCount(List<ComponentLibrarySection> sections) {
    var count = 0;
    for (final section in sections) {
      count += 1 + section.pages.length;
    }
    return count;
  }

  static _LibraryListItem _resolveItem(
    List<ComponentLibrarySection> sections,
    int index,
  ) {
    var cursor = 0;
    for (var sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
      final section = sections[sectionIndex];
      if (cursor == index) {
        return _SectionHeader(
          title: section.title,
          isFirst: sectionIndex == 0,
        );
      }
      cursor++;

      for (var pageIndex = 0; pageIndex < section.pages.length; pageIndex++) {
        if (cursor == index) {
          return _SectionEntry(
            page: section.pages[pageIndex],
            number: pageIndex + 1,
          );
        }
        cursor++;
      }
    }
    throw RangeError.index(index, sections, 'index');
  }
}

sealed class _LibraryListItem {
  const _LibraryListItem();
}

final class _SectionHeader extends _LibraryListItem {
  const _SectionHeader({
    required this.title,
    required this.isFirst,
  });

  final String title;
  final bool isFirst;
}

final class _SectionEntry extends _LibraryListItem {
  const _SectionEntry({
    required this.page,
    required this.number,
  });

  final ComponentPageMeta page;
  final int number;
}
