import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/saved_company_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/utils/salary_formatter.dart';
import 'package:flutter_application_1/core/widgets/widgets.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_1/core/constants/lottie_assets.dart';

class SavedItemsScreen extends ConsumerStatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  ConsumerState<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends ConsumerState<SavedItemsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load both saved jobs and saved companies when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.read(applicationProvider.notifier).getSavedJobs(currentUser.userId);
        ref.read(savedCompaniesNotifierProvider.notifier).getSavedCompanies(currentUser.userId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Đã lưu',
              iconHeaderLeftBar: Icons.account_circle,
              iconHeaderRightBar: Icons.more_horiz_sharp,
            ),
            const SizedBox(height: 16),
            
            // Improved Tab Bar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4285F4), Color(0xFF3367D6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4285F4).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF6B7280),
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work_outline, size: 18),
                        SizedBox(width: 6),
                        Text('Việc làm'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business_outlined, size: 18),
                        SizedBox(width: 6),
                        Text('Công ty'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSavedJobsTab(),
                  _buildSavedCompaniesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedJobsTab() {
    final savedJobs = ref.watch(savedJobsProvider);
    final isLoading = ref.watch(applicationLoadingProvider);
    final error = ref.watch(applicationErrorProvider);

    if (isLoading) {
      return const AppLoadingIndicator(
        message: 'Đang tải việc làm đã lưu...',
      );
    }

    if (error != null) {
      return _buildErrorState(
        error: error,
        onRetry: () {
          final currentUser = ref.read(currentUserProvider);
          if (currentUser != null) {
            ref.read(applicationProvider.notifier).getSavedJobs(currentUser.userId);
          }
        },
      );
    }

    if (savedJobs.isEmpty) {
      return _buildEmptyState(
        title: 'Chưa có việc làm đã lưu',
        message: 'Lưu các công việc bạn quan tâm để xem lại sau',
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: savedJobs.map((savedJob) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CardItemJob(
              titleJob: savedJob.job?.title ?? 'N/A',
              conpanyJob: savedJob.job?.company?.name ?? 'Công ty',
              location: savedJob.job?.location ?? 'N/A',
              workLocation: savedJob.job?.workLocation ?? '',
              workingTime: savedJob.job?.jobType ?? 'Full Time',
              workSalary: SalaryFormatter.formatSalaryWithPeriod(
                salaryMin: savedJob.job?.salaryMin,
                salaryMax: savedJob.job?.salaryMax,
                salaryType: savedJob.job?.salaryType,
              ),
              logoCompany: 'assets/logo_lutech.png',
              isSaved: true,
              onTap: () {
                if (savedJob.job?.jobId != null) {
                  context.pushNamed('jobDetail', pathParameters: {'jobId': savedJob.job!.jobId.toString()});
                }
              },
              onBookmarkTap: () {
                _showRemoveJobBottomSheet(context, savedJob);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSavedCompaniesTab() {
    final savedCompanies = ref.watch(savedCompaniesProvider);
    final isLoading = ref.watch(savedCompaniesLoadingProvider);
    final error = ref.watch(savedCompaniesErrorProvider);

    if (isLoading) {
      return const AppLoadingIndicator(
        message: 'Đang tải công ty đã lưu...',
      );
    }

    if (error != null) {
      return _buildErrorState(
        error: error,
        onRetry: () {
          final currentUser = ref.read(currentUserProvider);
          if (currentUser != null) {
            ref.read(savedCompaniesNotifierProvider.notifier).getSavedCompanies(currentUser.userId);
          }
        },
      );
    }

    if (savedCompanies.isEmpty) {
      return _buildEmptyState(
        title: 'Chưa có công ty đã lưu',
        message: 'Lưu các công ty bạn quan tâm để xem lại sau',
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: savedCompanies.map((savedCompany) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  context.pushNamed(
                    'companyDetail',
                    pathParameters: {'companyId': savedCompany.company.id.toString()},
                    extra: {
                      'companyName': savedCompany.company.name,
                      'category': savedCompany.company.industry,
                      'logoAsset': savedCompany.company.logo ?? 'assets/logo_lutech.png',
                      'location': savedCompany.company.location,
                      'employeeCount': savedCompany.company.employeeCount ?? 0,
                      'website': savedCompany.company.website ?? '',
                      'description': savedCompany.company.description,
                    },
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    // Company Logo
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        savedCompany.company.logo ?? 'assets/logo_lutech.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Company Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            savedCompany.company.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            savedCompany.company.industry,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.work_outline,
                                size: 14,
                                color: Color(0xFF4285F4),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${savedCompany.company.totalJobs} việc làm',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4285F4),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Remove Button
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark,
                        color: Color(0xFF4285F4),
                      ),
                      onPressed: () {
                        _showRemoveCompanyBottomSheet(context, savedCompany);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState({required String title, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              LottieAssets.noResultFound,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState({required String error, required VoidCallback onRetry}) {
    final isNetworkError = error.toLowerCase().contains('network');
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              isNetworkError ? LottieAssets.noInternet : LottieAssets.error404,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            Text(
              isNetworkError ? 'Không có kết nối mạng' : 'Có lỗi xảy ra',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isNetworkError 
                  ? 'Vui lòng kiểm tra kết nối internet và thử lại'
                  : error,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Thử lại',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveJobBottomSheet(BuildContext context, dynamic savedJob) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Xóa khỏi danh sách đã lưu?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Bạn có chắc chắn muốn xóa "${savedJob.job?.title ?? 'công việc này'}" khỏi danh sách đã lưu không?',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      text: 'Hủy',
                      onPressed: () => Navigator.pop(context),
                      borderColor: const Color(0xFFE5E7EB),
                      textColor: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Xóa',
                      onPressed: () {
                        final currentUser = ref.read(currentUserProvider);
                        if (currentUser != null && savedJob.job?.jobId != null) {
                          ref.read(applicationProvider.notifier).unsaveJob(
                            currentUser.userId,
                            savedJob.job!.jobId,
                          );
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xóa khỏi danh sách đã lưu'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      backgroundColor: const Color(0xFF4285F4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showRemoveCompanyBottomSheet(BuildContext context, dynamic savedCompany) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Xóa khỏi danh sách đã lưu?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Bạn có chắc chắn muốn xóa "${savedCompany.company.name}" khỏi danh sách đã lưu không?',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      text: 'Hủy',
                      onPressed: () => Navigator.pop(context),
                      borderColor: const Color(0xFFE5E7EB),
                      textColor: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Xóa',
                      onPressed: () {
                        final currentUser = ref.read(currentUserProvider);
                        if (currentUser != null) {
                          ref.read(savedCompaniesNotifierProvider.notifier).unsaveCompany(
                            currentUser.userId,
                            savedCompany.company.id,
                          );
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xóa khỏi danh sách đã lưu'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      backgroundColor: const Color(0xFF4285F4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
