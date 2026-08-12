import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_typography.dart';
import 'color_theme_builder.dart';
import 'pep_theme_extension.dart';



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
    // M3 splits color (black/white, inherit:true, no weight) from geometry
    // (englishLike/dense/tall). Theme.of later does geometry.merge(textTheme).
    // Family must be chosen from **geometry** weights — black.titleMedium has
    // fontWeight == null, so familyFor used to map every slot to Regular and
    // titleMedium looked identical to bodyLarge.
    final geometry = typography.englishLike;
    final colors =
        brightness == Brightness.light ? typography.black : typography.white;
    final baseTextTheme = geometry.merge(colors);

    // Noto Sans TC assets — one family per weight (Flutter web).
    // Figma kit overrides (TitleLarge w500, BodySmall tracking 0):
    // https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2292-268
    final notoTextTheme = AppFonts.textTheme(baseTextTheme);
    final textTheme = notoTextTheme.copyWith(
      titleLarge: AppFonts.style(
        textStyle: notoTextTheme.titleLarge,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      bodySmall: AppFonts.style(
        textStyle: notoTextTheme.bodySmall,
        letterSpacing: 0,
      ),
    );
    final appTypography = AppTypography.fromTextTheme(textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      typography: typography,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      extensions: [PepThemeExtension.from(colorScheme), appTypography],
      // M3 small top app bar is 64dp; Flutter still defaults to kToolbarHeight (56).
      // Padding: 4dp trailing edge (leading/titleSpacing set per AppBar — see App bars page).
      // https://m3.material.io/components/app-bars/specs
      // Figma: https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2073-130
      appBarTheme: AppBarTheme(
        centerTitle: false,
        toolbarHeight: 64,
        elevation: 0,
        scrolledUnderElevation: 3,
        actionsPadding: const EdgeInsetsDirectional.only(end: 4),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: appTypography.titleSemiLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        toolbarTextStyle: appTypography.titleSemiLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      cardTheme: CardThemeData(

        elevation: 0,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(16),

          side: BorderSide(color: colorScheme.outlineVariant),

        ),

      ),

      chipTheme: ChipThemeData(
        labelStyle: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 18),
        deleteIconColor: colorScheme.onSurface,
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
          // Default = Buttons kit S 40. Prefer PepButtonStyles for XS / M.
          minimumSize: const Size(0, 40),
          maximumSize: const Size(double.infinity, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: textTheme.labelLarge,
          shape: const StadiumBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
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
          minimumSize: const Size(0, 40),
          maximumSize: const Size(double.infinity, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: textTheme.labelLarge,
          shape: const StadiumBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          side: BorderSide(color: colorScheme.outlineVariant),
          minimumSize: const Size(0, 40),
          maximumSize: const Size(double.infinity, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: textTheme.labelLarge,
          shape: const StadiumBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size(0, 40),
          maximumSize: const Size(double.infinity, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: textTheme.labelLarge,
          shape: const StadiumBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          // Default = Buttons kit S 40. App bars set explicit 48×48.
          minimumSize: const Size(40, 40),
          maximumSize: const Size(40, 40),
          fixedSize: const Size(40, 40),
          iconSize: 20,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
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


