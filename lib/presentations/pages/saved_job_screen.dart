import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/presentations/widgets/search_box.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';
import 'package:go_router/go_router.dart';

class SavedJobScreen extends ConsumerStatefulWidget {
  const SavedJobScreen({super.key});

  @override
  ConsumerState<SavedJobScreen> createState() => _SavedJobScreenState();
}

class _SavedJobScreenState extends ConsumerState<SavedJobScreen> {
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Việc làm đã lưu',
              iconHeaderLeftBar: Icons.account_circle,
              iconHeaderRightBar: Icons.more_horiz_sharp,
            ),
            const SizedBox(height: 24),
            const SearchBox(),
            const SizedBox(height: 24),
            Expanded(
              child: _buildSavedJobsList(ref, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedJobsList(WidgetRef ref, BuildContext context) {
    final savedJobs = ref.watch(savedJobsProvider);
    final isLoading = ref.watch(applicationLoadingProvider);
    final error = ref.watch(applicationErrorProvider);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lỗi: $error'),
            ElevatedButton(
              onPressed: () {
                final currentUser = ref.read(currentUserProvider);
                if (currentUser != null) {
                  ref.read(applicationProvider.notifier).getSavedJobs(currentUser.userId);
                }
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (savedJobs.isEmpty) {
      return const Center(
        child: Text('Chưa có việc làm nào được lưu'),
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
              workSalary: savedJob.job?.salaryRange ?? 'Thỏa thuận',
              logoCompany: 'assets/logo_lutech.png', // Default logo
              onTap: () {
                if (savedJob.job?.jobId != null) {
                  context.pushNamed('jobDetail', pathParameters: {'jobId': savedJob.job!.jobId.toString()});
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
