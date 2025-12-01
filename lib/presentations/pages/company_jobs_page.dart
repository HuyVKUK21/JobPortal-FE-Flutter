import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/core/providers/company_provider.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/utils/salary_formatter.dart';
import 'package:flutter_application_1/core/models/job.dart';
import 'package:go_router/go_router.dart';

class CompanyJobsPage extends ConsumerStatefulWidget {
  final int companyId;
  final String companyName;
  final String logoAsset;

  const CompanyJobsPage({
    super.key,
    required this.companyId,
    required this.companyName,
    required this.logoAsset,
  });

  @override
  ConsumerState<CompanyJobsPage> createState() => _CompanyJobsPageState();
}

class _CompanyJobsPageState extends ConsumerState<CompanyJobsPage> {
  @override
  void initState() {
    super.initState();
    // Load saved jobs when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.read(applicationProvider.notifier).getSavedJobs(currentUser.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final companyDetailsAsync = ref.watch(companyDetailsProvider(widget.companyId));
    final savedJobs = ref.watch(savedJobsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Việc làm đang tuyển',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              widget.companyName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: companyDetailsAsync.when(
        data: (companyDetails) {
          final jobsData = companyDetails.jobs;

          if (jobsData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_off_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Công ty hiện không có việc làm nào',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: jobsData.length,
            itemBuilder: (context, index) {
              final job = Job.fromJson(jobsData[index]);
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
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Không thể tải danh sách việc làm',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(companyDetailsProvider(widget.companyId)),
                child: const Text('Thử lại'),
              ),
            ],
          ),
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
