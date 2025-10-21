import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/presentations/widgets/search_box.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';

class SavedJobScreen extends StatelessWidget {
  const SavedJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Việc làm đã lưu',
              iconHeaderLeftBar: Icons.account_circle,
              iconHeaderRightBar: Icons.more_horiz_sharp,
            ),
            SizedBox(height: 24),
            SearchBox(),
            SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CardItemJob(
                      titleJob: 'Flutter Developer',
                      conpanyJob: 'Lutech Digital',
                      location: 'Toà nhà 18 Lê Lợi',
                      workLocation: 'TP. Huế & 2 nơi khác',
                      workingTime: 'Full Time',
                      workSalary: '40 - 80 triệu /tháng',
                      logoCompany: 'assets/logo_lutech.png',
                    ),
                    SizedBox(height: 16),
                    CardItemJob(
                      titleJob: 'UX/UI Designer',
                      conpanyJob: 'Google LLC',
                      location: 'Văn phòng đại diện Hà Nội',
                      workLocation: 'TP. Huế & 2 nơi khác',
                      workingTime: 'Full Time',
                      workSalary: '40 - 60 triệu /tháng',
                      logoCompany: 'assets/logo_google.png',
                    ),
                    SizedBox(height: 16),
                    CardItemJob(
                      titleJob: 'UX/UI Designer',
                      conpanyJob: 'Google LLC',
                      location: 'Văn phòng đại diện Hà Nội',
                      workLocation: 'TP. Huế & 2 nơi khác',
                      workingTime: 'Full Time',
                      workSalary: '40 - 60 triệu /tháng',
                      logoCompany: 'assets/logo_google.png',
                    ),
                    SizedBox(height: 16),
                    CardItemJob(
                      titleJob: 'Flutter Developer',
                      conpanyJob: 'Lutech Digital',
                      location: 'Toà nhà 18 Lê Lợi',
                      workLocation: 'TP. Huế & 2 nơi khác',
                      workingTime: 'Full Time',
                      workSalary: '40 - 80 triệu /tháng',
                      logoCompany: 'assets/logo_lutech.png',
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
