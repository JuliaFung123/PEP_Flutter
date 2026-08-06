/// A variant discovered in layouts but not yet in the Part 2 library.
class PendingVariant {
  const PendingVariant({
    required this.name,
    required this.foundIn,
    required this.description,
    this.suggestedAction,
  });

  final String name;
  final String foundIn;
  final String description;
  final String? suggestedAction;
}
