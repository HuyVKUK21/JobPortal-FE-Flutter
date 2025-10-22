import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/presentations/widgets/item_application_notification.dart';
import 'package:flutter_application_1/presentations/widgets/search_box.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';
import 'package:go_router/go_router.dart';

class ApplicationScreen extends StatelessWidget {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Ứng tuyển',
              iconHeaderLeftBar: Icons.account_circle,
              iconHeaderRightBar: Icons.more_horiz_sharp,
            ),
            SizedBox(height: 24),
            SearchBox(),
            Expanded(
              child: ListView(
                children: [
                  InkWell(
                    onTap: () {
                      context.pushNamed('applicationDetail');
                    },
                  ),
                  ItemApplicationNotification(),
                  ItemApplicationNotification(),
                  ItemApplicationNotification(),
                  ItemApplicationNotification(),
                  ItemApplicationNotification(),
                  ItemApplicationNotification(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
