import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:go_router/go_router.dart';

/// Placeholder page shown in Profile tab when user is not authenticated
class ProfilePlaceholderPage extends StatelessWidget {
  const ProfilePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceXL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceXL),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceL),
                const Text(
                  'Chào mừng bạn!',
                  style: TextStyle(
                    fontSize: AppDimensions.fontLargeTitle,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'SF Pro',
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Text(
                  'Đăng nhập để truy cập hồ sơ và quản lý ứng tuyển của bạn',
                  style: TextStyle(
                    fontSize: AppDimensions.fontL,
                    color: Colors.grey[600],
                    fontFamily: 'SF Pro',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spaceXXL),
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed('login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radius),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space),
                TextButton(
                  onPressed: () {
                    context.pushNamed('register');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chưa có tài khoản? ',
                        style: TextStyle(
                          fontSize: AppDimensions.fontM,
                          color: Colors.grey[700],
                          fontFamily: 'SF Pro',
                        ),
                      ),
                      const Text(
                        'Đăng ký',
                        style: TextStyle(
                          fontSize: AppDimensions.fontM,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    ],
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
















