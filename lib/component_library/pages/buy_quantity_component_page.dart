import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/buy_quantity.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/ticket_card.dart';

/// Activity bottom purchase bar — quantity, price summary, buy CTA.
class BuyQuantityComponentPage extends StatefulWidget {
  const BuyQuantityComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'buy_quantity',
    title: 'Buy quantity',
    m3SpecUrl:
        'https://www.figma.com/design/61SERD0hYvuj7BrwBRv210/PEP_APP-2?node-id=247-5852',
    description:
        'Bottom purchase layout: quantity stepper with backend `maxQuantity`, '
        'optional red hint composed from backend remaining / waitlist / '
        'max-per-person fields, price summary, and Buy Now.',
    group: ComponentLibraryGroup.layoutBlock,
  );

  @override
  State<BuyQuantityComponentPage> createState() =>
      _BuyQuantityComponentPageState();
}

class _BuyQuantityComponentPageState extends State<BuyQuantityComponentPage> {
  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Purchase limit (maxQuantity)',
      m3Behavior: 'N/A — commerce rule from backend.',
      ourImplementation:
          '`maxQuantity` comes from the backend already resolved. Frontend '
          'does not calculate it. When quantity reaches it, **+** is disabled. '
          '`null` = no client-side cap.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Availability hint',
      m3Behavior: 'Product status under the quantity label — not an M3 pattern.',
      ourImplementation:
          'Compose backend fields into one red bodyMedium line (omit unused):\n'
          '• remaining → “N left”\n'
          '• waitlistAvailable → “N waitlist available”\n'
          '• maxPerPerson → “max N/ppl”\n'
          'Examples: “5 left, max 2/ppl”; “1 left, 3 waitlist available”. '
          'Empty = plentiful (no hint). Separate from `maxQuantity`.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Quantity stepper',
      m3Behavior: 'N/A — product control.',
      ourImplementation:
          'Outlined circular − / + (xs32); quantity uses titleLarge (22). '
          '`minQuantity` / `maxQuantity` gate the buttons.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Price summary',
      m3Behavior: 'N/A — commerce totals.',
      ourImplementation:
          'Centered row of `TicketCardPrice` (cash / token / coupon) in '
          'titleLarge with 24px icons, separated by `/` (titleSmall).',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Buy Now',
      m3Behavior: 'Primary filled action (Figma Size M 56 / Title Large).',
      ourImplementation:
          'Full-width stadium `FilledButton` via '
          '`KpiButtonStyles.labelStyle(..., KpiButtonSize.m56)`. '
          'Stepper ± uses `iconStyle(xs32)`.',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[];

  static const _demoPrices = [
    TicketCardPrice.cash(amount: '1,234.56'),
    TicketCardPrice.token(amount: '50'),
    TicketCardPrice.coupon(amount: '3'),
  ];

  int _plentyQty = 1;
  int _perPersonQty = 1;
  int _waitlistQty = 1;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return ComponentPageScaffold(
      title: BuyQuantityComponentPage.meta.title,
      m3SpecUrl: BuyQuantityComponentPage.meta.m3SpecUrl,
      description: BuyQuantityComponentPage.meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Plenty — no hint', style: titleStyle),
          const SizedBox(height: 12),
          BuyQuantity(
            quantity: _plentyQty,
            onQuantityChanged: (value) => setState(() => _plentyQty = value),
            availability: const BuyQuantityAvailability.plenty(),
            prices: _demoPrices,
            onBuy: () {},
          ),
          const SizedBox(height: 24),
          Text(
            '“5 left, max 2/ppl” — maxQuantity: 2',
            style: titleStyle,
          ),
          const SizedBox(height: 12),
          BuyQuantity(
            quantity: _perPersonQty,
            onQuantityChanged: (value) => setState(() => _perPersonQty = value),
            availability: const BuyQuantityAvailability(
              remaining: 5,
              maxPerPerson: 2,
            ),
            maxQuantity: 2,
            prices: _demoPrices,
            onBuy: () {},
          ),
          const SizedBox(height: 24),
          Text(
            '“1 left, 3 waitlist available” — maxQuantity: 4',
            style: titleStyle,
          ),
          const SizedBox(height: 12),
          BuyQuantity(
            quantity: _waitlistQty,
            onQuantityChanged: (value) => setState(() => _waitlistQty = value),
            availability: const BuyQuantityAvailability(
              remaining: 1,
              waitlistAvailable: 3,
            ),
            maxQuantity: 4,
            prices: _demoPrices,
            onBuy: () {},
          ),
        ],
      ),
    );
  }
}
