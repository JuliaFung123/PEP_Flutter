import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/theme/app_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Noto Sans TC/SC faces so Chinese Medium/Bold paint (Roboto has no CJK).
  await AppFonts.preload();

  runApp(const KpiApp());
}
