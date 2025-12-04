import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/job.dart';
import 'package:flutter_application_1/core/models/application.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/utils/salary_formatter.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_card.dart';
import 'package:go_router/go_router.dart';

/// Job list view widget
class JobListView extends ConsumerWidget {
  final List<Job> jobs;
  final List<SavedJob> savedJobs;
  final dynamic currentUser; // Use dynamic to avoid import issues
  final WidgetRef ref;

  const JobListView({
    super.key,
    required this.jobs,
    required this.savedJobs,
    required this.currentUser,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final job = jobs[index];
        final isSaved = currentUser != null &&
            savedJobs.any((savedJob) => savedJob.job?.jobId == job.jobId);

        return JobCard(
          title: job.title,
          companyName: job.company?.name ?? 'Công ty',
          location: job.location,
          workLocation: job.workLocation ?? '',
          workingTime: job.jobType ?? 'Full Time',
          salary: SalaryFormatter.formatSalary(
            salaryMin: job.salaryMin,
            salaryMax: job.salaryMax,
            salaryType: job.salaryType,
          ),
          companyLogo: 'assets/logo_lutech.png',
          isSaved: isSaved,
          onBookmarkTap: () => _handleBookmarkTap(job.jobId, isSaved),
          onTap: () => _navigateToDetail(context, job.jobId),
        );
      },
    );
  }

  void _handleBookmarkTap(int jobId, bool isSaved) {
    if (currentUser != null) {
      if (isSaved) {
        ref.read(applicationProvider.notifier).unsaveJob(currentUser!.userId, jobId);
      } else {
        ref.read(applicationProvider.notifier).saveJob(currentUser!.userId, jobId);
      }
    }
  }

  void _navigateToDetail(BuildContext context, int jobId) {
    context.pushNamed('jobDetail', pathParameters: {'jobId': jobId.toString()});
  }
}
