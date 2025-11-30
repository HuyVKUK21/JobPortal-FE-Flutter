import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/presentations/widgets/banner_home_page.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/presentations/widgets/header_section.dart';
import 'package:flutter_application_1/presentations/widgets/job_category.dart';
import 'package:flutter_application_1/presentations/widgets/search_box.dart';
import 'package:flutter_application_1/presentations/widgets/title_category_header.dart';
import 'package:flutter_application_1/presentations/widgets/featured_company_card.dart';
import 'package:flutter_application_1/presentations/pages/company_detail_page.dart';
import 'package:flutter_application_1/presentations/pages/featured_companies_page.dart';
import 'package:flutter_application_1/presentations/pages/all_jobs_page.dart';
import 'package:flutter_application_1/core/providers/job_provider.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/features/salary_calculator/presentation/pages/salary_calculator_page_refactored.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_1/core/constants/lottie_assets.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load jobs when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobProvider.notifier).getAllJobs();
      
      // Load saved jobs if user is authenticated
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.read(applicationProvider.notifier).getSavedJobs(currentUser.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes and load saved jobs when user logs in
    ref.listen(currentUserProvider, (previous, current) {
      if (current != null && previous == null) {
        // User just logged in, load saved jobs
        ref.read(applicationProvider.notifier).getSavedJobs(current.userId);
      }
    });

    final jobs = ref.watch(jobsProvider);
    final savedJobs = ref.watch(savedJobsProvider);
    final isLoading = ref.watch(jobLoadingProvider);
    final error = ref.watch(jobErrorProvider);
    

    List<String> categories = [
      'Tất cả',
      'Tài chính',
      'IT',
      'Quản lý',
      'Gia sư',
    ];
    SizeConfig.init(context);
    
    // Show full-screen error if jobs API fails (most critical)
    if (error != null && !isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    error.toLowerCase().contains('network')
                        ? LottieAssets.noInternet
                        : LottieAssets.error404,
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    error.toLowerCase().contains('network')
                        ? 'Không có kết nối mạng'
                        : 'Có lỗi xảy ra',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    error.toLowerCase().contains('network')
                        ? 'Vui lòng kiểm tra kết nối internet của bạn'
                        : error,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(jobProvider.notifier).getAllJobs();
                      final currentUser = ref.read(currentUserProvider);
                      if (currentUser != null) {
                        ref.read(applicationProvider.notifier).getSavedJobs(currentUser.userId);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Thử lại',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppScreenLayout(
        child: Column(
          children: [
            HeaderSection(
              onPressed: () {
                context.pushNamed("notification");
              },
            ),
            const SizedBox(height: AppDimensions.space),
            const SearchBox(),
            const SizedBox(height: AppDimensions.space),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const BannerHomePage(),
                    const SizedBox(height: 24),
                    
                    // Featured Companies Section
                    TitleCategoryHeader(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeaturedCompaniesPage(),
                          ),
                        );
                      },
                      titleCategoryHeader: 'Thương hiệu lớn tiêu biểu',
                    ),
                    const SizedBox(height: 16),
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
                            salaryBadge: '120+ việc',
                            isFollowing: false,
                            onFollowTap: () {},
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CompanyDetailPage(
                                    companyName: 'Ngân Hàng TMCP Việt Nam Thịnh Vượng (VPBank)',
                                    category: 'Ngân hàng',
                                    logoAsset: 'assets/logo_lutech.png',
                                    location: 'Hà Nội, Việt Nam',
                                    employeeCount: 5000,
                                    website: 'www.vpbank.com.vn',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          FeaturedCompanyCard(
                            companyName: 'NGÂN HÀNG THƯƠNG MẠI CỔ PHẦN KỸ THƯƠNG VIỆT NAM',
                            category: 'Ngân hàng',
                            logoAsset: 'assets/logo_google.png',
                            salaryBadge: '150+ việc',
                            isFollowing: false,
                            onFollowTap: () {},
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CompanyDetailPage(
                                    companyName: 'NGÂN HÀNG THƯƠNG MẠI CỔ PHẦN KỸ THƯƠNG VIỆT NAM',
                                    category: 'Ngân hàng',
                                    logoAsset: 'assets/logo_google.png',
                                    location: 'TP. Hồ Chí Minh, Việt Nam',
                                    employeeCount: 8000,
                                    website: 'www.techcombank.com.vn',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          FeaturedCompanyCard(
                            companyName: 'CÔNG TY CỔ PHẦN TẬP ĐOÀN TRƯỜNG HẢI',
                            category: 'Sản xuất',
                            logoAsset: 'assets/logo_lutech.png',
                            salaryBadge: '80+ việc',
                            isFollowing: false,
                            onFollowTap: () {},
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CompanyDetailPage(
                                    companyName: 'CÔNG TY CỔ PHẦN TẬP ĐOÀN TRƯỜNG HẢI',
                                    category: 'Sản xuất',
                                    logoAsset: 'assets/logo_lutech.png',
                                    location: 'Quảng Nam, Việt Nam',
                                    employeeCount: 15000,
                                    website: 'www.thaco.com.vn',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          FeaturedCompanyCard(
                            companyName: 'TẬP ĐOÀN CÔNG NGHIỆP - VIỄN THÔNG QUÂN ĐỘI',
                            category: 'Viễn thông',
                            logoAsset: 'assets/logo_google.png',
                            salaryBadge: '200+ việc',
                            isFollowing: true,
                            onFollowTap: () {},
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CompanyDetailPage(
                                    companyName: 'TẬP ĐOÀN CÔNG NGHIỆP - VIỄN THÔNG QUÂN ĐỘI',
                                    category: 'Viễn thông',
                                    logoAsset: 'assets/logo_google.png',
                                    location: 'Hà Nội, Việt Nam',
                                    employeeCount: 20000,
                                    website: 'www.viettel.com.vn',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Salary Calculator Banner
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SalaryCalculatorPageRefactored(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.calculate_outlined,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Công cụ tính lương',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tính lương Gross - Net nhanh chóng',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXXL),
                    
                    TitleCategoryHeader(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllJobsPage(
                              title: 'Việc làm đề xuất',
                            ),
                          ),
                        );
                      },
                      titleCategoryHeader: AppStrings.recommendedJobs,
                    ),
                    const SizedBox(height: AppDimensions.space),
                    // Show loading indicator
                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    // Show API jobs if available, otherwise show static job
                    else if (jobs.isNotEmpty) 
                      ...jobs.map((job) {
                        final isSaved = savedJobs.any((savedJob) => savedJob.job?.jobId == job.jobId);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: InkWell(
                            onTap: () {
                              context.pushNamed("jobDetail", pathParameters: {'jobId': job.jobId.toString()});
                            },
                            child: CardItemJob(
                              titleJob: job.title,
                              conpanyJob: job.company?.name ?? 'Công ty',
                              location: job.location,
                              workLocation: job.workLocation ?? 'TP. Huế & 2 nơi khác',
                              workingTime: job.jobType ?? 'Full Time',
                              workSalary: job.salaryRange ?? '40 - 80 triệu /tháng',
                              logoCompany: 'assets/logo_lutech.png',
                              isSaved: isSaved,
                              onBookmarkTap: () {
                                if (isSaved) {
                                  _handleUnsaveJob(job.jobId);
                                } else {
                                  _handleSaveJob(job.jobId);
                                }
                              },
                            ),
                          ),
                        );
                      })
                    else
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
                    const SizedBox(height: AppDimensions.space),
                    TitleCategoryHeader(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllJobsPage(
                              title: 'Việc làm mới nhất',
                            ),
                          ),
                        );
                      },
                      titleCategoryHeader: AppStrings.latestJobs,
                    ),
                    const SizedBox(height: AppDimensions.space),
                    JobCategory(categories: categories),
                    const SizedBox(height: AppDimensions.space),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSaveJob(int jobId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để lưu việc làm'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Check if job is already saved
    final savedJobs = ref.read(savedJobsProvider);
    final isAlreadySaved = savedJobs.any((savedJob) => savedJob.job?.jobId == jobId);
    
    if (isAlreadySaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Việc làm này đã được lưu rồi!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await ref.read(applicationProvider.notifier).saveJob(currentUser.userId, jobId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã lưu việc làm thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleUnsaveJob(int jobId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    try {
      await ref.read(applicationProvider.notifier).unsaveJob(currentUser.userId, jobId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã bỏ lưu việc làm'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

