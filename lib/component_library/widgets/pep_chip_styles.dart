import 'package:flutter/material.dart';

/// Chip sizes for the PEP kit.
///
/// Default matches M3 (32dp, 8 radius). Small is compact with a fully
/// rounded (stadium) shape.
enum PepChipSize {
  /// M3 default — height 32, corner radius 8, labelLarge, icon 18.
  medium,

  /// Compact — height 24, stadium (fully rounded), labelMedium, icon 16.
  small,
}

extension PepChipSizeX on PepChipSize {
  String get label => switch (this) {
        PepChipSize.medium => 'Default 32',
        PepChipSize.small => 'Small 24',
      };

  double get height => switch (this) {
        PepChipSize.medium => 32,
        PepChipSize.small => 24,
      };

  double get iconSize => switch (this) {
        PepChipSize.medium => 18,
        PepChipSize.small => 16,
      };

  /// M3 input avatar diameter (medium 24, small 18).
  double get avatarSize => switch (this) {
        PepChipSize.medium => 24,
        PepChipSize.small => 18,
      };

  /// Leading / avatar drawer box — Default 24×24 (not full chip height).
  double get leadingSlotSize => switch (this) {
        PepChipSize.medium => 24,
        PepChipSize.small => 18,
      };

  BoxConstraints get avatarBoxConstraints => BoxConstraints.tightFor(
        width: leadingSlotSize,
        height: leadingSlotSize,
      );

  double get cornerRadius => switch (this) {
        PepChipSize.medium => 8,
        // Fully rounded — stadium for the 24dp height.
        PepChipSize.small => 12,
      };

  OutlinedBorder get shape => switch (this) {
        PepChipSize.medium => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
        PepChipSize.small => const StadiumBorder(),
      };

  EdgeInsetsGeometry get padding => switch (this) {
        PepChipSize.medium => const EdgeInsets.symmetric(horizontal: 4),
        PepChipSize.small => const EdgeInsets.symmetric(horizontal: 2),
      };

  EdgeInsetsGeometry get labelPadding => switch (this) {
        PepChipSize.medium => const EdgeInsets.symmetric(horizontal: 8),
        PepChipSize.small => const EdgeInsets.symmetric(horizontal: 6),
      };

  TextStyle? labelStyleOf(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return switch (this) {
      PepChipSize.medium => theme.labelLarge,
      PepChipSize.small => theme.labelMedium,
    };
  }

  String get typographyToken => switch (this) {
        PepChipSize.medium => 'Label Large',
        PepChipSize.small => 'Label Medium',
      };
}

/// Shared [ChipThemeData] overrides for [PepChipSize].
abstract final class PepChipStyles {
  static ChipThemeData themeOf(
    BuildContext context,
    PepChipSize size, {
    ChipThemeData? base,
  }) {
    final colors = Theme.of(context).colorScheme;
    final resolved = base ?? ChipTheme.of(context);
    final label = size.labelStyleOf(context)?.copyWith(color: colors.onSurface);

    return resolved.copyWith(
      padding: size.padding,
      labelPadding: size.labelPadding,
      labelStyle: label,
      secondaryLabelStyle: label,
      iconTheme: IconThemeData(size: size.iconSize, color: colors.onSurface),
      deleteIconColor: colors.onSurface,
      shape: size.shape,
      side: BorderSide(color: colors.outlineVariant),
      avatarBoxConstraints: size.avatarBoxConstraints,
    );
  }
}
