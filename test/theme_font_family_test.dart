import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pep_flutter/core/theme/app_theme.dart';

void main() {
  test('theme slots keep per-weight families', () {
    final theme = AppTheme.light();
    // ThemeData before localize — still should have geometry baked in
    final tm = theme.textTheme.titleMedium!;
    final bl = theme.textTheme.bodyLarge!;
    final ts = theme.textTheme.titleSmall!;
    final bm = theme.textTheme.bodyMedium!;
    print('titleMedium family=${tm.fontFamily} weight=${tm.fontWeight} size=${tm.fontSize}');
    print('bodyLarge   family=${bl.fontFamily} weight=${bl.fontWeight} size=${bl.fontSize}');
    print('titleSmall  family=${ts.fontFamily} weight=${ts.fontWeight}');
    print('bodyMedium  family=${bm.fontFamily} weight=${bm.fontWeight}');
    expect(tm.fontWeight, FontWeight.w500);
    expect(bl.fontWeight, FontWeight.w400);
    expect(tm.fontFamily, 'NotoSansTCMedium');
    expect(bl.fontFamily, 'NotoSansTC');
    expect(ts.fontFamily, 'NotoSansTCMedium');
    expect(bm.fontFamily, 'NotoSansTC');
  });

  testWidgets('localized Theme.of keeps Medium family', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) {
            final tm = Theme.of(context).textTheme.titleMedium!;
            final bl = Theme.of(context).textTheme.bodyLarge!;
            expect(tm.fontFamily, 'NotoSansTCMedium');
            expect(bl.fontFamily, 'NotoSansTC');
            expect(tm.fontWeight, FontWeight.w500);
            expect(bl.fontWeight, FontWeight.w400);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
