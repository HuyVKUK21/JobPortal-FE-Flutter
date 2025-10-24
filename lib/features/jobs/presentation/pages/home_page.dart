import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/presentations/widgets/banner_home_page.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/presentations/widgets/header_section.dart';
import 'package:flutter_application_1/presentations/widgets/job_category.dart';
import 'package:flutter_application_1/presentations/widgets/search_box.dart';
import 'package:flutter_application_1/presentations/widgets/title_category_header.dart';
import 'package:flutter_application_1/core/providers/job_provider.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
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
                    SizedBox(height: 16),
                    TitleCategoryHeader(
                      onPressed: () {},
                      titleCategoryHeader: 'Việc làm đề xuất',
                    ),
                    SizedBox(height: 16),
                    // Show loading indicator
                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    // Show error message
                    else if (error != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text('Lỗi: $error', style: const TextStyle(color: Colors.red)),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(jobProvider.notifier).getAllJobs();
                                },
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
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

