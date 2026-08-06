import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';



import 'app_colors.dart';

import 'color_theme_builder.dart';

import 'kpi_theme_extension.dart';



abstract final class AppTheme {

  static ThemeData light({

    Color primary = AppColors.seed,

    Color secondary = AppColors.secondarySeed,

  }) =>

      _buildTheme(Brightness.light, primary: primary, secondary: secondary);



  static ThemeData dark({

    Color primary = AppColors.seed,

    Color secondary = AppColors.secondarySeed,

  }) =>

      _buildTheme(Brightness.dark, primary: primary, secondary: secondary);



  static ThemeData _buildTheme(

    Brightness brightness, {

    required Color primary,

    required Color secondary,

  }) {

    final colorScheme = ColorThemeBuilder.build(

      primary: primary,

      secondary: secondary,

      brightness: brightness,

    );



    final typography = Typography.material2021(platform: defaultTargetPlatform);

    final baseTextTheme =

        brightness == Brightness.light ? typography.black : typography.white;

    final textTheme = GoogleFonts.interTextTheme(baseTextTheme);



    return ThemeData(

      useMaterial3: true,

      brightness: brightness,

      colorScheme: colorScheme,

      typography: typography,

      textTheme: textTheme,

      primaryTextTheme: textTheme,

      extensions: [KpiThemeExtension.from(colorScheme)],

      appBarTheme: AppBarTheme(

        centerTitle: false,

        elevation: 0,

        scrolledUnderElevation: 3,

        backgroundColor: colorScheme.surface,

        foregroundColor: colorScheme.onSurface,

        titleTextStyle: textTheme.titleLarge,

      ),

      cardTheme: CardThemeData(

        elevation: 0,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(16),

          side: BorderSide(color: colorScheme.outlineVariant),

        ),

      ),

      chipTheme: ChipThemeData(

        labelStyle: textTheme.labelLarge,

        side: BorderSide(color: colorScheme.outlineVariant),

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(8),

        ),

      ),

      elevatedButtonTheme: ElevatedButtonThemeData(

        style: ElevatedButton.styleFrom(

          backgroundColor: colorScheme.surfaceContainerLow,

          foregroundColor: colorScheme.primary,

          disabledBackgroundColor:

              colorScheme.onSurface.withValues(alpha: 0.12),

          disabledForegroundColor:

              colorScheme.onSurface.withValues(alpha: 0.38),

          minimumSize: const Size(64, 56),

          textStyle: textTheme.labelLarge,

          shape: const StadiumBorder(),

          elevation: 1,

        ),

      ),

      filledButtonTheme: FilledButtonThemeData(

        style: FilledButton.styleFrom(

          backgroundColor: colorScheme.primary,

          foregroundColor: colorScheme.onPrimary,

          disabledBackgroundColor:

              colorScheme.onSurface.withValues(alpha: 0.12),

          disabledForegroundColor:

              colorScheme.onSurface.withValues(alpha: 0.38),

          minimumSize: const Size(64, 56),

          textStyle: textTheme.labelLarge,

          shape: const StadiumBorder(),

        ),

      ),

      outlinedButtonTheme: OutlinedButtonThemeData(

        style: OutlinedButton.styleFrom(

          foregroundColor: colorScheme.onSurfaceVariant,

          disabledForegroundColor:

              colorScheme.onSurface.withValues(alpha: 0.38),

          side: BorderSide(color: colorScheme.outlineVariant),

          minimumSize: const Size(64, 56),

          textStyle: textTheme.labelLarge,

          shape: const StadiumBorder(),

        ),

      ),

      textButtonTheme: TextButtonThemeData(

        style: TextButton.styleFrom(

          foregroundColor: colorScheme.primary,

          disabledForegroundColor:

              colorScheme.onSurface.withValues(alpha: 0.38),

          textStyle: textTheme.labelLarge,

          shape: const StadiumBorder(),

        ),

      ),

      datePickerTheme: DatePickerThemeData(

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(20),

        ),

      ),

      bottomSheetTheme: BottomSheetThemeData(

        showDragHandle: true,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

        ),

      ),

      listTileTheme: ListTileThemeData(

        titleTextStyle: textTheme.titleMedium,

        subtitleTextStyle: textTheme.bodyMedium,

      ),

      navigationBarTheme: NavigationBarThemeData(

        elevation: 0,

        height: 72,

        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),

        indicatorShape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(16),

        ),

      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(

        elevation: 2,

        extendedTextStyle: textTheme.labelLarge,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(16),

        ),

      ),

      snackBarTheme: SnackBarThemeData(

        behavior: SnackBarBehavior.floating,

        contentTextStyle: textTheme.bodyMedium,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(12),

        ),

      ),

    );

  }

}


