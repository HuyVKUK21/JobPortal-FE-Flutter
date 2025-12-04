import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';

/// Utility class for application status colors, icons, and text
class StatusColors {
  StatusColors._();

  /// Get background color for application status
  static Color getBackgroundColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return AppColors.statusPendingBg;
      case 'review':
      case 'reviewed':
        return AppColors.statusReviewedBg;
      case 'interview_scheduled':
      case 'interview scheduled':
      case 'interview':
        return AppColors.statusInterviewBg;
      case 'accepted':
      case 'approved':
      case 'accept':
        return AppColors.statusAcceptedBg;
      case 'rejected':
      case 'declined':
      case 'reject':
        return AppColors.statusRejectedBg;
      case 'cancelled':
      case 'cancel':
        return AppColors.statusCancelledBg;
      case 'sent':
      case 'submitted':
        return AppColors.statusSentBg;
      default:
        return AppColors.statusDefaultBg;
    }
  }

  /// Get text color for application status
  static Color getTextColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return AppColors.statusPendingText;
      case 'review':
      case 'reviewed':
        return AppColors.statusReviewedText;
      case 'interview_scheduled':
      case 'interview scheduled':
      case 'interview':
        return AppColors.statusInterviewText;
      case 'accepted':
      case 'approved':
      case 'accept':
        return AppColors.statusAcceptedText;
      case 'rejected':
      case 'declined':
      case 'reject':
        return AppColors.statusRejectedText;
      case 'cancelled':
      case 'cancel':
        return AppColors.statusCancelledText;
      case 'sent':
      case 'submitted':
        return AppColors.statusSentText;
      default:
        return AppColors.statusDefaultText;
    }
  }

  /// Get icon for application status
  static IconData getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'review':
      case 'reviewed':
        return Icons.visibility;
      case 'interview_scheduled':
      case 'interview scheduled':
      case 'interview':
        return Icons.event;
      case 'accepted':
      case 'approved':
      case 'accept':
        return Icons.check_circle;
      case 'rejected':
      case 'declined':
      case 'reject':
        return Icons.cancel;
      case 'cancelled':
      case 'cancel':
        return Icons.close;
      case 'sent':
      case 'submitted':
        return Icons.send;
      default:
        return Icons.help_outline;
    }
  }

  /// Get status text label
  static String getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return AppStrings.applicationPending;
      case 'review':
      case 'reviewed':
        return AppStrings.applicationReviewed;
      case 'interview_scheduled':
      case 'interview scheduled':
      case 'interview':
        return AppStrings.applicationInterviewScheduled;
      case 'accepted':
      case 'approved':
      case 'accept':
        return AppStrings.applicationAccepted;
      case 'rejected':
      case 'declined':
      case 'reject':
        return AppStrings.applicationRejected;
      case 'cancelled':
      case 'cancel':
        return AppStrings.applicationCancelled;
      case 'sent':
      case 'submitted':
        return AppStrings.applicationSent;
      default:
        return AppStrings.unknownStatus;
    }
  }

  /// Alias for getTextColor (for badge color)
  static Color getColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF59E0B); // Yellow/Orange
      case 'review':
      case 'reviewed':
        return const Color(0xFF3B82F6); // Blue
      case 'interview_scheduled':
      case 'interview scheduled':
      case 'interview':
        return const Color(0xFF0EA5E9); // Sky Blue
      case 'accepted':
      case 'approved':
      case 'accept':
        return const Color(0xFF10B981); // Green
      case 'rejected':
      case 'declined':
      case 'reject':
        return const Color(0xFFEF4444); // Red
      case 'cancelled':
      case 'cancel':
        return const Color(0xFF6B7280); // Gray
      case 'sent':
      case 'submitted':
        return const Color(0xFF8B5CF6); // Purple
      default:
        return const Color(0xFF9CA3AF); // Light Gray
    }
  }

  /// Alias for getStatusText
  static String getText(String? status) {
    return getStatusText(status);
  }
}
