import 'package:flutter/material.dart';

/// In-page section navigation that **looks like primary Tabs** but scrolls a
/// single page to the related block instead of switching [TabBarView]s.
class ScrollNav extends StatefulWidget implements PreferredSizeWidget {
  const ScrollNav({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : assert(labels.length > 0),
       assert(selectedIndex >= 0);

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  State<ScrollNav> createState() => _ScrollNavState();
}

class _ScrollNavState extends State<ScrollNav>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.labels.length,
      vsync: this,
      initialIndex: widget.selectedIndex.clamp(0, widget.labels.length - 1),
    );
  }

  @override
  void didUpdateWidget(covariant ScrollNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.labels.length != widget.labels.length) {
      _controller.dispose();
      _controller = TabController(
        length: widget.labels.length,
        vsync: this,
        initialIndex: widget.selectedIndex.clamp(0, widget.labels.length - 1),
      );
      return;
    }
    final next = widget.selectedIndex.clamp(0, widget.labels.length - 1);
    if (_controller.index != next) {
      _controller.animateTo(next);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _controller,
      tabs: [for (final label in widget.labels) Tab(text: label)],
      onTap: widget.onDestinationSelected,
    );
  }
}

/// Content block under [ScrollNav] — flat: no background, outline, or radius.
class ScrollNavSection extends StatelessWidget {
  const ScrollNavSection({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 20, 16, 24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

/// Keeps [ScrollNav] selection in sync with section positions:
/// - tap tab → scroll to section
/// - scroll → update active tab
class ScrollNavLinker extends ChangeNotifier {
  ScrollNavLinker({required int sectionCount})
    : assert(sectionCount > 0),
      sectionKeys = List<GlobalKey>.generate(sectionCount, (_) => GlobalKey());

  final List<GlobalKey> sectionKeys;

  ScrollController? _scrollController;
  double Function()? _pinnedExtentBuilder;
  int _index = 0;
  bool _programmatic = false;

  int get index => _index;
  int get sectionCount => sectionKeys.length;

  /// [pinnedExtent] is the global Y where section tops should dock (below
  /// sticky chrome), or the top of the scroll viewport when the nav sits
  /// outside the scrollable.
  void attach({
    required ScrollController scrollController,
    required double Function() pinnedExtent,
  }) {
    if (_scrollController != null) {
      _scrollController!.removeListener(_onScroll);
    }
    _scrollController = scrollController;
    _pinnedExtentBuilder = pinnedExtent;
    _scrollController!.addListener(_onScroll);
  }

  void detach() {
    _scrollController?.removeListener(_onScroll);
    _scrollController = null;
    _pinnedExtentBuilder = null;
  }

  @override
  void dispose() {
    detach();
    super.dispose();
  }

  void _onScroll() {
    if (_programmatic) return;
    syncFromScroll();
  }

  /// Call after layout (e.g. post-frame) or when scroll ends.
  void syncFromScroll() {
    final pinned = _pinnedExtentBuilder?.call();
    if (pinned == null) return;

    var active = 0;
    for (var i = 0; i < sectionKeys.length; i++) {
      final box =
          sectionKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final top = box.localToGlobal(Offset.zero).dy;
      if (top <= pinned + 12) {
        active = i;
      }
    }
    if (active != _index) {
      _index = active;
      notifyListeners();
    }
  }

  Future<void> select(int index) async {
    if (index < 0 || index >= sectionKeys.length) return;

    _index = index;
    _programmatic = true;
    notifyListeners();

    final scroll = _scrollController;
    final pinned = _pinnedExtentBuilder?.call();
    final sectionContext = sectionKeys[index].currentContext;

    if (scroll != null &&
        scroll.hasClients &&
        pinned != null &&
        sectionContext != null) {
      final renderObject = sectionContext.findRenderObject();
      if (renderObject != null && renderObject.attached) {
        final target = _targetOffset(
          scroll: scroll,
          renderObject: renderObject,
          pinnedExtent: pinned,
        );
        await scroll.animateTo(
          target,
          duration: const Duration(milliseconds: 360),
          curve: Curves.easeInOut,
        );
      }
    }

    _programmatic = false;
    syncFromScroll();
    notifyListeners();
  }

  double _targetOffset({
    required ScrollController scroll,
    required RenderObject renderObject,
    required double pinnedExtent,
  }) {
    final box = renderObject as RenderBox;
    final top = box.localToGlobal(Offset.zero).dy;
    return (scroll.offset + top - pinnedExtent).clamp(
      0.0,
      scroll.position.maxScrollExtent,
    );
  }
}
