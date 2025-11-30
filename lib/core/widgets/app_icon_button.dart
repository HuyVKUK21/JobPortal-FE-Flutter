import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

/// Reusable icon button with consistent styling
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
    this.iconSize = 20,
    this.tooltip,
  });

  /// Primary icon button
  factory AppIconButton.primary({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      iconColor: Colors.white,
      tooltip: tooltip,
    );
  }

  /// Secondary icon button (outlined)
  factory AppIconButton.secondary({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return AppIconButton(
      icon: icon,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      iconColor: AppColors.textPrimary,
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.grey200,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: IconButton(
        icon: Icon(icon, size: iconSize),
        color: iconColor ?? AppColors.textPrimary,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
