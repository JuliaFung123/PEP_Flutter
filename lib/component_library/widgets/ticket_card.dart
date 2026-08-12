import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';
import 'image_source.dart';

/// Availability / interactivity for [TicketCard].
enum TicketCardStatus {
  /// Full opacity; responds to [TicketCard.onTap].
  active,

  /// ≈50% opacity; taps are ignored.
  inactive,
}

/// Client-configured price kinds commonly shown on a ticket option.
enum TicketCardPriceType { cash, token, coupon }

/// One price line. Which types appear depends on client settings from the backend.
class TicketCardPrice {
  const TicketCardPrice({
    required this.type,
    required this.amount,
    this.originalAmount,
    this.currencyLabel = 'HK\$',
    this.fromSuffix = ' 起',
  });

  const TicketCardPrice.cash({
    required this.amount,
    this.originalAmount,
    this.currencyLabel = 'HK\$',
    this.fromSuffix = ' 起',
  }) : type = TicketCardPriceType.cash;

  const TicketCardPrice.token({
    required this.amount,
    this.originalAmount,
    this.fromSuffix = ' 起',
  }) : type = TicketCardPriceType.token,
       currencyLabel = '';

  const TicketCardPrice.coupon({
    required this.amount,
    this.originalAmount,
    this.fromSuffix = ' 起',
  }) : type = TicketCardPriceType.coupon,
       currencyLabel = '';

  final TicketCardPriceType type;
  final String amount;

  /// Optional original / list price — shown with strikethrough.
  final String? originalAmount;
  final String currencyLabel;
  final String fromSuffix;
}

/// Activity / booking ticket option card (approved Layout Block library).
///
/// Background ([backgroundColor] / [backgroundImage]) comes from backend data.
/// [contentBrightness] picks light or dark ink so title, prices, and icons stay
/// readable on that background.
class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.title,
    required this.contentBrightness,
    this.backgroundColor,
    this.backgroundImage,
    this.prices = const [],
    this.status = TicketCardStatus.active,
    this.onTap,
  }) : assert(
         backgroundColor != null || backgroundImage != null,
         'Provide a backend backgroundColor and/or backgroundImage.',
       );

  final String title;

  /// Backend fill color (e.g. `#E4F0CC` parsed to [Color]).
  final Color? backgroundColor;

  /// Backend background image URL or asset path. Drawn over [backgroundColor].
  final String? backgroundImage;

  /// Ink palette for text/icons on top of the backend background.
  ///
  /// [Brightness.light] → dark ink (pale / light backgrounds).
  /// [Brightness.dark] → light ink (dark / saturated backgrounds).
  final Brightness contentBrightness;

  /// Price rows enabled by client settings (cash / token / coupon).
  final List<TicketCardPrice> prices;

  final TicketCardStatus status;
  final VoidCallback? onTap;

  bool get _isActive => status == TicketCardStatus.active;
  bool get _onLight => contentBrightness == Brightness.light;

  @override
  Widget build(BuildContext context) {
    final onColor = _onLight ? const Color(0xFF191B24) : const Color(0xFFE1E1EE);
    final subColor = _onLight ? const Color(0xFF434656) : const Color(0xFFC3C5D9);
    final accent = _onLight ? const Color(0xFF0047CC) : const Color(0xFFB6C4FF);
    final emphasis = _onLight ? const Color(0xFFC10007) : const Color(0xFFDFDAFF);
    final couponColor = _onLight
        ? const Color(0xFF605B7E)
        : const Color(0xFFDFDAFF);

    return Opacity(
      opacity: _isActive ? 1 : 0.5,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        elevation: 3,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _isActive ? onTap : null,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            decoration: backgroundImage == null
                ? null
                : BoxDecoration(
                    image: DecorationImage(
                      image: imageProviderFor(backgroundImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
          title: Text(
            title,
            style: AppTypography.of(context).titleSemiLarge.copyWith(
              color: onColor,
            ),
          ),
              subtitle: prices.isEmpty
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (var i = 0; i < prices.length; i++) ...[
                            if (i > 0) const SizedBox(height: 4),
                            _PriceRow(
                              price: prices[i],
                              subColor: subColor,
                              accent: accent,
                              emphasis: emphasis,
                              couponColor: couponColor,
                            ),
                          ],
                        ],
                      ),
                    ),
              trailing: Icon(Icons.chevron_right, color: subColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.price,
    required this.subColor,
    required this.accent,
    required this.emphasis,
    required this.couponColor,
  });

  final TicketCardPrice price;
  final Color subColor;
  final Color accent;
  final Color emphasis;
  final Color couponColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final amountColor = switch (price.type) {
      TicketCardPriceType.cash => accent,
      TicketCardPriceType.token => emphasis,
      TicketCardPriceType.coupon => couponColor,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (price.type) {
          TicketCardPriceType.cash => Text(
            '${price.currencyLabel} ',
            style: textTheme.titleSmall?.copyWith(
              color: subColor,
            ),
          ),
          TicketCardPriceType.token => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(Icons.monetization_on, color: subColor, size: 20),
          ),
          TicketCardPriceType.coupon => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(Icons.redeem, color: subColor, size: 20),
          ),
        },
        if (price.originalAmount != null) ...[
          Text(
            price.originalAmount!,
            style: textTheme.bodyLarge?.copyWith(
              color: subColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          price.amount,
          style: textTheme.titleMedium?.copyWith(
            color: amountColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          price.fromSuffix,
          style: textTheme.labelMedium?.copyWith(
            color: subColor,
          ),
        ),
      ],
    );
  }
}
