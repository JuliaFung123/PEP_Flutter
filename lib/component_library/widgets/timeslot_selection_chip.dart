import 'package:flutter/material.dart';

enum TimeslotSelectionStatus { enabled, selected, disabled }

class TimeslotSelectionChip extends StatelessWidget {
  const TimeslotSelectionChip.date({
    super.key,
    required String day,
    required String date,
    required TimeslotSelectionStatus status,
    this.onPressed,
  }) : _status = status,
       _kind = _TimeslotKind.date,
       _topLabel = day,
       _bottomLabel = date,
       _label = null,
       _swatchColor = null;

  const TimeslotSelectionChip.time({
    super.key,
    required String label,
    required TimeslotSelectionStatus status,
    this.onPressed,
  }) : _status = status,
       _kind = _TimeslotKind.time,
       _topLabel = null,
       _bottomLabel = null,
       _label = label,
       _swatchColor = null;

  const TimeslotSelectionChip.color({
    super.key,
    required String label,
    required Color swatchColor,
    required TimeslotSelectionStatus status,
    this.onPressed,
  }) : _status = status,
       _kind = _TimeslotKind.color,
       _topLabel = null,
       _bottomLabel = null,
       _label = label,
       _swatchColor = swatchColor;

  const TimeslotSelectionChip.text({
    super.key,
    required String label,
    required TimeslotSelectionStatus status,
    this.onPressed,
  }) : _status = status,
       _kind = _TimeslotKind.text,
       _topLabel = null,
       _bottomLabel = null,
       _label = label,
       _swatchColor = null;

  final TimeslotSelectionStatus _status;
  final _TimeslotKind _kind;
  final String? _topLabel;
  final String? _bottomLabel;
  final String? _label;
  final Color? _swatchColor;

  /// When set and status is not [TimeslotSelectionStatus.disabled], chip is tappable.
  final VoidCallback? onPressed;

  bool get _isSelected => _status == TimeslotSelectionStatus.selected;
  bool get _isDisabled => _status == TimeslotSelectionStatus.disabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final minWidth = switch (_kind) {
      _TimeslotKind.date => 72.0,
      _TimeslotKind.time || _TimeslotKind.text => 64.0,
      _ => 72.0,
    };
    // Time / Color / Text: Figma min-h 40. Date height comes from content + py-8.
    final minHeight = switch (_kind) {
      _TimeslotKind.date => 0.0,
      _ => 40.0,
    };
    final backgroundColor = _isSelected
        ? colorScheme.inverseSurface
        : colorScheme.surface;
    final borderColor = _isSelected
        ? Colors.transparent
        : colorScheme.outlineVariant;
    final primaryTextColor = _isSelected
        ? colorScheme.onInverseSurface
        : colorScheme.onSurface;
    final secondaryTextColor = _isSelected
        ? colorScheme.onInverseSurface
        : colorScheme.onSurfaceVariant;

    // IntrinsicWidth keeps chips hugging content so Wrap can lay out a grid
    // (Figma: flex-wrap + shrink-0), instead of stretching to the row width.
    final chip = Opacity(
      opacity: _isDisabled ? 0.38 : 1,
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth,
            minHeight: minHeight,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: _kind == _TimeslotKind.date ? 8 : 0,
              ),
              child: switch (_kind) {
                _TimeslotKind.date => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _topLabel!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    Text(
                      _bottomLabel!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Fill min height and center label (Figma: items-center justify-center).
                _TimeslotKind.time || _TimeslotKind.text => SizedBox(
                  height: minHeight,
                  child: Center(
                    child: Text(
                      _label!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _TimeslotKind.color => SizedBox(
                  height: minHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _swatchColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _isSelected
                                ? const Color(0xFF434656)
                                : colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _label!,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              },
            ),
          ),
        ),
      ),
    );

    if (onPressed == null || _isDisabled) return chip;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: chip,
      ),
    );
  }
}

enum _TimeslotKind { date, time, color, text }
