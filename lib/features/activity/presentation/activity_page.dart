import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../component_library/widgets/image_header_widget.dart';
import '../../../component_library/widgets/image_source.dart';
import '../../../component_library/widgets/kpi_button_styles.dart';
import '../../../component_library/widgets/scroll_nav.dart';
import '../../../component_library/widgets/ticket_card.dart';
import '../../../component_library/widgets/timeslot_selection_chip.dart';
import 'ticket_details_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  static const _heroImages = kDemoImageHeaderAssets;
  static const _pageTitle =
      '尖沙咀｜香港麗晶酒店 Regent Hong Kong｜港畔餐廳 Harbourside｜自助午餐・自助晚餐';
  static const _navLabels = ['Ticket', '圖文', 'additional_info'];

  final GlobalKey _titleKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final ScrollNavLinker _navLinker = ScrollNavLinker(sectionCount: 3);

  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateAppBarTitleVisibility);
    _navLinker.addListener(_onNavLinkerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navLinker.attach(
        scrollController: _scrollController,
        pinnedExtent: _pinnedExtent,
      );
      _updateAppBarTitleVisibility();
      _navLinker.syncFromScroll();
    });
  }

  @override
  void dispose() {
    _navLinker
      ..removeListener(_onNavLinkerChanged)
      ..dispose();
    _scrollController
      ..removeListener(_updateAppBarTitleVisibility)
      ..dispose();
    super.dispose();
  }

  void _onNavLinkerChanged() {
    if (mounted) setState(() {});
  }

  double get _stickyNavExtent => 48;

  double _pinnedExtent() {
    return MediaQuery.paddingOf(context).top +
        kToolbarHeight +
        _stickyNavExtent;
  }

  /// Each scroll-nav block is taller than the visible area under the sticky chrome.
  double get _sectionMinHeight {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    return size.height - padding.top - kToolbarHeight - _stickyNavExtent;
  }

  void _updateAppBarTitleVisibility() {
    final titleContext = _titleKey.currentContext;
    if (titleContext == null) return;
    final renderObject = titleContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final titleTop = renderObject.localToGlobal(Offset.zero).dy;
    final appBarBottom = MediaQuery.paddingOf(context).top + kToolbarHeight;
    final shouldShow = titleTop <= appBarBottom;

    if (shouldShow != _showAppBarTitle) {
      setState(() => _showAppBarTitle = shouldShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.sizeOf(context).width;
    final expandedHeight = resolveImageHeaderSize(
      availableWidth: width,
    ).height;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: expandedHeight,
            elevation: 0,
            scrolledUnderElevation: _showAppBarTitle ? 3 : 0,
            forceMaterialTransparency: !_showAppBarTitle,
            backgroundColor: _showAppBarTitle
                ? colorScheme.surface
                : Colors.transparent,
            surfaceTintColor: colorScheme.surfaceTint,
            foregroundColor: _showAppBarTitle
                ? colorScheme.onSurface
                : Colors.white,
            systemOverlayStyle: _showAppBarTitle
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            leadingWidth: 52,
            leading: Padding(
              padding: const EdgeInsetsDirectional.only(start: 4),
              child: Center(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    onPressed: () => Navigator.maybeOf(context)?.maybePop(),
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      foregroundColor: _showAppBarTitle
                          ? colorScheme.onSurface
                          : Colors.white,
                      minimumSize: const Size(48, 48),
                      maximumSize: const Size(48, 48),
                      fixedSize: const Size(48, 48),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.standard,
                    ),
                    icon: const Icon(Icons.arrow_back, size: 24),
                  ),
                ),
              ),
            ),
            title: _showAppBarTitle
                ? Text(
                    _pageTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: ImageHeaderWidget(
                images: _heroImages,
                borderRadius: BorderRadius.zero,
                showBackButton: false,
                expandToParent: true,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ColoredBox(
              color: colorScheme.surface,
              child: Padding(
                key: _titleKey,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_pageTitle, style: textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Text(
                      '3月16-29日限定聯乘：Harbourside x Kanomsiam 聯乘曼谷老字號原創斑蘭甜糕。',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _ScrollNavHeaderDelegate(
              backgroundColor: colorScheme.surface,
              labels: _navLabels,
              selectedIndex: _navLinker.index,
              onDestinationSelected: _navLinker.select,
            ),
          ),
          // Ticket
          SliverToBoxAdapter(
            child: KeyedSubtree(
              key: _navLinker.sectionKeys[0],
              child: ScrollNavSection(
                child: _TicketSection(textTheme: textTheme),
              ),
            ),
          ),
          // 圖文
          SliverToBoxAdapter(
            child: KeyedSubtree(
              key: _navLinker.sectionKeys[1],
              child: ScrollNavSection(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: _sectionMinHeight),
                  child: _StorySection(textTheme: textTheme),
                ),
              ),
            ),
          ),
          // additional_info
          SliverToBoxAdapter(
            child: KeyedSubtree(
              key: _navLinker.sectionKeys[2],
              child: ScrollNavSection(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: _sectionMinHeight),
                  child: _AdditionalInfoSection(textTheme: textTheme),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _ScrollNavHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ScrollNavHeaderDelegate({
    required this.backgroundColor,
    required this.labels,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Color backgroundColor;
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: backgroundColor,
      child: ScrollNav(
        labels: labels,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ScrollNavHeaderDelegate oldDelegate) {
    return backgroundColor != oldDelegate.backgroundColor ||
        selectedIndex != oldDelegate.selectedIndex ||
        labels != oldDelegate.labels ||
        onDestinationSelected != oldDelegate.onDestinationSelected;
  }
}

class _TicketSection extends StatefulWidget {
  const _TicketSection({required this.textTheme});

  final TextTheme textTheme;

  @override
  State<_TicketSection> createState() => _TicketSectionState();
}

class _TicketSectionState extends State<_TicketSection> {
  /// Demo dates: disabled stay off; at most one selected among the rest.
  final List<TimeslotSelectionStatus> _dateStatuses = [
    TimeslotSelectionStatus.disabled,
    TimeslotSelectionStatus.disabled,
    TimeslotSelectionStatus.selected,
    TimeslotSelectionStatus.enabled,
    TimeslotSelectionStatus.enabled,
  ];

  void _selectDate(int index) {
    final current = _dateStatuses[index];
    if (current == TimeslotSelectionStatus.disabled) return;
    setState(() {
      for (var i = 0; i < _dateStatuses.length; i++) {
        if (_dateStatuses[i] == TimeslotSelectionStatus.disabled) continue;
        _dateStatuses[i] = i == index
            ? TimeslotSelectionStatus.selected
            : TimeslotSelectionStatus.enabled;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = widget.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '日期',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              style: KpiButtonStyles.labelStyle(context, KpiButtonSize.s40),
              iconAlignment: IconAlignment.end,
              icon: Icon(
                Icons.keyboard_arrow_right,
                size: KpiButtonSize.s40.trailingIconSize,
              ),
              label: const Text('More'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < _dateStatuses.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                TimeslotSelectionChip.date(
                  day: 'WED',
                  date: '3月4',
                  status: _dateStatuses[i],
                  onPressed: _dateStatuses[i] == TimeslotSelectionStatus.disabled
                      ? null
                      : () => _selectDate(i),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        TicketCard(
          backgroundColor: const Color(0xFFE4F0CC),
          contentBrightness: Brightness.light,
          title: '香港迪士尼樂園 | 1 日門票＋美食餐券',
          prices: const [
            TicketCardPrice.cash(
              amount: '1,234.56',
              originalAmount: '1,234.56',
            ),
            TicketCardPrice.token(amount: '50'),
            TicketCardPrice.coupon(amount: '3'),
          ],
          status: TicketCardStatus.active,
          onTap: () => _openTicketDetails(context),
        ),
        const SizedBox(height: 12),
        const TicketCard(
          backgroundColor: Color(0xFFC0E7EB),
          contentBrightness: Brightness.light,
          title: '冒險家半自助晚餐＋「迪士尼星夢光影之旅：星空派對」觀賞專區（可加購 1 日門票）',
          prices: [TicketCardPrice.coupon(amount: '3')],
          status: TicketCardStatus.inactive,
        ),
        const SizedBox(height: 12),
        TicketCard(
          backgroundColor: const Color(0xFF1A1B26),
          backgroundImage: kDemoImageHeaderAssets.first,
          contentBrightness: Brightness.dark,
          title: '香港迪士尼樂園 | 迪士尼尊享卡 - 夜間匯演、8項設施及2項表演通行',
          prices: const [
            TicketCardPrice.cash(
              amount: '1,234.56',
              originalAmount: '1,234.56',
            ),
            TicketCardPrice.coupon(amount: '3'),
          ],
          status: TicketCardStatus.active,
          onTap: () => _openTicketDetails(context),
        ),
      ],
    );
  }

  void _openTicketDetails(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const TicketDetailsPage()));
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '圖文RichText',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Text(
          '【關於Garinko號】\n'
          '根據擁擠情況，我們可能會將您安排到第二天。屆時，部分第二天的觀光活動將改期至第一天。\n\n'
          '如果流冰距離較遠，乘船時間可能會延長最多90分鐘。屆時，到達飯店的時間可能會延遲。',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            'https://www.figma.com/api/mcp/asset/b984d0fd-b56f-4f16-8fc8-46a2d331deb6.png',
            height: 215,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '【關於流冰】',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          '• 流冰是自然現象，依天氣狀況（潮汐、風向等），可能看不見。\n\n'
          '無論流冰是否到達或離開，行程都會進行。即使流冰尚未抵達岸邊，取消或更改預約時也會收取取消費用。\n\n'
          '• Garinko號的運作不受流冰的有無影響，如果航線上沒有流冰，則為海上觀光旅遊，但不予退款。',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          Text(
            '【補充說明 ${i + 1}】\n'
            '行程可能因天氣、潮汐或現場人流調整。請以當日現場廣播與工作人員指示為準。'
            '如需協助，請聯絡客服或現場服務櫃台。',
            style: textTheme.bodyLarge,
          ),
        ],
      ],
    );
  }
}

class _AdditionalInfoSection extends StatelessWidget {
  const _AdditionalInfoSection({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'pep_activity_z一大堆',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        for (var i = 1; i <= 8; i++) ...[
          if (i > 1) const SizedBox(height: 12),
          Text(
            '$i. 附加資訊段落 — 開放時間、集合地點、注意事項與退改政策說明。'
            '請提前到達集合點，並攜帶有效身份證件。',
            style: textTheme.bodyLarge,
          ),
        ],
      ],
    );
  }
}
