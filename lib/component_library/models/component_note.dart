/// A single row in Part 1 (programmer notes vs M3).
class ComponentNote {
  const ComponentNote({
    required this.variant,
    required this.m3Behavior,
    required this.ourImplementation,
    required this.action,
  });

  final String variant;
  final String m3Behavior;
  final String ourImplementation;

  /// e.g. "Use as-is", "Modify theme", "Create new variant"
  final String action;
}
