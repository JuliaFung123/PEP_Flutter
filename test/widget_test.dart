import 'package:flutter_test/flutter_test.dart';
import 'package:kpi_flutter/app/app.dart';
import 'package:kpi_flutter/component_library/models/component_library_group.dart';
import 'package:kpi_flutter/component_library/registry/component_registry.dart';

void main() {
  testWidgets('Component library lists grouped atom pages', (WidgetTester tester) async {
    await tester.pumpWidget(const KpiApp());

    expect(find.text('Component library'), findsOneWidget);
    expect(ComponentRegistry.all.length, 15);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Atom Components'), findsOneWidget);
    expect(find.text('Color theme'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);
    expect(find.text('App bars'), findsOneWidget);

    final sections = ComponentRegistry.sections;
    expect(sections.length, 2);
    expect(sections[0].title, 'Theme');
    expect(sections[0].pages.map((page) => page.title), [
      'Color theme',
      'Typography',
    ]);
    expect(sections[1].title, 'Atom Components');
    expect(sections[1].pages.first.title, 'App bars');
    final atomTitles = sections[1].pages.map((page) => page.title).toList();
    expect(atomTitles, [...atomTitles]..sort());
    expect(
      sections[1].pages.every((page) => page.group == ComponentLibraryGroup.atom),
      isTrue,
    );
  });
}
