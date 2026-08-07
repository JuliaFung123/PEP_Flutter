import 'package:flutter/material.dart';

import '../models/component_library_group.dart';
import '../models/component_note.dart';
import '../models/component_page_meta_data.dart';
import '../models/pending_variant.dart';
import '../widgets/component_page_scaffold.dart';
import '../widgets/image_source.dart';
import '../widgets/ticket_card.dart';

/// Ticket option card — backend background + contrast + price types.
class TicketCardComponentPage extends StatelessWidget {
  const TicketCardComponentPage({super.key});

  static const meta = ComponentPageMetaData(
    id: 'ticket_card',
    title: 'Ticket card',
    m3SpecUrl:
        'https://www.figma.com/design/61SERD0hYvuj7BrwBRv210/PEP_APP-2?node-id=248-5646',
    description:
        'Activity / booking ticket option. Background color or image comes from '
        'backend data. Content uses light or dark ink for readability. Price '
        'rows follow client settings (cash / token / coupon), each with an '
        'optional original amount shown as strikethrough. Surface uses M3 '
        'elevation 3 (no outline). Status: active or inactive.',
    group: ComponentLibraryGroup.layoutBlock,
  );

  static const _notes = <ComponentNote>[
    ComponentNote(
      variant: 'Background',
      m3Behavior: 'N/A — product surface, not an M3 color role.',
      ourImplementation:
          '`backgroundColor` and/or `backgroundImage` from backend. '
          'Image draws over the color when both are set. No outline; '
          '`Material` elevation 3 (M3 Elevation Light/3).',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Content brightness',
      m3Behavior: 'Keep contrast readable on the filled surface.',
      ourImplementation:
          '`contentBrightness: Brightness.light` → dark ink (pale bg). '
          '`Brightness.dark` → light ink (dark / saturated bg). Backend or '
          'layout picks the mode so title, prices, and icons stay readable.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Price types',
      m3Behavior: 'N/A — commerce display driven by client config.',
      ourImplementation:
          '`TicketCardPrice.cash` / `.token` / `.coupon`. Pass only the types '
          'enabled for that client. Optional `originalAmount` → strikethrough.',
      action: 'Use as-is',
    ),
    ComponentNote(
      variant: 'Active / Inactive',
      m3Behavior: 'Interactive vs unavailable option.',
      ourImplementation:
          '`TicketCardStatus.active` (full opacity, tappable) or `.inactive` '
          '(≈50% opacity, taps ignored).',
      action: 'Use as-is',
    ),
  ];

  static const _pending = <PendingVariant>[];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ComponentPageScaffold(
      title: meta.title,
      m3SpecUrl: meta.m3SpecUrl,
      description: meta.description,
      notes: _notes,
      pendingVariants: _pending,
      variantsSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Backend background + contrast · Price types (client settings)',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Background color/image from backend; pick Brightness.light or .dark '
            'ink for readability. Show only cash / token / coupon types the '
            'client enables — each may include originalAmount (strikethrough). '
            'Inactive cards use ≈50% opacity.',
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TicketCard(
            backgroundColor: const Color(0xFF823D8F),
            contentBrightness: Brightness.dark,
            title: 'title (token+coupon)',
            prices: const [
              TicketCardPrice.token(amount: '50', originalAmount: '80'),
              TicketCardPrice.coupon(amount: '3'),
            ],
            status: TicketCardStatus.active,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          Text('Inactive', style: textTheme.labelLarge),
          const SizedBox(height: 8),
          const TicketCard(
            backgroundColor: Color(0xFF823D8F),
            contentBrightness: Brightness.dark,
            title: 'title (token+coupon)',
            prices: [
              TicketCardPrice.token(amount: '50', originalAmount: '80'),
              TicketCardPrice.coupon(amount: '3'),
            ],
            status: TicketCardStatus.inactive,
          ),
          const SizedBox(height: 16),
          TicketCard(
            backgroundColor: const Color(0xFF1A1B26),
            backgroundImage: kDemoImageHeaderAssets.first,
            contentBrightness: Brightness.dark,
            title: 'Title (Cash only)',
            prices: const [
              TicketCardPrice.cash(
                amount: '988.00',
                originalAmount: '1,200.00',
              ),
            ],
            status: TicketCardStatus.active,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          Text('Inactive', style: textTheme.labelLarge),
          const SizedBox(height: 8),
          TicketCard(
            backgroundColor: const Color(0xFF1A1B26),
            backgroundImage: kDemoImageHeaderAssets.first,
            contentBrightness: Brightness.dark,
            title: 'Title (Cash only)',
            prices: const [
              TicketCardPrice.cash(
                amount: '988.00',
                originalAmount: '1,200.00',
              ),
            ],
            status: TicketCardStatus.inactive,
          ),
        ],
      ),
    );
  }
}
