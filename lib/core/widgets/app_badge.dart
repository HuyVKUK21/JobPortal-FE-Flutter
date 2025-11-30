import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

/// Reusable badge widget
class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;

  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderRadius = 8,
    this.fontSize = 12,
  });

  /// Success badge (green)
  factory AppBadge.success(String text) {
    return AppBadge(
      text: text,
      backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
      textColor: const Color(0xFF10B981),
    );
  }

  /// Warning badge (orange)
  factory AppBadge.warning(String text) {
    return AppBadge(
      text: text,
      backgroundColor: const Color(0xFFF59E0B).withOpacity(0.1),
      textColor: const Color(0xFFF59E0B),
    );
  }

  /// Error badge (red)
  factory AppBadge.error(String text) {
    return AppBadge(
      text: text,
      backgroundColor: AppColors.error.withOpacity(0.1),
      textColor: AppColors.error,
    );
  }

  /// Info badge (blue)
  factory AppBadge.info(String text) {
    return AppBadge(
      text: text,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      textColor: AppColors.primary,
    );
  }

  /// Neutral badge (gray)
  factory AppBadge.neutral(String text) {
    return AppBadge(
      text: text,
      backgroundColor: AppColors.grey200,
      textColor: AppColors.textSecondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.primary,
        ),
      ),
    );
  }
}
