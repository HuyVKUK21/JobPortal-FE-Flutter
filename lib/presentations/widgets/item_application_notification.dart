import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';

class ItemApplicationNotification extends StatelessWidget {
  final String title;
  final String company;
  final String? message;
  final bool isNew;
  final String date;
  final VoidCallback? onTap;
  final String? logoUrl;
  final Color? iconColor;
  final IconData? icon;

  const ItemApplicationNotification({
    super.key,
    required this.title,
    required this.company,
    this.message,
    this.isNew = false,
    required this.date,
    this.onTap,
    this.logoUrl,
    this.iconColor,
    this.icon,
  });

  // Get icon and color based on notification content
  Map<String, dynamic> _getIconData() {
    // Default colors for different job types
    final titleLower = title.toLowerCase();
    
    if (titleLower.contains('product') || titleLower.contains('management')) {
      return {'icon': Icons.business_center, 'color': const Color(0xFFFF6B9D)};
    } else if (titleLower.contains('ui') || titleLower.contains('designer')) {
      return {'icon': Icons.palette, 'color': const Color(0xFFFFA726)};
    } else if (titleLower.contains('quality') || titleLower.contains('assurance')) {
      return {'icon': Icons.verified_user, 'color': const Color(0xFFFF6B9D)};
    } else if (titleLower.contains('software') || titleLower.contains('engineer')) {
      return {'icon': Icons.code, 'color': const Color(0xFF42A5F5)};
    } else if (titleLower.contains('network') || titleLower.contains('administrator')) {
      return {'icon': Icons.router, 'color': const Color(0xFF26C281)};
    } else if (titleLower.contains('devops')) {
      return {'icon': Icons.settings_applications, 'color': const Color(0xFFFDD835)};
    } else {
      return {'icon': Icons.work, 'color': const Color(0xFF9C27B0)};
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final iconData = _getIconData();
    final displayIcon = icon ?? iconData['icon'] as IconData;
    final displayColor = iconColor ?? iconData['color'] as Color;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isNew ? const Color(0xFFF8F9FD) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Circular icon with colored background
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: displayColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                displayIcon,
                color: displayColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isNew ? FontWeight.w700 : FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Company and date
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          company,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text(
                        ' • ',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.grey500,
                        ),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                  // Message
                  if (message != null && message!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      message!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  // New badge
                  if (isNew) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4285F4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'MỚI',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}
