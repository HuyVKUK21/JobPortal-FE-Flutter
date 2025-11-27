import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class ItemGeneralNotification extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final bool isNew;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? iconColor;

  const ItemGeneralNotification({
    super.key,
    required this.title,
    required this.message,
    required this.date,
    this.isNew = false,
    this.onTap,
    this.icon,
    this.iconColor,
  });

  // Get icon and color based on notification title
  Map<String, dynamic> _getIconData() {
    final titleLower = title.toLowerCase();
    
    if (titleLower.contains('security') || titleLower.contains('password') || titleLower.contains('bảo mật')) {
      return {'icon': Icons.verified_user, 'color': const Color(0xFF4285F4)};
    } else if (titleLower.contains('tips') || titleLower.contains('advice') || titleLower.contains('mẹo')) {
      return {'icon': Icons.lightbulb, 'color': const Color(0xFFFFA726)};
    } else if (titleLower.contains('account') || titleLower.contains('setup') || titleLower.contains('tài khoản')) {
      return {'icon': Icons.check_circle, 'color': const Color(0xFF26C281)};
    } else if (titleLower.contains('update') || titleLower.contains('cập nhật')) {
      return {'icon': Icons.system_update, 'color': const Color(0xFF9C27B0)};
    } else {
      return {'icon': Icons.notifications, 'color': const Color(0xFF42A5F5)};
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
                    // Title and date row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isNew ? FontWeight.w700 : FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (isNew) ...[
                          const SizedBox(width: 8),
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
                    const SizedBox(height: 4),
                    // Date
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Message
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
