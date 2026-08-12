import 'package:flutter/material.dart';

import 'pep_avatar.dart';

/// Shared helpers for rendering chip previews in the variant matrix.
Widget chipLabel(BuildContext context, String text, {TextStyle? style}) {
  return Text(
    text,
    style: style ?? Theme.of(context).textTheme.labelLarge,
  );
}

Widget? chipLeadingIcon(bool show, {double size = 18}) =>
    show ? Icon(Icons.account_circle_outlined, size: size) : null;

/// Circular avatar for chip `avatar:` slot — uses [PepAvatar].
Widget? chipAvatar(bool show, {double size = 24}) {
  if (!show) return null;
  return PepAvatar.diameter(size);
}

Widget? chipTrailingIcon(bool show, {double size = 18}) =>
    show ? Icon(Icons.close, size: size) : null;

/// Trailing affordance for Filter chips (menu / expand), not delete.
Widget? chipFilterTrailingIcon(bool show, {double size = 18}) =>
    show ? Icon(Icons.arrow_drop_down, size: size) : null;
