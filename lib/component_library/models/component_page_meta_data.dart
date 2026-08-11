import 'component_library_group.dart';

/// Lightweight metadata for registry entries (const-friendly).
class ComponentPageMetaData {
  const ComponentPageMetaData({
    required this.id,
    required this.title,
    required this.m3SpecUrl,
    required this.description,
    this.sortOrder = 100,
    this.group = ComponentLibraryGroup.atom,
  });

  final String id;
  final String title;
  final String m3SpecUrl;
  final String description;

  /// Lower values appear first in the component library list.
  final int sortOrder;

  /// List section: Theme / Effect / Atom Components / Layout Block.
  final ComponentLibraryGroup group;
}
