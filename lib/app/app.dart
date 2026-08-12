import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_theme_controller.dart';
import '../core/theme/app_theme_scope.dart';
import '../component_library/presentation/component_library_page.dart';

class PepApp extends StatefulWidget {
  const PepApp({super.key});

  @override
  State<PepApp> createState() => _PepAppState();
}

class _PepAppState extends State<PepApp> {
  late final AppThemeController _themeController = AppThemeController(
    primary: AppColors.seed,
    secondary: AppColors.secondarySeed,
  );

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      controller: _themeController,
      child: ListenableBuilder(
        listenable: _themeController,
        builder: (context, _) {
          final primary = _themeController.primary;
          final secondary = _themeController.secondary;

          return MaterialApp(
            title: 'PEP Flutter',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(primary: primary, secondary: secondary),
            darkTheme: AppTheme.dark(primary: primary, secondary: secondary),
            themeMode: _themeController.themeMode,
            home: const ComponentLibraryPage(),
          );
        },
      ),
    );
  }
}
