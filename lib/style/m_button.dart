import 'package:flutter/material.dart';

class MButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? icon;
  final Widget? label;
  final AlignmentGeometry? alignment;
  final Color? splashColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final double? radius;
  final double? widthBorder;
  const MButton({
    super.key,
    this.onPressed,
    this.icon,
    this.label,
    this.alignment,
    this.splashColor,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.radius,
    this.widthBorder,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon ?? const SizedBox.shrink(),
      label: label ?? const Text(''),
      style: ButtonStyle(
        alignment: alignment,
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed) ? splashColor ?? Colors.white.withOpacity(0.4) : null,
        ),
        elevation: WidgetStateProperty.all(elevation ?? 0),
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 12.0),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: widthBorder ?? 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
