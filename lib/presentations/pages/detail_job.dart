import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/core/models/job.dart';
import 'package:flutter_application_1/core/utils/salary_formatter.dart';
import 'package:flutter_application_1/core/providers/job_provider.dart';
import 'package:flutter_application_1/presentations/widgets/job_detail_infomation.dart';
import 'package:flutter_application_1/presentations/widgets/job_detail_infomation_summary.dart';
import 'package:flutter_application_1/presentations/widgets/job_details_infomation_header.dart';
import 'package:flutter_application_1/presentations/widgets/job_skill.dart';
import 'package:flutter_application_1/presentations/widgets/job_task_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DetailJob extends ConsumerStatefulWidget {
  final int jobId;
  
  const DetailJob({super.key, required this.jobId});

  @override
  ConsumerState<DetailJob> createState() => _DetailJobState();
}

class _DetailJobState extends ConsumerState<DetailJob> {
  final tabs = ['Mô tả', 'Yêu cầu', 'Kỹ năng', 'Tóm tắt', 'Công ty'];

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int currentTab = 0;

  @override
  void initState() {
    super.initState();

    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value;
      final visible = positions
          .where((p) => p.itemLeadingEdge >= 0 && p.itemLeadingEdge < 0.4)
          .map((p) => p.index)
          .toList();
      if (visible.isNotEmpty && visible.first != currentTab) {
        setState(() => currentTab = visible.first);
      }
    });

    // Load job details from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobProvider.notifier).getJobById(widget.jobId);
    });
  }

  void _scrollTo(int index) {
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 50),
    );
    setState(() => currentTab = index);
  }

  void _applyJob() {
    final jobs = ref.read(jobsProvider);
    final job = jobs.firstWhere(
      (job) => job.jobId == widget.jobId,
      orElse: () => throw Exception('Job not found'),
    );
    
    context.pushNamed(
      'applyJob',
      pathParameters: {'jobId': widget.jobId.toString()},
      queryParameters: {
        'jobTitle': job.title,
        'companyName': job.company?.name ?? 'Công ty',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    final job = ref.watch(selectedJobProvider);
    final isLoading = ref.watch(jobLoadingProvider);
    final error = ref.watch(jobErrorProvider);

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lỗi')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lỗi: $error'),
              ElevatedButton(
                onPressed: () {
                  ref.read(jobProvider.notifier).getJobById(widget.jobId);
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (job == null) {
      return const Scaffold(
        body: Center(
          child: Text('Không tìm thấy công việc'),
        ),
      );
    }

    // Use real data from API
    final itemDesc = job.description.split('\n').where((line) => line.trim().isNotEmpty).toList();
    
    final minQualification = job.candidateRequirement?.split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList() ?? ['Không có yêu cầu cụ thể'];

    final skills = job.skills.map((skill) => skill.name).toList();

    final aboutItems = [
      '${job.company?.name ?? 'Công ty'} là công ty hoạt động trong lĩnh vực ${job.company?.industry ?? 'Công nghệ'}.',
      'Địa điểm: ${job.company?.location ?? job.location}',
      if (job.company?.website != null) 'Website: ${job.company!.website}',
      'Loại hình công việc: ${job.jobType ?? 'Toàn thời gian'}',
      'Địa điểm làm việc: ${job.workLocation ?? 'Văn phòng'}',
      'Mức lương: ${SalaryFormatter.formatSalary(
        salaryMin: job.salaryMin,
        salaryMax: job.salaryMax,
        salaryType: job.salaryType,
      )}',
      'Thời gian làm việc: ${job.workTime ?? '8:00 - 17:00'}',
    ];

    final sections = [
      JobDetailInfomation(items: itemDesc, title: 'Mô tả công việc'),
      JobDetailInfomation(items: minQualification, title: 'Yêu cầu ứng viên'),
      JobSkill(categories: skills, title: 'Kỹ năng yêu cầu'),
      JobDetailInfomationSummary(title: 'Tóm tắt công việc', job: job),
      JobDetailInfomation(items: aboutItems, title: 'Thông tin công ty'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_sharp, color: Colors.black87),
            onPressed: () {
              // TODO: Implement bookmark functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          AppScreenLayout(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobDetailInfomationHeader(job: job),
                const SizedBox(height: 8),

                JobTabBar(tabs: tabs, currentTab: currentTab, onTap: _scrollTo),

                Expanded(
                  child: ScrollablePositionedList.builder(
                    itemScrollController: _itemScrollController,
                    itemPositionsListener: _itemPositionsListener,
                    itemCount: sections.length,
                    padding: const EdgeInsets.only(bottom: 100), // Add padding for floating button
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: sections[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Apply Button - Floating at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.9),
                    Colors.white,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _applyJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceL),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Ứng tuyển',
                      style: TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
