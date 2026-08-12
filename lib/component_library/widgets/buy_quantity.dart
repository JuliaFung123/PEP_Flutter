import 'package:flutter/material.dart';

import 'pep_button_styles.dart';
import 'ticket_card.dart';

/// Availability / limit copy under the quantity label (all values from backend).
///
/// Compose whichever fields apply; empty = plentiful (no hint). Frontend does
/// not calculate — only formats and shows. Purchase cap is still [BuyQuantity.maxQuantity].
///
/// Examples:
/// - `remaining: 5, maxPerPerson: 2` → “5 left, max 2/ppl” (`maxQuantity: 2`)
/// - `remaining: 1, waitlistAvailable: 3` → “1 left, 3 waitlist available”
///   (`maxQuantity: 4` from backend)
class BuyQuantityAvailability {
  const BuyQuantityAvailability({
    this.remaining,
    this.waitlistAvailable,
    this.maxPerPerson,
  });

  /// Plenty of tickets / no scarcity copy — hide the hint.
  const BuyQuantityAvailability.plenty()
      : remaining = null,
        waitlistAvailable = null,
        maxPerPerson = null;

  /// Tickets still sellable (show “N left” when set).
  final int? remaining;

  /// Waitlist slots open (show “N waitlist available” when set).
  final int? waitlistAvailable;

  /// Per-person purchase limit for display (show “max N/ppl” when set).
  /// Does not drive the stepper — use [BuyQuantity.maxQuantity] for that.
  final int? maxPerPerson;

  /// Red hint copy (`ColorScheme.error`), or `null` when nothing to show.
  String? get hintText {
    final parts = <String>[];
    if (remaining != null) parts.add('$remaining left');
    if (waitlistAvailable != null) {
      parts.add('$waitlistAvailable waitlist available');
    }
    if (maxPerPerson != null) parts.add('max $maxPerPerson/ppl');
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }
}

/// Bottom purchase bar: quantity stepper, price summary, and buy action.
///
/// Figma: https://www.figma.com/design/61SERD0hYvuj7BrwBRv210/PEP_APP-2?node-id=247-5852
class BuyQuantity extends StatelessWidget {
  const BuyQuantity({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onBuy,
    this.label = '數量',
    this.availability = const BuyQuantityAvailability.plenty(),
    this.prices = const [],
    this.buyLabel = 'Buy Now',
    this.minQuantity = 1,
    this.maxQuantity,
  });

  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onBuy;
  final String label;

  /// Status hint under [label] (remaining / waitlist / max per person).
  /// Use [BuyQuantityAvailability.plenty] when no hint is needed.
  /// Hint text color uses [ColorScheme.error].
  final BuyQuantityAvailability availability;

  /// Price summary lines. Amount colors are **backend-fixed** (not
  /// [ColorScheme]); demos use placeholder hex until API colors are wired.
  final List<TicketCardPrice> prices;
  final String buyLabel;
  final int minQuantity;

  /// Backend-resolved upper purchase limit — frontend does not calculate this.
  ///
  /// Backend already combines per-person limit, remaining tickets, waitlist
  /// slots, timeslot capacity, etc. When [quantity] reaches this value, **+**
  /// is disabled. `null` means no client cap.
  final int? maxQuantity;

  bool get _canDecrease => quantity > minQuantity;
  bool get _canIncrease =>
      maxQuantity == null ? true : quantity < maxQuantity!;

  void _setQuantity(int next) {
    var value = next;
    if (value < minQuantity) value = minQuantity;
    if (maxQuantity != null && value > maxQuantity!) value = maxQuantity!;
    if (value != quantity) onQuantityChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hint = availability.hintText;

    return Material(
      color: colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (hint != null)
                          Text(
                            hint,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _QuantityStepper(
                    quantity: quantity,
                    canDecrease: _canDecrease,
                    canIncrease: _canIncrease,
                    onDecrease: () => _setQuantity(quantity - 1),
                    onIncrease: () => _setQuantity(quantity + 1),
                  ),
                ],
              ),
            ),
            if (prices.isNotEmpty) ...[
              const SizedBox(height: 16),
              Divider(height: 1, color: colorScheme.outlineVariant),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _PriceSummaryRow(prices: prices),
              ),
            ],
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onBuy,
                  style: PepButtonStyles.labelStyle(context, PepButtonSize.m56),
                  child: Text(buyLabel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundIconButton(
          icon: Icons.remove,
          onPressed: canDecrease ? onDecrease : null,
        ),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 40),
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 4),
        _RoundIconButton(
          icon: Icons.add,
          onPressed: canIncrease ? onIncrease : null,
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: PepButtonStyles.iconStyle(PepButtonSize.xs32).copyWith(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.outline;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.12),
              );
            }
            return BorderSide(color: colorScheme.outline);
          }),
        ),
        icon: Icon(icon, size: PepButtonSize.xs32.iconSize),
      ),
    );
  }
}

class _PriceSummaryRow extends StatelessWidget {
  const _PriceSummaryRow({required this.prices});

  final List<TicketCardPrice> prices;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final children = <Widget>[];

    for (var i = 0; i < prices.length; i++) {
      if (i > 0) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '/',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }
      children.add(_PriceChip(price: prices[i]));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({required this.price});

  final TicketCardPrice price;

  /// Demo placeholders until backend supplies per-type colors.
  /// Cash currently maps to [ColorScheme.primary]; token/coupon stay fixed.
  static const _tokenDemoColor = Color(0xFFC10007);
  static const _couponDemoColor = Color(0xFF605B7E);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return switch (price.type) {
      TicketCardPriceType.cash => Text(
        '${price.currencyLabel} ${price.amount}',
        style: textTheme.titleLarge?.copyWith(
          // Backend may override; demo uses primary.
          color: colorScheme.primary,
        ),
      ),
      TicketCardPriceType.token => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on,
            size: 24,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            price.amount,
            style: textTheme.titleLarge?.copyWith(
              color: _tokenDemoColor,
            ),
          ),
        ],
      ),
      TicketCardPriceType.coupon => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.redeem, size: 24, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            price.amount,
            style: textTheme.titleLarge?.copyWith(
              color: _couponDemoColor,
            ),
          ),
        ],
      ),
    };
  }
}
