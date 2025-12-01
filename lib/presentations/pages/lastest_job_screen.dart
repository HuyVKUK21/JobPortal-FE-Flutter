import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';

class LastestJobScreen extends StatelessWidget {
  const LastestJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Legacy page - categories removed, use empty list
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Việc làm mới nhất',
              iconHeaderLeftBar: Icons.arrow_back,
              iconHeaderRightBar: Icons.search,
            ),
            SizedBox(height: 16),
            // Category filter removed - legacy page
            SizedBox(height: 16),
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
                      titleJob: 'UX/UI Designer',
                      conpanyJob: 'Google LLC',
                      location: 'Văn phòng đại diện Hà Nội',
                      workLocation: 'TP. Huế & 2 nơi khác',
                      workingTime: 'Full Time',
                      workSalary: '40 - 60 triệu /tháng',
                      logoCompany: 'assets/logo_google.png',
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
