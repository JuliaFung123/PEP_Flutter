import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pep_flutter/core/theme/app_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('NotoSansTC Medium is heavier than Regular', (tester) async {
    await AppFonts.preload();
    await tester.pumpWidget(
      const MaterialApp(home: SizedBox.shrink()),
    );

    TextPainter paint(FontWeight w) {
      return TextPainter(
        text: TextSpan(
          text: 'English 繁體中文',
          style: TextStyle(
            fontFamily: AppFonts.familyFor(w),
            fontWeight: w,
            fontSize: 32,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
    }

    final r = paint(FontWeight.w400);
    final m = paint(FontWeight.w500);
    final b = paint(FontWeight.w700);
    // ignore: avoid_print
    print('w400=${r.width} w500=${m.width} w700=${b.width}');
    expect(m.width, greaterThan(r.width));
    expect(b.width, greaterThan(m.width));
  });
}
