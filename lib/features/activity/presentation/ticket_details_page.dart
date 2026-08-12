import 'package:flutter/material.dart';

import '../../../component_library/pages/app_bars_component_page.dart'
    show
        kM3AppBarEdgePadding,
        kM3AppBarFlexibleTitleBottom,
        kM3AppBarIconButtonSize,
        kM3AppBarTitleInset,
        kM3MediumFlexibleHeight,
        kM3ToolbarHeight;
import '../../../component_library/widgets/buy_quantity.dart';
import '../../../component_library/widgets/pep_button_styles.dart';
import '../../../component_library/widgets/ticket_card.dart';
import '../../../component_library/widgets/timeslot_selection_chip.dart';
import '../../../core/theme/app_typography.dart';

/// Ticket details — Figma:
/// https://www.figma.com/design/61SERD0hYvuj7BrwBRv210/PEP_APP-2?node-id=219-19498
class TicketDetailsPage extends StatefulWidget {
  const TicketDetailsPage({super.key});

  @override
  State<TicketDetailsPage> createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  static const _ticketName =
      'name 香港迪士尼樂園 | 迪士尼尊享卡 - 夜間匯演, 8項設施及2項表演通行（包括StellaLou夢想起舞吧）';

  int _quantity = 1;

  static const _prices = [
    TicketCardPrice.cash(amount: '1,234.56'),
    TicketCardPrice.token(amount: '50'),
    TicketCardPrice.coupon(amount: '3'),
  ];

  final List<TimeslotSelectionStatus> _dateStatuses = [
    TimeslotSelectionStatus.enabled,
    TimeslotSelectionStatus.disabled,
    TimeslotSelectionStatus.selected,
    TimeslotSelectionStatus.enabled,
    TimeslotSelectionStatus.enabled,
  ];

