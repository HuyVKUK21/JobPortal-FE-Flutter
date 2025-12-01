import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/widgets/widgets.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/core/providers/company_provider.dart';
import 'package:flutter_application_1/core/models/job.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/providers/saved_company_provider.dart';
import 'package:flutter_application_1/core/utils/salary_formatter.dart';
import 'package:flutter_application_1/presentations/pages/company_jobs_page.dart';
import 'package:flutter_application_1/presentations/pages/featured_companies_page.dart';


class CompanyDetailPage extends ConsumerStatefulWidget {
  final int? companyId;
  final String companyName;
  final String category;
  final String logoAsset;
  final String? description;
  final String? location;
  final String? website;
  final int? employeeCount;

  const CompanyDetailPage({
    super.key,
    this.companyId,
    required this.companyName,
    required this.category,
    required this.logoAsset,
    this.description,
    this.location,
    this.website,
    this.employeeCount,
  });

  @override
  ConsumerState<CompanyDetailPage> createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends ConsumerState<CompanyDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load saved jobs when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.read(applicationProvider.notifier).getSavedJobs(currentUser.userId);
        ref.read(savedCompaniesNotifierProvider.notifier).getSavedCompanies(currentUser.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              // Check if company is saved
              final savedCompanies = ref.watch(savedCompaniesProvider);
              final isSaved = widget.companyId != null && 
                  savedCompanies.any((sc) => sc.company.id == widget.companyId);
              
              return IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (widget.companyId == null) return;
                  
                  final currentUser = ref.read(currentUserProvider);
                  if (currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng đăng nhập để lưu công ty'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  
                  if (isSaved) {
                    // Unsave company
                    ref.read(savedCompaniesNotifierProvider.notifier).unsaveCompany(
                      currentUser.userId,
                      widget.companyId!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã bỏ lưu công ty'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFF6B7280),
                      ),
                    );
                  } else {
                    // Save company
                    ref.read(savedCompaniesNotifierProvider.notifier).saveCompany(
                      currentUser.userId,
                      widget.companyId!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã lưu công ty'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF8F9FA),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Header with Elegant Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 100, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF667EEA),
                    const Color(0xFF764BA2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Logo
                  AppCard.elevated(
                    padding: const EdgeInsets.all(16),
                    margin: EdgeInsets.zero,
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: Image.asset(
                        widget.logoAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Company Name
                  Text(
                    widget.companyName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.category,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Follow Button
                  Consumer(
                    builder: (context, ref, child) {
                      // Check if company is saved
                      final savedCompanies = ref.watch(savedCompaniesProvider);
                      final isSaved = widget.companyId != null && 
                          savedCompanies.any((sc) => sc.company.id == widget.companyId);
                      
                      return AppButton(
                        text: isSaved ? 'Đang theo dõi' : 'Theo dõi công ty',
                        onPressed: () {
                          if (widget.companyId == null) return;
                          
                          final currentUser = ref.read(currentUserProvider);
                          if (currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vui lòng đăng nhập để lưu công ty'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          
                          if (isSaved) {
                            // Unsave company
                            ref.read(savedCompaniesNotifierProvider.notifier).unsaveCompany(
                              currentUser.userId,
                              widget.companyId!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã bỏ theo dõi công ty'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Color(0xFF6B7280),
                              ),
                            );
                          } else {
                            // Save company
                            ref.read(savedCompaniesNotifierProvider.notifier).saveCompany(
                              currentUser.userId,
                              widget.companyId!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã theo dõi công ty'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Color(0xFF10B981),
                              ),
                            );
                          }
                        },
                        icon: isSaved ? Icons.check : Icons.add,
                        backgroundColor: isSaved ? const Color(0xFFE5E7EB) : Colors.white,
                        textColor: isSaved ? const Color(0xFF6B7280) : const Color(0xFF4285F4),
                        width: double.infinity,
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Statistics Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      Icons.work_outline,
                      '${(widget.employeeCount ?? 1000) ~/ 100}+',
                      'Việc làm',
                      const Color(0xFF4285F4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.people_outline,
                      '${widget.employeeCount ?? 1000}+',
                      'Nhân viên',
                      const Color(0xFF26C281),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.location_on_outlined,
                      '5+',
                      'Chi nhánh',
                      const Color(0xFFFF6B00),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Company Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin công ty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    'Địa điểm',
                    widget.location ?? 'Hà Nội, Việt Nam',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.people_outline,
                    'Quy mô',
                    '${widget.employeeCount ?? 1000}+ nhân viên',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.language,
                    'Website',
                    widget.website ?? 'www.company.com',
                  ),
                  const SizedBox(height: 24),
                  
                  // Benefits Section
                  const Text(
                    'Phúc lợi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppBadge(text: '💰 Lương thưởng hấp dẫn', backgroundColor: const Color(0xFFF0F9FF), textColor: const Color(0xFF0284C7)),
                      AppBadge(text: '🏥 Bảo hiểm sức khỏe', backgroundColor: const Color(0xFFF0FDF4), textColor: const Color(0xFF16A34A)),
                      AppBadge(text: '🏖️ Du lịch hàng năm', backgroundColor: const Color(0xFFFEF3C7), textColor: const Color(0xFFD97706)),
                      AppBadge(text: '📚 Đào tạo & Phát triển', backgroundColor: const Color(0xFFF5F3FF), textColor: const Color(0xFF7C3AED)),
                      AppBadge(text: '🎂 Sinh nhật & Lễ tết', backgroundColor: const Color(0xFFFCE7F3), textColor: const Color(0xFFDB2777)),
                      AppBadge(text: '⚖️ Work-life balance', backgroundColor: const Color(0xFFECFCCB), textColor: const Color(0xFF65A30D)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Jobs Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Việc làm đang tuyển',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (widget.companyId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompanyJobsPage(
                                  companyId: widget.companyId!,
                                  companyName: widget.companyName,
                                  logoAsset: widget.logoAsset,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Xem tất cả',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4285F4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Job Cards and Description from API
                  Consumer(
                    builder: (context, ref, child) {
                      if (widget.companyId == null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show description from widget if no companyId
                            const Text(
                              'Giới thiệu',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.description ?? 
                              'Công ty hàng đầu trong lĩnh vực ${widget.category}, cung cấp các giải pháp và dịch vụ chất lượng cao cho khách hàng.',
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Text(
                                'Không có thông tin công ty',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        );
                      }

                      final companyDetailsAsync = ref.watch(companyDetailsProvider(widget.companyId!));

                      return companyDetailsAsync.when(
                        data: (companyDetails) {
                          final jobsData = companyDetails.jobs;
                          
                          // Use description from API if available, otherwise use widget description
                          final displayDescription = companyDetails.description?.isNotEmpty == true 
                              ? companyDetails.description! 
                              : (widget.description ?? 
                                 'Công ty hàng đầu trong lĩnh vực ${widget.category}, cung cấp các giải pháp và dịch vụ chất lượng cao cho khách hàng.');

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Jobs list
                              if (jobsData.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Text(
                                    'Công ty hiện không có việc làm nào',
                                    style: TextStyle(color: AppColors.textSecondary),
                                  ),
                                )
                              else
                                Column(
                                  children: jobsData.take(3).map((jobJson) {
                                    final job = Job.fromJson(jobJson);
                                    
                                    // Get saved jobs list to check if this job is saved
                                    final savedJobs = ref.watch(savedJobsProvider);
                                    final isSaved = savedJobs.any((savedJob) => savedJob.job?.jobId == job.jobId);

                                    // Use SalaryFormatter for consistent display
                                    final salaryDisplay = SalaryFormatter.formatSalaryWithPeriod(
                                      salaryMin: job.salaryMin,
                                      salaryMax: job.salaryMax,
                                      salaryType: job.salaryType,
                                    );

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: CardItemJob(
                                        titleJob: job.title,
                                        conpanyJob: widget.companyName,
                                        location: job.location,
                                        workLocation: job.workLocation ?? 'Office',
                                        workingTime: job.jobType ?? 'Full Time',
                                        workSalary: salaryDisplay,
                                        logoCompany: widget.logoAsset,
                                        isSaved: isSaved,
                                        onBookmarkTap: () {
                                          if (isSaved) {
                                            _handleUnsaveJob(job.jobId);
                                          } else {
                                            _handleSaveJob(job.jobId);
                                          }
                                        },
                                        onTap: () {
                                          context.push('/jobDetail/${job.jobId}');
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              
                              const SizedBox(height: 24),
                              
                              // Description section
                              const Text(
                                'Giới thiệu',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                displayDescription,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                        error: (error, stack) => Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                              const SizedBox(height: 12),
                              Text(
                                'Không thể tải thông tin công ty',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () => ref.invalidate(companyDetailsProvider(widget.companyId!)),
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  
                  // Related Companies Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Các công ty khác',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to FeaturedCompaniesPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeaturedCompaniesPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Xem tất cả',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4285F4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            
            // Related Companies Horizontal List from API
            Consumer(
              builder: (context, ref, child) {
                final companiesAsync = ref.watch(featuredCompaniesProvider);
                
                return companiesAsync.when(
                  data: (companies) {
                    if (companies.isEmpty) {
                      return const SizedBox(
                        height: 240,
                        child: Center(
                          child: Text('Không có công ty nào'),
                        ),
                      );
                    }
                    
                    return SizedBox(
                      height: 240,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: companies.length > 6 ? 6 : companies.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final company = companies[index];
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                'companyDetail',
                                pathParameters: {'companyId': company.id.toString()},
                                extra: {
                                  'companyName': company.name,
                                  'category': company.industry,
                                  'logoAsset': company.logo ?? 'assets/logo_lutech.png',
                                  'location': company.location,
                                  'employeeCount': company.employeeCount ?? 0,
                                  'website': company.website ?? '',
                                  'description': company.description,
                                },
                              );
                            },
                            child: _buildRelatedCompanyCard(
                              company.name,
                              company.industry,
                              company.logo ?? 'assets/logo_lutech.png',
                              '${company.totalJobs}+',
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                  error: (error, stack) => const SizedBox(
                    height: 240,
                    child: Center(
                      child: Text('Không thể tải danh sách công ty'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
    ),
      ),

    );
  }

  Widget _buildRelatedCompanyCard(String name, String category, String logo, String jobs) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              logo,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            category,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$jobs việc làm',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF4285F4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF4285F4).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF4285F4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4285F4).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4285F4).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
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
