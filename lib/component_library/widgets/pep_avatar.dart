import 'package:flutter/material.dart';

/// Avatar sizes from Figma Flutter UI kit.
///
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2064-617
enum PepAvatarSize {
  /// Chip leading — 24dp.
  size24,

  /// Extra small — 32dp.
  xs32,

  /// Small — 40dp.
  s40,

  /// Medium — 48dp (default).
  m48,

  /// Large — 56dp.
  l56,

  /// Extra large — 72dp.
  xl72,
}

extension PepAvatarSizeX on PepAvatarSize {
  String get label => switch (this) {
        PepAvatarSize.size24 => '24',
        PepAvatarSize.xs32 => 'XS 32',
        PepAvatarSize.s40 => 'S 40',
        PepAvatarSize.m48 => 'M 48',
        PepAvatarSize.l56 => 'L 56',
        PepAvatarSize.xl72 => 'XL 72',
      };

  double get diameter => switch (this) {
        PepAvatarSize.size24 => 24,
        PepAvatarSize.xs32 => 32,
        PepAvatarSize.s40 => 40,
        PepAvatarSize.m48 => 48,
        PepAvatarSize.l56 => 56,
        PepAvatarSize.xl72 => 72,
      };

  double get radius => diameter / 2;

  double get iconSize => switch (this) {
        PepAvatarSize.size24 => 16,
        PepAvatarSize.xs32 => 18,
        PepAvatarSize.s40 => 20,
        PepAvatarSize.m48 => 24,
        PepAvatarSize.l56 => 28,
        PepAvatarSize.xl72 => 36,
      };

  /// Initials typography from Figma (Body Medium → Body Large → Display).
  TextStyle? initialsStyleOf(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return switch (this) {
      PepAvatarSize.size24 ||
      PepAvatarSize.xs32 ||
      PepAvatarSize.s40 ||
      PepAvatarSize.m48 =>
        theme.bodyMedium,
      PepAvatarSize.l56 => theme.bodyLarge?.copyWith(
          fontSize: 24,
          height: 32 / 24,
          letterSpacing: 0,
        ),
      PepAvatarSize.xl72 => theme.bodyLarge?.copyWith(
          fontSize: 28,
          height: 36 / 28,
          letterSpacing: 0,
        ),
    };
  }
}

/// Figma Avatar type: filled primary, tonal secondary, or photo.
enum PepAvatarType {
  /// [ColorScheme.primary] + [ColorScheme.onPrimary] (initials / icon).
  primary,

  /// Soft fill (surfaceContainerHighest) + [ColorScheme.onSurface].
  secondary,

  /// Photo fill (uses [PepAvatar.image]).
  image,
}

/// Circular avatar from Figma kit — Primary / Secondary / Image × sizes.
class PepAvatar extends StatelessWidget {
  const PepAvatar({
    super.key,
    this.size = PepAvatarSize.m48,
    this.type = PepAvatarType.primary,
    this.image,
    this.initials,
    this.icon = Icons.person,
    this.backgroundColor,
    this.foregroundColor,
  }) : assert(
          initials == null || initials.length <= 3,
          'Use at most 3 initials.',
        );

  final PepAvatarSize size;
  final PepAvatarType type;

  /// Required when [type] is [PepAvatarType.image]; ignored otherwise unless set.
  final ImageProvider? image;

  /// 1–3 letters for Primary / Secondary. Falls back to [icon] if empty.
  final String? initials;

  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final effectiveType =
        (type == PepAvatarType.image || image != null) && image != null
            ? PepAvatarType.image
            : type == PepAvatarType.image
                ? PepAvatarType.secondary
                : type;

    final Color bg;
    final Color fg;
    switch (effectiveType) {
      case PepAvatarType.primary:
        bg = backgroundColor ?? colors.primary;
        fg = foregroundColor ?? colors.onPrimary;
      case PepAvatarType.secondary:
        bg = backgroundColor ?? colors.surfaceContainerHighest;
        fg = foregroundColor ?? colors.onSurface;
      case PepAvatarType.image:
        bg = backgroundColor ?? colors.surfaceContainerHighest;
        fg = foregroundColor ?? colors.onSurface;
    }

