import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/presentations/widgets/banner_home_page.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/presentations/widgets/header_section.dart';
import 'package:flutter_application_1/presentations/widgets/job_category.dart';
import 'package:flutter_application_1/presentations/widgets/search_box.dart';
import 'package:flutter_application_1/presentations/widgets/title_category_header.dart';
import 'package:flutter_application_1/presentations/widgets/featured_company_card.dart';
import 'package:go_router/go_router.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> categories = [
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
            HeaderSection(
              onPressed: () {
                context.pushNamed("notication");
              },
            ),
            SizedBox(height: 16),
            SearchBox(),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BannerHomePage(),
                    SizedBox(height: 24),
                    
                    // Featured Companies Section
                    TitleCategoryHeader(
                      onPressed: () {},
                      titleCategoryHeader: 'Thương hiệu lớn tiêu biểu',
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 280,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        children: [
                          FeaturedCompanyCard(
                            companyName: 'Ngân Hàng TMCP Việt Nam Thịnh Vượng (VPBank)',
                            category: 'Ngân hàng',
                            logoAsset: 'assets/logo_lutech.png',
                            salaryBadge: 'VNR500',
                            isFollowing: false,
                            onFollowTap: () {},
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          FeaturedCompanyCard(
                            companyName: 'NGÂN HÀNG THƯƠNG MẠI CỔ PHẦN KỸ THƯƠNG VIỆT NAM',
                            category: 'Ngân hàng',
                            logoAsset: 'assets/logo_google.png',
                            salaryBadge: 'VNR500',
                            isFollowing: false,
                            onFollowTap: () {},
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          FeaturedCompanyCard(
                            companyName: 'CÔNG TY CỔ PHẦN TẬP ĐOÀN TRƯỜNG HẢI',
                            category: 'Sản xuất',
                            logoAsset: 'assets/logo_lutech.png',
                            isFollowing: false,
                            onFollowTap: () {},
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          FeaturedCompanyCard(
                            companyName: 'TẬP ĐOÀN CÔNG NGHIỆP - VIỄN THÔNG QUÂN ĐỘI',
                            category: 'Viễn thông',
                            logoAsset: 'assets/logo_google.png',
                            isFollowing: true,
                            onFollowTap: () {},
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    TitleCategoryHeader(
                      onPressed: () {},
                      titleCategoryHeader: 'Việc làm đề xuất',
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        context.pushNamed("jobDetails");
                      },
                      child: CardItemJob(
                        titleJob: 'Flutter Developer',
                        conpanyJob: 'Lutech Digital',
                        location: 'Toà nhà 18 Lê Lợi',
                        workLocation: 'TP. Huế & 2 nơi khác',
                        workingTime: 'Full Time',
                        workSalary: '40 - 80 triệu /tháng',
                        logoCompany: 'assets/logo_lutech.png',
                      ),
                    ),
                    SizedBox(height: 16),
                    TitleCategoryHeader(
                      onPressed: () {
                        context.pushNamed("lastestJob");
                      },
                      titleCategoryHeader: 'Việc làm mới nhất',
                    ),
                    SizedBox(height: 16),
                    JobCategory(categories: categories),
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
