import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

/// Utility class for company brand colors
class CompanyColors {
  CompanyColors._();

  /// Get company brand color by company name
  static Color getColor(String companyName) {
    final name = companyName.toLowerCase();
    
    // Match known company brands
    if (name.contains('google')) {
      return AppColors.googleBlue;
    } else if (name.contains('paypal')) {
      return AppColors.paypalBlue;
    } else if (name.contains('figma')) {
      return AppColors.figmaOrange;
    } else if (name.contains('twitter')) {
      return AppColors.twitterBlue;
    } else if (name.contains('pinterest')) {
      return AppColors.pinterestRed;
    } else {
      // Generate color based on first letter for consistency
      return _getFallbackColor(companyName);
    }
  }

  /// Get company initial/logo letter
  static String getInitial(String companyName) {
    if (companyName.isEmpty) return '?';
    
    final name = companyName.toLowerCase();
    
    // Use specific initials for known brands
    if (name.contains('google')) return 'G';
    if (name.contains('paypal')) return 'P';
    if (name.contains('figma')) return 'F';
    if (name.contains('twitter')) return 'T';
    if (name.contains('pinterest')) return 'P';
    
    return companyName[0].toUpperCase();
  }

  /// Generate fallback color based on company name
  static Color _getFallbackColor(String companyName) {
    final firstChar = companyName.isNotEmpty ? companyName[0].toUpperCase() : 'A';
    final colors = [
      AppColors.companyIndigo,
      AppColors.companyPurple,
      AppColors.companyPink,
      AppColors.companyGreen,
      AppColors.companyAmber,
      AppColors.companyBlue,
    ];
    return colors[firstChar.codeUnitAt(0) % colors.length];
  }
}
