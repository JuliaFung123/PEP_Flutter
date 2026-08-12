import 'package:flutter/material.dart';

import 'image_source.dart';

/// Thumbnail size for [ActListItem] (Figma List/活動).
const double kActListThumbWidth = 140;
const double kActListThumbHeight = 128;
const double kActListThumbRadius = 16;

/// Outer padding for an [ActListItem] row (no container radius).
/// Horizontal 16, vertical 8.
const EdgeInsets kActListItemPadding = EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 8,
);

/// Activity catalog list row — Figma `List/活動`.
///
/// 140×128 thumb (radius 16), `titleMedium` (max 3 lines), location + date
/// as `bodyMedium`. Container: padding 16×8, no radius.
class ActListItem extends StatelessWidget {
  const ActListItem({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.dateRange,
    this.onTap,
  });

  final String image;
  final String title;
  final String location;
  final String dateRange;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: kActListItemPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(kActListThumbRadius),
                child: SizedBox(
                  width: kActListThumbWidth,
                  height: kActListThumbHeight,
                  child: buildImageSource(image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ActListMetaRow(
                      icon: Icons.location_on_outlined,
                      text: location,
                      style: textTheme.bodyMedium,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    _ActListMetaRow(
                      icon: Icons.calendar_today_outlined,
                      text: dateRange,
                      style: textTheme.bodyMedium,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon + label meta row (location / date).
class _ActListMetaRow extends StatelessWidget {
  const _ActListMetaRow({
    required this.icon,
    required this.text,
    required this.style,
    required this.color,
  });

  final IconData icon;
  final String text;
  final TextStyle? style;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: style?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
