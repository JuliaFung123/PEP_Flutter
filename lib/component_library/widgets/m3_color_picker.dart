import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kpi_text_field.dart';

/// Material-style color picker: saturation/value plane, hue slider, hex field.
/// No transparency / alpha control.
class M3ColorPicker extends StatefulWidget {
  const M3ColorPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  final Color value;
  final ValueChanged<Color> onChanged;
  final bool compact;

  @override
  State<M3ColorPicker> createState() => _M3ColorPickerState();
}

class _M3ColorPickerState extends State<M3ColorPicker> {
  late HSVColor _hsv;
  late final TextEditingController _hexController;
  bool _editingHex = false;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.value);
    _hexController = TextEditingController(text: _displayHex(widget.value));
  }

  @override
  void didUpdateWidget(M3ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && !_editingHex) {
      _hsv = HSVColor.fromColor(widget.value);
      _hexController.text = _displayHex(widget.value);
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _emit(Color color) {
    _hsv = HSVColor.fromColor(color);
    if (!_editingHex) {
      _hexController.text = _displayHex(color);
    }
    widget.onChanged(color);
  }

  void _updateHsv(HSVColor next) {
    setState(() => _hsv = next);
    widget.onChanged(next.toColor());
    if (!_editingHex) {
      _hexController.text = _displayHex(next.toColor());
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _hsv.toColor();
    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    final compact = widget.compact;
    final padding = compact ? 8.0 : 16.0;
    final gap = compact ? 8.0 : 16.0;
    final radius = compact ? 12.0 : 20.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: compact ? 1.6 : 1.1,
              child: _SaturationValueArea(
                hue: _hsv.hue,
                saturation: _hsv.saturation,
                value: _hsv.value,
                compact: compact,
                onChanged: (saturation, value) {
                  _updateHsv(_hsv.withSaturation(saturation).withValue(value));
                },
              ),
            ),
            SizedBox(height: gap),
            _HueSlider(
              hue: _hsv.hue,
              color: color,
              compact: compact,
              onChanged: (hue) => _updateHsv(_hsv.withHue(hue)),
            ),
            SizedBox(height: gap),
            KpiTextField(
              showExternalLabel: false,
              showHelperText: false,
              hintText: '',
              controller: _hexController,
              prefixIcon: KpiColorSwatchPrefix(color: color),
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
            ),
          ],
        ),
      ),
    );
  }

  void _applyHex(String raw) {
    _editingHex = false;
    final parsed = _parseHex(raw);
    if (parsed != null) {
      setState(() => _emit(parsed));
    }
  }

  static String _displayHex(Color color) => '#${_toHex(color)}';

  static String _toHex(Color color) {
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
}

class _SaturationValueArea extends StatelessWidget {
  const _SaturationValueArea({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  final double hue;
  final double saturation;
  final double value;
  final bool compact;
  final void Function(double saturation, double value) onChanged;

  @override
  Widget build(BuildContext context) {
    final pureHue = HSVColor.fromAHSV(1, hue, 1, 1).toColor();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final handleLeft = saturation * size.width;
        final handleTop = (1 - value) * size.height;

        final handleSize = compact ? 14.0 : 20.0;
        final handleOffset = handleSize / 2;

        return GestureDetector(
          onPanDown: (details) => _update(details.localPosition, size),
          onPanUpdate: (details) => _update(details.localPosition, size),
          onTapDown: (details) => _update(details.localPosition, size),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(compact ? 8 : 12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: pureHue),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black],
                    ),
                  ),
                ),
                Positioned(
                  left: handleLeft.clamp(0, size.width - handleSize) - handleOffset,
                  top: handleTop.clamp(0, size.height - handleSize) - handleOffset,
                  child: Container(
                    width: handleSize,
                    height: handleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x44000000),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _update(Offset local, Size size) {
    final s = (local.dx / size.width).clamp(0.0, 1.0);
    final v = (1 - local.dy / size.height).clamp(0.0, 1.0);
    onChanged(s, v);
  }
}

class _HueSlider extends StatelessWidget {
  const _HueSlider({
    required this.hue,
    required this.color,
    required this.onChanged,
    this.compact = false,
  });

  final double hue;
  final Color color;
  final bool compact;
  final ValueChanged<double> onChanged;

  static const _hueColors = [
    Color(0xFFFF0000),
    Color(0xFFFFFF00),
    Color(0xFF00FF00),
    Color(0xFF00FFFF),
    Color(0xFF0000FF),
    Color(0xFFFF00FF),
    Color(0xFFFF0000),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbLeft = (hue / 360) * width;

        final thumbSize = compact ? 18.0 : 24.0;
        final trackHeight = compact ? 8.0 : 12.0;
        final barHeight = compact ? 20.0 : 28.0;

        return GestureDetector(
          onPanDown: (details) => _update(details.localPosition.dx, width),
          onPanUpdate: (details) => _update(details.localPosition.dx, width),
          onTapDown: (details) => _update(details.localPosition.dx, width),
          child: SizedBox(
            height: barHeight,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: trackHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(trackHeight / 2),
                    gradient: const LinearGradient(colors: _hueColors),
                  ),
                ),
                Positioned(
                  left: thumbLeft.clamp(0, width - thumbSize),
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x44000000),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _update(double dx, double width) {
    final nextHue = (dx / width).clamp(0.0, 1.0) * 360;
    onChanged(nextHue);
  }
}
