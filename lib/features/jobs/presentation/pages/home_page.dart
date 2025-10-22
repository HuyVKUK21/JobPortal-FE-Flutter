import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/core/widgets/search_field.dart';
import 'package:flutter_application_1/core/widgets/section_header.dart';
import 'package:flutter_application_1/core/providers/job_provider.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/models/simple_job.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/category_filter.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/home_banner.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/home_header.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_card.dart';
import 'package:go_router/go_router.dart';

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
      print('🚀 Loading jobs from API...');
      ref.read(jobProvider.notifier).getAllJobs();
      
      // Load saved jobs if user is authenticated
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.read(applicationProvider.notifier).getSavedJobs();
      }
    });
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

    try {
      await ref.read(applicationProvider.notifier).saveJob(jobId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu việc làm thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleUnsaveJob(int jobId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    try {
      await ref.read(applicationProvider.notifier).unsaveJob(jobId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã bỏ lưu việc làm'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                    _buildJobList(),
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
                    _buildJobList(),
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

  Widget _buildJobList() {
    final jobs = ref.watch(jobsProvider);
    final savedJobs = ref.watch(savedJobsProvider);
    final isLoading = ref.watch(jobLoadingProvider);
    final error = ref.watch(jobErrorProvider);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          children: [
            Text('Lỗi: $error'),
            ElevatedButton(
              onPressed: () {
                ref.read(jobProvider.notifier).getAllJobs();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (jobs.isEmpty) {
      return const Center(
        child: Text('Không có việc làm nào'),
      );
    }

    return Column(
      children: jobs.take(3).map((job) {
        final isSaved = savedJobs.any((savedJob) => savedJob.jobId == job.jobId);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: JobCard(
            title: job.title,
            companyName: job.company?.name ?? 'Công ty',
            location: job.location,
            workLocation: job.workLocation ?? '',
            workingTime: job.jobType ?? 'Full Time',
            salary: job.salaryRange ?? 'Thỏa thuận',
            companyLogo: 'assets/logo_lutech.png', // Default logo
            isSaved: isSaved,
            onTap: () {
              context.pushNamed('jobDetail', pathParameters: {'jobId': job.jobId.toString()});
            },
            onBookmarkTap: () {
              if (isSaved) {
                _handleUnsaveJob(job.jobId);
              } else {
                _handleSaveJob(job.jobId);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

