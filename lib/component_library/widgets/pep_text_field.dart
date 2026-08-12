import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/pep_input_decoration_theme.dart';

/// PEP outlined text field — surface fill plus full outline, optional external label.
///
/// Decoration tokens come from [PepInputDecorationTheme] on [ThemeData.extensions].
/// The label sits above the field instead of floating inside. Subtext follows M3:
/// [helperText] on normal states, [errorText] replaces it in error.
enum PepTextFieldStatus { normal, error }

class PepTextField extends StatefulWidget {
  const PepTextField({
    super.key,
    this.label = 'Label',
    this.showExternalLabel = true,
    this.controller,
    this.hintText = 'Placeholder',
    this.helperText = 'Helper text',
    this.errorText = 'Error message',
    this.status = PepTextFieldStatus.normal,
    this.required = false,
    this.enabled = true,
    this.showHelperText = true,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.inputFormatters,
    this.keyboardType,
  });

  final String label;
  final bool showExternalLabel;
  final TextEditingController? controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final PepTextFieldStatus status;
  final bool required;
  final bool enabled;
  /// Controls [helperText] only. [errorText] is shown separately when in error state.
  final bool showHelperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  @override
  State<PepTextField> createState() => _PepTextFieldState();
}

/// Leading color swatch for PEP fields — 24dp circle centered in the 48dp icon slot.
class PepColorSwatchPrefix extends StatelessWidget {
  const PepColorSwatchPrefix({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;

    return Center(
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
        ),
      ),
    );
  }
}

class _PepTextFieldState extends State<PepTextField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  late bool _ownsController;

  bool get _isError => widget.status == PepTextFieldStatus.error;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChange);
  }

  @override
  void didUpdateWidget(PepTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onTextChange);
      if (_ownsController) {
        _controller.dispose();
      }
      _ownsController = widget.controller == null;
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onTextChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChange);
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  void _onTextChange() => setState(() {});

  Color _labelColor(ColorScheme colorScheme) {
    if (!widget.enabled) {
      return colorScheme.onSurface.withValues(alpha: 0.38);
    }
    if (_isError) return colorScheme.error;
    if (_focusNode.hasFocus) return colorScheme.primary;
    return colorScheme.onSurfaceVariant;
  }

  InputDecoration _decoration(ColorScheme colorScheme, TextTheme textTheme) {
    final isError = _isError;
    final isBlank = _controller.text.isEmpty;
    final enabledBlank = widget.enabled && isBlank && !isError;
    final mutedColor = colorScheme.onSurface.withValues(alpha: 0.38);
    final hintStyle = textTheme.bodyLarge?.copyWith(
      color: enabledBlank || !widget.enabled
          ? mutedColor
          : colorScheme.onSurfaceVariant,
      height: 24 / 16,
    );

    final hint = widget.hintText;
    final decoration = InputDecoration(
      hintText: hint == null || hint.isEmpty ? null : hint,
      hintStyle: hintStyle,
      helperText: widget.showHelperText && !isError ? widget.helperText : null,
      errorText: isError ? widget.errorText : null,
      prefixIcon: widget.prefixIcon,
      prefixIconColor: enabledBlank ? mutedColor : null,
      suffixIcon: widget.suffixIcon,
      suffixIconColor: enabledBlank ? mutedColor : null,
    );

    return decoration.applyDefaults(PepInputDecorationTheme.of(context));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final field = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      style: textTheme.bodyLarge?.copyWith(
        color: widget.enabled
            ? colorScheme.onSurface
            : colorScheme.onSurface.withValues(alpha: 0.38),
        height: 24 / 16,
      ),
      decoration: _decoration(colorScheme, textTheme),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showExternalLabel) ...[
          Row(
            children: [
              Text(
                widget.label,
                style: textTheme.bodySmall?.copyWith(
                  color: _labelColor(colorScheme),
                  height: 20 / 14,
                ),
              ),
              if (widget.required)
                Text(
                  ' *',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                    height: 20 / 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        field,
      ],
    );
  }
}
