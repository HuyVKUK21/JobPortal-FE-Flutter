import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';

/// Utility class for application status colors and text
class StatusColors {
  StatusColors._();

  /// Get background color for application status
  static Color getBackgroundColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'sent':
      case 'submitted':
        return AppColors.statusSentBg;
      case 'accepted':
      case 'approved':
        return AppColors.statusAcceptedBg;
      case 'rejected':
      case 'declined':
        return AppColors.statusRejectedBg;
      case 'pending':
      case 'review':
        return AppColors.statusPendingBg;
      default:
        return AppColors.statusDefaultBg;
    }
  }

  /// Get text color for application status
  static Color getTextColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'sent':
      case 'submitted':
        return AppColors.statusSentText;
      case 'accepted':
      case 'approved':
        return AppColors.statusAcceptedText;
      case 'rejected':
      case 'declined':
        return AppColors.statusRejectedText;
      case 'pending':
      case 'review':
        return AppColors.statusPendingText;
      default:
        return AppColors.statusDefaultText;
    }
  }

  /// Get status text label
  static String getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'sent':
      case 'submitted':
        return AppStrings.applicationSent;
      case 'accepted':
      case 'approved':
        return AppStrings.applicationAccepted;
      case 'rejected':
      case 'declined':
        return AppStrings.applicationRejected;
      case 'pending':
      case 'review':
        return AppStrings.applicationPending;
      default:
        return AppStrings.unknownStatus;
    }
  }

  /// Alias for getTextColor (for badge color)
  static Color getColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'sent':
      case 'submitted':
        return const Color(0xFF3B82F6); // Blue
      case 'accepted':
      case 'approved':
        return const Color(0xFF10B981); // Green
      case 'rejected':
      case 'declined':
        return const Color(0xFFEF4444); // Red
      case 'pending':
      case 'review':
        return const Color(0xFFF59E0B); // Yellow/Orange
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  /// Alias for getStatusText
  static String getText(String? status) {
    return getStatusText(status);
  }
}
