import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/presentations/pages/application_notification.dart';
import 'package:flutter_application_1/presentations/pages/general_notification.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';

class NotificationPageScreen extends StatelessWidget {
  const NotificationPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Thông báo',
              iconHeaderLeftBar: Icons.arrow_back,
              iconHeaderRightBar: Icons.more_horiz_rounded,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(AppDimensions.radius),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppDimensions.radius),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: const TextStyle(
                          fontSize: AppDimensions.fontL,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: AppDimensions.fontL,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: const [
                          Tab(text: 'Chung'),
                          Tab(text: 'Ứng tuyển'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          GeneralNotification(),
                          ApplicationNotification(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
