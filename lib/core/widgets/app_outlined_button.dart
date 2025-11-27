import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double borderWidth;
  final double? width;
  final double borderRadius;
  final IconData? icon;
  final bool iconAfterText;
  final EdgeInsets padding;
  final Color? backgroundColor;

  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.borderColor,
    required this.textColor,
    this.borderWidth = 2.5,
    this.width,
    this.borderRadius = 16,
    this.icon,
    this.iconAfterText = false,
    this.padding = const EdgeInsets.symmetric(vertical: 18),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          side: BorderSide(color: borderColor, width: borderWidth),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && !iconAfterText) ...[
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: 0.5,
              ),
            ),
            if (icon != null && iconAfterText) ...[
              const SizedBox(width: 8),
              Icon(icon, color: textColor, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
