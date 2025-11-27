import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class AppGradients {
  AppGradients._();

  // Primary gradients
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF4285F4), Color(0xFF3367D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient error = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background gradients
  static final LinearGradient navBarBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Colors.grey.shade50,
    ],
  );

  static final LinearGradient bottomNavBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xFFF8F9FA).withOpacity(0.95),
      Colors.white.withOpacity(0.98),
    ],
  );

  // Active state gradients
  static LinearGradient activeItemBackground = LinearGradient(
    colors: [
      AppColors.primary.withOpacity(0.15),
      AppColors.primary.withOpacity(0.08),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
