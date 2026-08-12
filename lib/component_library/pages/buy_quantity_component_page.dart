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
        'optional availability hint (`ColorScheme.error`) from remaining / '
        'waitlist / max-per-person, price summary (backend-fixed colors), '
        'and Buy Now.',
    group: ComponentLibraryGroup.layoutBlock,
  );

  @override
  State<BuyQuantityComponentPage> createState() =>
      _BuyQuantityComponentPageState();
}

class _BuyQuantityComponentPageState extends State<BuyQuantityComponentPage> {
  static const _notes = <ComponentNote>[
    ComponentNote(
      topic: 'BuyQuantity',
      spec:
          'surfaceContainer bar; label titleMedium (onSurfaceVariant); '
          'hint bodyMedium (error); quantity titleLarge; prices titleLarge '
          'icons 24; Buy Now FilledButton M 56; steppers iconStyle xs32.',
      setupCode: '''
BuyQuantity(
  quantity: quantity,
  minQuantity: 1,
  maxQuantity: maxFromBackend, // null = no client cap
  availability: BuyQuantityAvailability(
    remaining: 5,
    maxPerPerson: 2,
  ),
  prices: const [
    TicketCardPrice.cash(amount: '120'),
  ],
  onQuantityChanged: (v) {},
  onBuy: () {},
)
''',
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
