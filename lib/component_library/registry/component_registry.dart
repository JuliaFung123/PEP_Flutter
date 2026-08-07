import 'package:flutter/material.dart';

import '../models/component_page_meta.dart';
import '../models/component_library_group.dart';
import '../models/component_page_meta_data.dart';
import '../pages/app_bars_component_page.dart';
import '../pages/badges_component_page.dart';
import '../pages/buttons_component_page.dart';
import '../pages/buy_quantity_component_page.dart';
import '../pages/checkbox_component_page.dart';
import '../pages/chips_component_page.dart';
import '../pages/color_picker_component_page.dart';
import '../pages/color_theme_component_page.dart';
import '../pages/date_picker_component_page.dart';
import '../pages/divider_component_page.dart';
import '../pages/image_header_component_page.dart';
import '../pages/photo_gallery_component_page.dart';
import '../pages/progress_indicators_component_page.dart';
import '../pages/radio_button_component_page.dart';
import '../pages/scroll_nav_component_page.dart';
import '../pages/sliders_component_page.dart';
import '../pages/switch_component_page.dart';
import '../pages/tabs_component_page.dart';
import '../pages/text_fields_component_page.dart';
import '../pages/ticket_card_component_page.dart';
import '../pages/timeslot_selection_component_page.dart';
import '../pages/typography_component_page.dart';

/// Central index of M3 atom component reference pages.
abstract final class ComponentRegistry {
  static final List<ComponentPageMeta> all =
      [
        _entry(ColorThemeComponentPage.meta, const ColorThemeComponentPage()),
        _entry(TypographyComponentPage.meta, const TypographyComponentPage()),
        _entry(ColorPickerComponentPage.meta, const ColorPickerComponentPage()),
        _entry(DatePickerComponentPage.meta, const DatePickerComponentPage()),
        _entry(AppBarsComponentPage.meta, const AppBarsComponentPage()),
        _entry(
          ProgressIndicatorsComponentPage.meta,
          const ProgressIndicatorsComponentPage(),
        ),
        _entry(RadioButtonComponentPage.meta, const RadioButtonComponentPage()),
        _entry(SlidersComponentPage.meta, const SlidersComponentPage()),
        _entry(SwitchComponentPage.meta, const SwitchComponentPage()),
        _entry(TabsComponentPage.meta, const TabsComponentPage()),
        _entry(ScrollNavComponentPage.meta, const ScrollNavComponentPage()),
        _entry(TextFieldsComponentPage.meta, const TextFieldsComponentPage()),
        _entry(
          TimeslotSelectionComponentPage.meta,
          const TimeslotSelectionComponentPage(),
        ),
        _entry(TicketCardComponentPage.meta, const TicketCardComponentPage()),
        _entry(BuyQuantityComponentPage.meta, const BuyQuantityComponentPage()),
        _entry(BadgesComponentPage.meta, const BadgesComponentPage()),
        _entry(ButtonsComponentPage.meta, const ButtonsComponentPage()),
        _entry(CheckboxComponentPage.meta, const CheckboxComponentPage()),
        _entry(ChipsComponentPage.meta, const ChipsComponentPage()),
        _entry(DividerComponentPage.meta, const DividerComponentPage()),
        _entry(ImageHeaderComponentPage.meta, const ImageHeaderComponentPage()),
        _entry(PhotoGalleryComponentPage.meta, const PhotoGalleryComponentPage()),
      ]..sort((a, b) {
        final groupOrder = a.group.index.compareTo(b.group.index);
        if (groupOrder != 0) return groupOrder;
        if (a.group == ComponentLibraryGroup.theme) {
          return a.sortOrder.compareTo(b.sortOrder);
        }
        return a.title.compareTo(b.title);
      });

  static List<ComponentLibrarySection> get sections {
    final themePages = all
        .where((page) => page.group == ComponentLibraryGroup.theme)
        .toList();
    final atomPages =
        all.where((page) => page.group == ComponentLibraryGroup.atom).toList()
          ..sort((a, b) => a.title.compareTo(b.title));
    final layoutBlockPages =
        all
            .where((page) => page.group == ComponentLibraryGroup.layoutBlock)
            .toList()
          ..sort((a, b) => a.title.compareTo(b.title));

    return [
      if (themePages.isNotEmpty)
        ComponentLibrarySection(title: 'Theme', pages: themePages),
      if (atomPages.isNotEmpty)
        ComponentLibrarySection(title: 'Atom Components', pages: atomPages),
      ComponentLibrarySection(title: 'Layout Block', pages: layoutBlockPages),
    ];
  }

  static ComponentPageMeta _entry(ComponentPageMetaData meta, Widget page) {
    return ComponentPageMeta(
      id: meta.id,
      title: meta.title,
      m3SpecUrl: meta.m3SpecUrl,
      description: meta.description,
      sortOrder: meta.sortOrder,
      group: meta.group,
      notes: const [],
      pendingVariants: const [],
      pageBuilder: (_) => page,
    );
  }

  static ComponentPageMeta? findById(String id) {
    for (final page in all) {
      if (page.id == id) return page;
    }
    return null;
  }
}
