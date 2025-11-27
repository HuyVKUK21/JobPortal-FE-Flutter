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
              logoCompany: 'assets/logo_lutech.png',
              isSaved: true, // Always true in saved jobs screen
              onTap: () {
                if (savedJob.job?.jobId != null) {
                  context.pushNamed('jobDetail', pathParameters: {'jobId': savedJob.job!.jobId.toString()});
                }
              },
              onBookmarkTap: () {
                _showRemoveBottomSheet(context, savedJob);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showRemoveBottomSheet(BuildContext context, dynamic savedJob) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
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
              
              // Description
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
              
              // Buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Remove button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Remove the saved job
                        final currentUser = ref.read(currentUserProvider);
                        if (currentUser != null && savedJob.job?.jobId != null) {
                          ref.read(applicationProvider.notifier).unsaveJob(
                            currentUser.userId,
                            savedJob.job!.jobId,
                          );
                        }
                        Navigator.pop(context);
                        
                        // Show success snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xóa khỏi danh sách đã lưu'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF4285F4),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Xóa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
