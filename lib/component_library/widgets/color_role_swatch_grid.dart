import 'package:flutter/material.dart';

/// Displays generated [ColorScheme] roles in labeled groups.
class ColorRoleSwatchGrid extends StatelessWidget {
  const ColorRoleSwatchGrid({super.key, required this.scheme});

  final ColorScheme scheme;

  static const _groups = <_ColorRoleGroup>[
    _ColorRoleGroup('Primary', [
      _ColorRole('primary', _Role.primary),
      _ColorRole('onPrimary', _Role.onPrimary),
      _ColorRole('primaryContainer', _Role.primaryContainer),
      _ColorRole('onPrimaryContainer', _Role.onPrimaryContainer),
    ]),
    _ColorRoleGroup('Secondary', [
      _ColorRole('secondary', _Role.secondary),
      _ColorRole('onSecondary', _Role.onSecondary),
      _ColorRole('secondaryContainer', _Role.secondaryContainer),
      _ColorRole('onSecondaryContainer', _Role.onSecondaryContainer),
    ]),
    _ColorRoleGroup('Tertiary', [
      _ColorRole('tertiary', _Role.tertiary),
      _ColorRole('onTertiary', _Role.onTertiary),
      _ColorRole('tertiaryContainer', _Role.tertiaryContainer),
      _ColorRole('onTertiaryContainer', _Role.onTertiaryContainer),
    ]),
    _ColorRoleGroup('Error', [
      _ColorRole('error', _Role.error),
      _ColorRole('onError', _Role.onError),
      _ColorRole('errorContainer', _Role.errorContainer),
      _ColorRole('onErrorContainer', _Role.onErrorContainer),
    ]),
    _ColorRoleGroup('Surface', [
      _ColorRole('surface', _Role.surface),
      _ColorRole('onSurface', _Role.onSurface),
      _ColorRole('onSurfaceVariant', _Role.onSurfaceVariant),
      _ColorRole('outline', _Role.outline),
      _ColorRole('outlineVariant', _Role.outlineVariant),
    ]),
    _ColorRoleGroup('Surface containers', [
      _ColorRole('surfaceDim', _Role.surfaceDim),
      _ColorRole('surfaceBright', _Role.surfaceBright),
      _ColorRole('surfaceContainerLowest', _Role.surfaceContainerLowest),
      _ColorRole('surfaceContainerLow', _Role.surfaceContainerLow),
      _ColorRole('surfaceContainer', _Role.surfaceContainer),
      _ColorRole('surfaceContainerHigh', _Role.surfaceContainerHigh),
      _ColorRole('surfaceContainerHighest', _Role.surfaceContainerHighest),
    ]),
    _ColorRoleGroup('Other', [
      _ColorRole('inverseSurface', _Role.inverseSurface),
      _ColorRole('onInverseSurface', _Role.onInverseSurface),
      _ColorRole('inversePrimary', _Role.inversePrimary),
      _ColorRole('shadow', _Role.shadow),
      _ColorRole('scrim', _Role.scrim),
      _ColorRole('surfaceTint', _Role.surfaceTint),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in _groups) ...[
          Text(group.title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 900 ? 4 : width >= 600 ? 3 : 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final role in group.roles)
                    SizedBox(
                      width: (width - (columns - 1) * 8) / columns,
                      child: _SwatchTile(
                        label: role.label,
                        color: role.resolve(scheme),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _SwatchTile extends StatelessWidget {
  const _SwatchTile({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final onColor = color.computeLuminance() > 0.55 ? Colors.black : Colors.white;
    final hex = (color.toARGB32() & 0xFFFFFF)
        .toRadixString(16)
        .padLeft(6, '0')
        .toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            ),
            alignment: Alignment.center,
            child: Text(
              '#$hex',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: onColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
        ],
      ),
    );
  }
}

class _ColorRoleGroup {
  const _ColorRoleGroup(this.title, this.roles);

  final String title;
  final List<_ColorRole> roles;
}

class _ColorRole {
  const _ColorRole(this.label, this.role);

  final String label;
  final _Role role;

  Color resolve(ColorScheme scheme) => role.resolve(scheme);
}

enum _Role {
  primary,
  onPrimary,
  primaryContainer,
  onPrimaryContainer,
  secondary,
  onSecondary,
  secondaryContainer,
  onSecondaryContainer,
  tertiary,
  onTertiary,
  tertiaryContainer,
  onTertiaryContainer,
  error,
  onError,
  errorContainer,
  onErrorContainer,
  surface,
  onSurface,
  onSurfaceVariant,
  outline,
  outlineVariant,
  surfaceDim,
  surfaceBright,
  surfaceContainerLowest,
  surfaceContainerLow,
  surfaceContainer,
  surfaceContainerHigh,
  surfaceContainerHighest,
  inverseSurface,
  onInverseSurface,
  inversePrimary,
  shadow,
  scrim,
  surfaceTint;

  Color resolve(ColorScheme scheme) => switch (this) {
    _Role.primary => scheme.primary,
    _Role.onPrimary => scheme.onPrimary,
    _Role.primaryContainer => scheme.primaryContainer,
    _Role.onPrimaryContainer => scheme.onPrimaryContainer,
    _Role.secondary => scheme.secondary,
    _Role.onSecondary => scheme.onSecondary,
    _Role.secondaryContainer => scheme.secondaryContainer,
    _Role.onSecondaryContainer => scheme.onSecondaryContainer,
    _Role.tertiary => scheme.tertiary,
    _Role.onTertiary => scheme.onTertiary,
    _Role.tertiaryContainer => scheme.tertiaryContainer,
    _Role.onTertiaryContainer => scheme.onTertiaryContainer,
    _Role.error => scheme.error,
    _Role.onError => scheme.onError,
    _Role.errorContainer => scheme.errorContainer,
    _Role.onErrorContainer => scheme.onErrorContainer,
    _Role.surface => scheme.surface,
    _Role.onSurface => scheme.onSurface,
    _Role.onSurfaceVariant => scheme.onSurfaceVariant,
    _Role.outline => scheme.outline,
    _Role.outlineVariant => scheme.outlineVariant,
    _Role.surfaceDim => scheme.surfaceDim,
    _Role.surfaceBright => scheme.surfaceBright,
    _Role.surfaceContainerLowest => scheme.surfaceContainerLowest,
    _Role.surfaceContainerLow => scheme.surfaceContainerLow,
    _Role.surfaceContainer => scheme.surfaceContainer,
    _Role.surfaceContainerHigh => scheme.surfaceContainerHigh,
    _Role.surfaceContainerHighest => scheme.surfaceContainerHighest,
    _Role.inverseSurface => scheme.inverseSurface,
    _Role.onInverseSurface => scheme.onInverseSurface,
    _Role.inversePrimary => scheme.inversePrimary,
    _Role.shadow => scheme.shadow,
    _Role.scrim => scheme.scrim,
    _Role.surfaceTint => scheme.surfaceTint,
  };
}
