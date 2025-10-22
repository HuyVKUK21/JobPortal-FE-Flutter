import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/core/widgets/search_field.dart';
import 'package:flutter_application_1/core/widgets/section_header.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/category_filter.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/home_banner.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/home_header.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_card.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Tất cả',
      'Tài chính',
      'IT',
      'Quản lý',
      'Gia sư',
    ];

    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            HomeHeader(
              onNotificationTap: () {
                context.pushNamed("notification");
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                context.pushNamed('searchJobs');
              },
              child: const AbsorbPointer(
                child: SearchField(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const HomeBanner(),
                    const SizedBox(height: 16),
                    SectionHeader(
                      title: 'Việc làm đề xuất',
                      actionText: 'Xem tất cả',
                      onActionPressed: () {},
                    ),
                    const SizedBox(height: 16),
                    JobCard(
                      title: 'Flutter Developer',
                      companyName: 'Lutech Digital',
                      location: 'Toà nhà 18 Lê Lợi',
                      workLocation: 'TP. Huế & 2 nơi khác',
                      workingTime: 'Full Time',
                      salary: '40 - 80 triệu /tháng',
                      companyLogo: 'assets/logo_lutech.png',
                      onTap: () {
                        context.pushNamed('jobDetail');
                      },
                    ),
                    const SizedBox(height: 16),
                    SectionHeader(
                      title: 'Việc làm mới nhất',
                      actionText: 'Xem tất cả',
                      onActionPressed: () {
                        context.pushNamed("latestJobs");
                      },
                    ),
                    const SizedBox(height: 16),
                    CategoryFilter(categories: categories),
                    const SizedBox(height: 16),
                    JobCard(
                      title: 'UX/UI Designer',
                      companyName: 'Google LLC',
                      location: 'Văn phòng đại diện Hà Nội',
                      workLocation: 'TP. Huế & 2 nơi khác',
                      workingTime: 'Full Time',
                      salary: '40 - 60 triệu /tháng',
                      companyLogo: 'assets/logo_google.png',
                    ),
                    const SizedBox(height: 16),
                    JobCard(
                      title: 'UX/UI Designer',
                      companyName: 'Google LLC',
                      location: 'Văn phòng đại diện Hà Nội',
                      workLocation: 'TP. Huế & 2 nơi khác',
                      workingTime: 'Full Time',
                      salary: '40 - 60 triệu /tháng',
                      companyLogo: 'assets/logo_google.png',
                    ),
                    const SizedBox(height: 16),
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

