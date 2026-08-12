import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pep_button_styles.dart';
import 'pep_text_field.dart';
import 'm3_color_picker.dart';

/// Opens a bottom-docked color picker sheet and returns the chosen color.
Future<Color?> showDockedColorPicker(
  BuildContext context, {
  required Color initialColor,
}) {
  var color = initialColor;

  return showModalBottomSheet<Color>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

          return Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                M3ColorPicker(
                  value: color,
                  onChanged: (value) => setSheetState(() => color = value),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        style: PepButtonStyles.labelStyle(
                          sheetContext,
                          PepButtonSize.s40,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(sheetContext).pop(color),
                        style: PepButtonStyles.labelStyle(
                          sheetContext,
                          PepButtonSize.s40,
                        ),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

/// Input field that opens the docked color picker. Standalone — not tied to app theme.
class ColorPickerInputField extends StatefulWidget {
  const ColorPickerInputField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final Color value;
  final ValueChanged<Color> onChanged;
  final bool enabled;

  @override
  State<ColorPickerInputField> createState() => _ColorPickerInputFieldState();
}

class _ColorPickerInputFieldState extends State<ColorPickerInputField> {
  late final TextEditingController _controller;
  bool _editingHex = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _displayHex(widget.value));
  }

  @override
  void didUpdateWidget(ColorPickerInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_editingHex) return;
    final hex = _displayHex(widget.value);
    if (_controller.text.toUpperCase() != hex.toUpperCase()) {
      _controller.text = hex;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _displayHex(Color color) => '#${_hexBody(color)}';

  static String _hexBody(Color color) {
    final rgb = color.toARGB32() & 0xFFFFFF;
    return rgb.toRadixString(16).padLeft(6, '0').toUpperCase();
  }

  static Color? _parseHex(String raw) {
    final cleaned = raw.replaceAll('#', '').trim();
    if (cleaned.length != 6) return null;
    final value = int.tryParse(cleaned, radix: 16);
    if (value == null) return null;
    return Color(0xFF000000 | value);
  }

  void _applyHex(String raw) {
    _editingHex = false;
    final parsed = _parseHex(raw);
    if (parsed != null) {
      widget.onChanged(parsed);
    }
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showDockedColorPicker(
      context,
      initialColor: widget.value,
    );
    if (picked != null) {
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PepTextField(
      showExternalLabel: false,
      showHelperText: false,
      hintText: '',
      controller: _controller,
      enabled: widget.enabled,
      prefixIcon: PepColorSwatchPrefix(color: widget.value),
      suffixIcon: IconButton(
        icon: const Icon(Icons.palette_outlined),
        style: PepButtonStyles.iconStyle(PepButtonSize.s40),
        onPressed: widget.enabled ? () => _open(context) : null,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'#[0-9A-Fa-f]')),
        LengthLimitingTextInputFormatter(7),
      ],
      onTap: () => _editingHex = true,
      onChanged: (raw) {
        final body = raw.replaceAll('#', '');
        if (body.length == 6) _applyHex(body);
      },
      onSubmitted: (raw) => _applyHex(raw.replaceAll('#', '')),
      onEditingComplete: () => _editingHex = false,
    );
  }
}
