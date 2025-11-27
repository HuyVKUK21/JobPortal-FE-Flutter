import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';

/// Reusable filter button widget
class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;

  const FilterButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.tune,
    this.backgroundColor,
    this.iconColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? AppDimensions.buttonWidth;
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: AppDimensions.icon,
        ),
      ),
    );
  }
}
