import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';

/// Social authentication button (Google, Facebook, etc.)
class SocialAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? iconPath;
  final IconData? icon;
  final Color? iconColor;
  final String text;

  const SocialAuthButton({
    super.key,
    required this.onPressed,
    this.iconPath,
    this.icon,
    this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.buttonHeightMedium,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(
          color: AppColors.borderLight,
          width: AppDimensions.borderWidthThick,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconPath != null)
                  Image.asset(
                    iconPath!,
                    width: AppDimensions.iconM,
                    height: AppDimensions.iconM,
                    fit: BoxFit.contain,
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: iconColor ?? AppColors.textSecondary,
                    size: AppDimensions.iconM,
                  ),
                const SizedBox(width: AppDimensions.spaceS),
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontM,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
