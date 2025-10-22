import 'package:flutter_application_1/features/jobs/domain/entities/job_entity.dart';

/// Abstract repository interface for jobs
/// This will be implemented in the data layer
abstract class JobRepository {
  /// Get list of all jobs
  Future<List<JobEntity>> getJobs({
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 10,
  });

  /// Get job detail by ID
  Future<JobEntity> getJobDetail(String jobId);

  /// Get recommended jobs
  Future<List<JobEntity>> getRecommendedJobs();

  /// Get latest jobs
  Future<List<JobEntity>> getLatestJobs({int page = 1, int limit = 10});

  /// Get saved/bookmarked jobs
  Future<List<JobEntity>> getSavedJobs();

  /// Save/bookmark a job
  Future<void> saveJob(String jobId);

  /// Unsave/unbookmark a job
  Future<void> unsaveJob(String jobId);

  /// Search jobs
  Future<List<JobEntity>> searchJobs(String query);
}


