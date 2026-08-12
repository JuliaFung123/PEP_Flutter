/// A single programmer setup note for Part 1 (theme / kit configuration).
class ComponentNote {
  const ComponentNote({
    required this.topic,
    required this.spec,
    this.setupCode,
  });

  /// Theme key or widget name, e.g. `filledButtonTheme`, `ActListItem`.
  final String topic;

  /// What to configure (colors, type, sizes, paddings).
  final String spec;

  /// Optional Dart snippet shown when the note is expanded.
  final String? setupCode;
}