  final List<(String, TimeslotSelectionStatus)> _timeSlots = [
    ('08:00', TimeslotSelectionStatus.enabled),
    ('12:00', TimeslotSelectionStatus.disabled),
    ('18:00', TimeslotSelectionStatus.selected),
    ('08:00', TimeslotSelectionStatus.enabled),
    ('08:00', TimeslotSelectionStatus.enabled),
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

  void _selectTime(int index) {
    final current = _timeSlots[index].$2;
    if (current == TimeslotSelectionStatus.disabled) return;
    setState(() {
      for (var i = 0; i < _timeSlots.length; i++) {
        final status = _timeSlots[i].$2;
        if (status == TimeslotSelectionStatus.disabled) continue;
        _timeSlots[i] = (
          _timeSlots[i].$1,
          i == index
              ? TimeslotSelectionStatus.selected
              : TimeslotSelectionStatus.enabled,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final topInset = MediaQuery.paddingOf(context).top;
    // Medium flexible (112) + room for a wrapping HeadlineMedium title.
    const expandedBody = kM3MediumFlexibleHeight + 56;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  toolbarHeight: kM3ToolbarHeight,
                  expandedHeight: expandedBody + topInset,
                  scrolledUnderElevation: 3,
                  backgroundColor: colorScheme.surface,
                  surfaceTintColor: colorScheme.surfaceTint,
                  leadingWidth: kM3AppBarEdgePadding + kM3AppBarIconButtonSize,
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  leading: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: kM3AppBarEdgePadding,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: kM3AppBarIconButtonSize,
                        height: kM3AppBarIconButtonSize,
                        child: IconButton(
                          onPressed: () =>
                              Navigator.maybeOf(context)?.maybePop(),
                          padding: EdgeInsets.zero,
                          style: IconButton.styleFrom(
                            foregroundColor: colorScheme.onSurface,
                            minimumSize: const Size(
                              kM3AppBarIconButtonSize,
                              kM3AppBarIconButtonSize,
                            ),
                            maximumSize: const Size(
                              kM3AppBarIconButtonSize,
                              kM3AppBarIconButtonSize,
                            ),
                            fixedSize: const Size(
                              kM3AppBarIconButtonSize,
                              kM3AppBarIconButtonSize,
                            ),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.standard,
                          ),
                          icon: const Icon(Icons.arrow_back, size: 24),
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: Builder(
                    builder: (context) {
                      final settings = context
                          .dependOnInheritedWidgetOfExactType<
                              FlexibleSpaceBarSettings>();
                      final collapsed = settings == null ||
                          settings.currentExtent <= settings.minExtent + 1;
                      final typography = AppTypography.of(context);

                      return FlexibleSpaceBar(
                        centerTitle: false,
                        expandedTitleScale: 1,
                        titlePadding: EdgeInsetsDirectional.only(
                          start: collapsed
                              ? kM3AppBarEdgePadding + kM3AppBarIconButtonSize
                              : kM3AppBarTitleInset,
                          end: kM3AppBarTitleInset,
                          bottom: collapsed
                              ? (kM3ToolbarHeight - 26) / 2
                              : kM3AppBarFlexibleTitleBottom,
                        ),
                        title: Text(
                          _ticketName,
                          maxLines: collapsed ? 1 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: typography.titleSemiLarge,
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 24,
                          runSpacing: 8,
                          children: const [
                            _FeatureBadge(
                              icon: Icons.highlight_off,
                              label: '不可取消',
                            ),
                            _FeatureBadge(
                              icon: Icons.qr_code,
                              label: '現場請出示 QR code',
                            ),
                            _FeatureBadge(
                              icon: Icons.local_activity_outlined,
                              label: '每人限購99',
                            ),
                            _FeatureBadge(
                              icon: Icons.groups_2_outlined,
                              label: '每票可1人陪同',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'description 賓客可進入「迪士尼星夢光影之旅：星空派對」，「迪士尼好友Live：城堡派對」城堡舞台匯演指定觀賞專區1次，及所選時段優先進入指定劇場表演場次「StellaLou夢想起舞吧」1次。\n\n'
                          '尊享卡持有人可於指定時段優先進入所列設施，減少輪候時間，盡情享受園內精彩體驗。每張尊享卡只適用於購票當日所選時段，並須與有效樂園門票一併使用。\n\n'
                          '使用前請於流動裝置出示電子票券或 QR code 供職員核對。遺失或損毀之票券恕不補發；不可轉讓、不可退款、不可更改日期或時段。如因惡劣天氣、設施維修或活動改期而未能使用，將按樂園當日安排處理。\n\n'
                          '建議預留充足時間前往集合點，遲到或會影響入場次序。陪同人士須另行購票或按指定條款進入。詳情以香港迪士尼樂園官方最新公佈為準。\n\n'
                          '如有查詢，請於購票後前往「我的訂單」查看條款與細則，或聯絡客服了解更多活動及設施開放狀況。',
                          style: textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ColoredBox(
                    color: colorScheme.surfaceContainerLow,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '日期',
                                  style: AppTypography.of(context)
                                      .titleSemiLarge,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                style: PepButtonStyles.labelStyle(
                                  context,
                                  PepButtonSize.xs32,
                                ),
                                iconAlignment: IconAlignment.end,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: PepButtonSize.xs32.trailingIconSize,
                                ),
                                label: const Text('More'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var i = 0;
                                    i < _dateStatuses.length;
                                    i++) ...[
                                  if (i > 0) const SizedBox(width: 10),
                                  TimeslotSelectionChip.date(
                                    day: 'WED',
                                    date: '3月4',
                                    status: _dateStatuses[i],
                                    onPressed: _dateStatuses[i] ==
                                            TimeslotSelectionStatus.disabled
                                        ? null
                                        : () => _selectDate(i),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '時間',
                            style: AppTypography.of(context).titleSemiLarge,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (var i = 0; i < _timeSlots.length; i++)
                                TimeslotSelectionChip.time(
                                  label: _timeSlots[i].$1,
                                  status: _timeSlots[i].$2,
                                  onPressed: _timeSlots[i].$2 ==
                                          TimeslotSelectionStatus.disabled
                                      ? null
                                      : () => _selectTime(i),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: BuyQuantity(
              quantity: _quantity,
              onQuantityChanged: (value) => setState(() => _quantity = value),
              onBuy: () {},
              buyLabel: _quantity == 1 ? 'Buy Now' : 'Reserve',
              maxQuantity: 4,
              availability: const BuyQuantityAvailability(
                remaining: 1,
                waitlistAvailable: 3,
              ),
              prices: _prices,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