    if (effectiveType == PepAvatarType.image && image != null) {
      return CircleAvatar(
        radius: size.radius,
        backgroundColor: bg,
        backgroundImage: image,
      );
    }

    final trimmed = initials?.trim() ?? '';
    if (trimmed.isNotEmpty) {
      return CircleAvatar(
        radius: size.radius,
        backgroundColor: bg,
        foregroundColor: fg,
        child: Text(
          trimmed.toUpperCase(),
          style: size.initialsStyleOf(context)?.copyWith(
                color: fg,
                height: 1,
                leadingDistribution: TextLeadingDistribution.even,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return CircleAvatar(
      radius: size.radius,
      backgroundColor: bg,
      foregroundColor: fg,
      child: Icon(icon, size: size.iconSize, color: fg),
    );
  }

  /// Fixed diameter helper for chip slots (maps known sizes).
  static Widget diameter(
    double diameter, {
    Key? key,
    PepAvatarType type = PepAvatarType.secondary,
    ImageProvider? image,
    String? initials,
    IconData icon = Icons.person,
  }) {
    final mapped = PepAvatarSize.values.where((s) => s.diameter == diameter);
    final size =
        mapped.isEmpty ? PepAvatarSize.size24 : mapped.first;
    return PepAvatar(
      key: key,
      size: size,
      type: image != null ? PepAvatarType.image : type,
      image: image,
      initials: initials,
      icon: icon,
    );
  }
}

/// Overlapping avatar stack + optional overflow count (Figma Avatar Group).
///
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2176-13
class PepAvatarGroup extends StatelessWidget {
  const PepAvatarGroup({
    super.key,
    required this.images,
    this.size = PepAvatarSize.m48,
    this.maxVisible = 5,
    this.overflowCount,
  });

  final List<ImageProvider> images;
  final PepAvatarSize size;

  /// How many photo avatars to show before the +N chip.
  final int maxVisible;

  /// When null, uses `images.length - maxVisible` (clamped ≥ 0).
  final int? overflowCount;

  /// Figma: 2dp surface ring + −4 overlap between neighbors.
  static const double _borderWidth = 2;
  static const double _overlap = 4;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final visible = images.take(maxVisible).toList();
    final remaining =
        overflowCount ?? (images.length - visible.length).clamp(0, 999);
    final d = size.diameter;
    final step = d - _overlap;
    final count = visible.length + (remaining > 0 ? 1 : 0);
    if (count == 0) return const SizedBox.shrink();
    final width = d + (count - 1) * step;

    Widget ring(Widget child) {
      return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colors.surface, width: _borderWidth),
        ),
        child: ClipOval(child: child),
      );
    }

    return SizedBox(
      width: width,
      height: d,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * step,
              child: ring(
                Image(
                  image: visible[i],
                  fit: BoxFit.cover,
                  width: d,
                  height: d,
                ),
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: visible.length * step,
              child: Container(
                width: d,
                height: d,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: colors.surface, width: _borderWidth),
                ),
                child: Text(
                  '+$remaining',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface,
                        height: 1,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Avatar + name (+ optional subtitle) row (Figma Avatar Name).
///
/// https://www.figma.com/design/YeqrkvpScSQDy7H6cFRIgZ/Flutter-UI-Material-3?node-id=2324-114
/// Sizes: 32 / 40 / 48. Gap 8. Name = titleMedium; subtitle = bodyMedium (40/48)
/// or bodySmall (32).
class PepAvatarName extends StatelessWidget {
  const PepAvatarName({
    super.key,
    required this.name,
    this.subtitle,
    this.size = PepAvatarSize.m48,
    this.image,
    this.initials,
    this.type = PepAvatarType.image,
  });

  final String name;
  final String? subtitle;
  final PepAvatarSize size;
  final ImageProvider? image;
  final String? initials;
  final PepAvatarType type;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final subtitleStyle = size == PepAvatarSize.xs32
        ? typography.bodySmall?.copyWith(color: colors.onSurfaceVariant)
        : typography.bodyMedium?.copyWith(color: colors.onSurfaceVariant);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PepAvatar(
          size: size,
          type: image != null ? PepAvatarType.image : type,
          image: image,
          initials: initials,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: typography.titleMedium?.copyWith(
                  color: colors.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Text(
                  subtitle!,
                  style: subtitleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
