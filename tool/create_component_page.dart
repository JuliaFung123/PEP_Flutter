#!/usr/bin/env dart
// Component page scaffold generator.
//
// Usage:
//   dart run tool/create_component_page.dart <id> <title> <m3_spec_url>
//
// Example:
//   dart run tool/create_component_page.dart buttons "Buttons" "https://m3.material.io/components/buttons/specs"

import 'dart:io';

void main(List<String> args) {
  if (args.length < 3) {
    stderr.writeln(
      'Usage: dart run tool/create_component_page.dart <id> <title> <m3_spec_url>',
    );
    exit(64);
  }

  final id = _sanitizeId(args[0]);
  final title = args[1];
  final m3SpecUrl = args[2];
  final className = _pascalCase(id);
  final projectRoot = _findProjectRoot();
  final pagePath =
      '${projectRoot.path}/lib/component_library/pages/${id}_component_page.dart';
  final registryPath =
      '${projectRoot.path}/lib/component_library/registry/component_registry.dart';

  if (File(pagePath).existsSync()) {
    stderr.writeln('Page already exists: $pagePath');
    exit(1);
  }

  File(pagePath).writeAsStringSync(_pageTemplate(
    id: id,
    title: title,
    className: className,
    m3SpecUrl: m3SpecUrl,
  ));

  _registerInRegistry(
    registryPath: registryPath,
    id: id,
    className: className,
    title: title,
    m3SpecUrl: m3SpecUrl,
  );

  stdout.writeln('Created: lib/component_library/pages/${id}_component_page.dart');
  stdout.writeln('Updated: lib/component_library/registry/component_registry.dart');
  stdout.writeln('');
  stdout.writeln('Next steps:');
  stdout.writeln('  1. Fill Part 1 notes (M3 vs our implementation)');
  stdout.writeln('  2. Define variant rows in Part 2 matrix');
  stdout.writeln('  3. List layout-only items in Part 3 (pending)');
  stdout.writeln('  4. Run: flutter analyze');
}

Directory _findProjectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir;
    final parent = dir.parent;
    if (parent.path == dir.path) {
      stderr.writeln('Could not find pubspec.yaml from ${Directory.current.path}');
      exit(1);
    }
    dir = parent;
  }
}

String _sanitizeId(String raw) {
  return raw
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}

String _pascalCase(String id) {
  return id
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join();
}

String _pageTemplate({
  required String id,
  required String title,
  required String className,
  required String m3SpecUrl,
}) {
  return '''
import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/variant_matrix_table.dart';
import '../widgets/variant_preview.dart';

/// M3 $title reference — $m3SpecUrl
class ${className}ComponentPage extends StatefulWidget {
  const ${className}ComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: '$id',
    title: '$title',
    m3SpecUrl: '$m3SpecUrl',
    description: 'TODO: Describe $title usage in this app.',
  );

  @override
  State<${className}ComponentPage> createState() => _${className}ComponentPageState();
}

class _${className}ComponentPageState extends State<${className}ComponentPage> {
  bool _showLeadingIcon = false;
  bool _showTrailingIcon = false;
  final Map<String, bool> _selection = {};

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'TODO variant',
      m3Behavior: 'M3 behavior from spec',
      ourImplementation: 'Flutter widget or custom',
      action: 'Use as-is / Modify theme / Create variant',
    ),
  ];

  static const _pending = <PendingVariant>[];

  static const _rows = <VariantMatrixRow>[
    VariantMatrixRow(id: 'default', label: 'Default'),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: ${className}ComponentPage.meta.title,
      m3SpecUrl: ${className}ComponentPage.meta.m3SpecUrl,
      description: ${className}ComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VariantIconControls(
            showLeadingIcon: _showLeadingIcon,
            showTrailingIcon: _showTrailingIcon,
            onLeadingChanged: (v) => setState(() => _showLeadingIcon = v),
            onTrailingChanged: (v) => setState(() => _showTrailingIcon = v),
          ),
          const SizedBox(height: 12),
          VariantMatrixTable(
            rows: _rows,
            showLeadingIcon: _showLeadingIcon,
            showTrailingIcon: _showTrailingIcon,
            selectionState: _selection,
            cellBuilder: _buildCell,
          ),
        ],
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    VariantMatrixRow row,
    VariantMatrixCell cell,
  ) {
    // TODO: Render $title variant for each matrix cell.
    return const Text('TODO');
  }
}
''';
}

void _registerInRegistry({
  required String registryPath,
  required String id,
  required String className,
  required String title,
  required String m3SpecUrl,
}) {
  final file = File(registryPath);
  var content = file.readAsStringSync();

  final importLine =
      "import '../pages/${id}_component_page.dart';";
  if (!content.contains(importLine)) {
    content = content.replaceFirst(
      "import '../pages/chips_component_page.dart';",
      "import '../pages/chips_component_page.dart';\n$importLine",
    );
  }

  final entry = '''
    ComponentPageMeta(
      id: ${className}ComponentPage.meta.id,
      title: ${className}ComponentPage.meta.title,
      m3SpecUrl: ${className}ComponentPage.meta.m3SpecUrl,
      description: ${className}ComponentPage.meta.description,
      notes: const [],
      pendingVariants: const [],
      pageBuilder: (_) => const ${className}ComponentPage(),
    ),''';

  content = content.replaceFirst(
    '  static final List<ComponentPageMeta> all = [',
    '  static final List<ComponentPageMeta> all = [\n$entry',
  );

  file.writeAsStringSync(content);
}
