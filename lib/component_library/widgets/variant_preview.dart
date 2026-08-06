import 'package:flutter/material.dart';

/// Shared helpers for rendering chip previews in the variant matrix.
Widget chipLabel(BuildContext context, String text) {
  return Text(text, style: Theme.of(context).textTheme.labelLarge);
}

Widget? chipLeadingIcon(bool show) =>
    show ? const Icon(Icons.account_circle_outlined, size: 18) : null;

Widget? chipTrailingIcon(bool show) =>
    show ? const Icon(Icons.close, size: 18) : null;
