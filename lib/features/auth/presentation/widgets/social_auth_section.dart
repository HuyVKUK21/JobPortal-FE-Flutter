import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/social_auth_button.dart';

/// Section containing social authentication buttons
class SocialAuthSection extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  const SocialAuthSection({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.borderLight,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space),
              child: Text(
                AppStrings.orLoginWith,
                style: TextStyle(
                  fontSize: AppDimensions.font,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.borderLight,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceL),
        Row(
          children: [
            Expanded(
              child: SocialAuthButton(
                onPressed: onGooglePressed,
                iconPath: 'assets/logo_google.png',
                text: AppStrings.google,
              ),
            ),
            const SizedBox(width: AppDimensions.space),
            Expanded(
              child: SocialAuthButton(
                onPressed: onFacebookPressed,
                icon: Icons.facebook,
                iconColor: AppColors.facebook,
                text: AppStrings.facebook,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
