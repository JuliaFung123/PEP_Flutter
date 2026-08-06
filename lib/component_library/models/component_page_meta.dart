import 'package:flutter/material.dart';

import '../models/component_note.dart';
import '../models/component_library_group.dart';
import '../models/pending_variant.dart';

/// Metadata shared by every component reference page.
class ComponentPageMeta {
  const ComponentPageMeta({
    required this.id,
    required this.title,
    required this.m3SpecUrl,
    required this.description,
    required this.sortOrder,
    required this.group,
    required this.notes,
    required this.pendingVariants,
    required this.pageBuilder,
  });

  final String id;
  final String title;
  final String m3SpecUrl;
  final String description;
  final int sortOrder;
  final ComponentLibraryGroup group;
  final List<ComponentNote> notes;
  final List<PendingVariant> pendingVariants;
  final WidgetBuilder pageBuilder;
}
