import 'package:flutter/material.dart';

/// Reusable card widget with consistent styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final Border? border;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color = Colors.white,
    this.borderRadius = 16,
    this.boxShadow,
    this.gradient,
    this.border,
    this.onTap,
  });

  /// Card with default shadow
  factory AppCard.shadow({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? color,
    double borderRadius = 16,
  }) {
    return AppCard(
      padding: padding,
      margin: margin,
      color: color,
      borderRadius: borderRadius,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      child: child,
    );
  }

  /// Card with elevated shadow
  factory AppCard.elevated({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? color,
    double borderRadius = 16,
  }) {
    return AppCard(
      padding: padding,
      margin: margin,
      color: color,
      borderRadius: borderRadius,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
      child: child,
    );
  }

  /// Card with border only
  factory AppCard.outlined({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color borderColor = const Color(0xFFE5E7EB),
    double borderRadius = 16,
  }) {
    return AppCard(
      padding: padding,
      margin: margin,
      color: Colors.white,
      borderRadius: borderRadius,
      border: Border.all(color: borderColor, width: 1),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}
