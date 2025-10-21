import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/presentations/pages/application_notification.dart';
import 'package:flutter_application_1/presentations/pages/general_notification.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';

class NotificationPageScreen extends StatelessWidget {
  const NotificationPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Thông báo',
              iconHeaderLeftBar: Icons.arrow_back,
              iconHeaderRightBar: Icons.more_horiz_rounded,
            ),
            SizedBox(height: 16),
            const Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      indicatorWeight: 2.5,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      tabs: [
                        Tab(text: 'Chung'),
                        Tab(text: 'Ứng tuyển'),
                      ],
                    ),
                    Expanded(
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
