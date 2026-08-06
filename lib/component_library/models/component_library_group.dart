import 'component_page_meta.dart';

/// Library list grouping for component reference pages.
enum ComponentLibraryGroup {
  theme,
  atom,
}

/// A titled section in the component library list.
class ComponentLibrarySection {
  const ComponentLibrarySection({
    required this.title,
    required this.pages,
  });

  final String title;
  final List<ComponentPageMeta> pages;
}
