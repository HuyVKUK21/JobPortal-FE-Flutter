import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job.dart';
import '../services/api_service.dart';

// Job State
class JobState {
  final List<Job> jobs;
  final Job? selectedJob;
  final bool isLoading;
  final String? error;
  final String? searchKeyword;

  JobState({
    this.jobs = const [],
    this.selectedJob,
    this.isLoading = false,
    this.error,
    this.searchKeyword,
  });

  JobState copyWith({
    List<Job>? jobs,
    Job? selectedJob,
    bool? isLoading,
    String? error,
    String? searchKeyword,
  }) {
    return JobState(
      jobs: jobs ?? this.jobs,
      selectedJob: selectedJob ?? this.selectedJob,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }
}

// Job Notifier
class JobNotifier extends StateNotifier<JobState> {
  JobNotifier() : super(JobState());

  final ApiService _apiService = ApiService();

  Future<void> searchJobs({
    String? title,
    String? location,
    List<int>? categoryIds,
    List<int>? skillIds,
    int? salaryMin,
    int? salaryMax,
    int? experienceRequiredId,
    String? companyName,
    String? jobType,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = JobSearchRequest(
        keyword: title,
        location: location,
        categoryIds: categoryIds,
        skillIds: skillIds,
        minSalary: salaryMin,
        maxSalary: salaryMax,
      );
      
      final response = await _apiService.searchJobs(request);

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          jobs: response.data!,
          isLoading: false,
          error: null,
          searchKeyword: title,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  Future<void> quickSearch(String keyword) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.quickSearch(keyword);

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          jobs: response.data!,
          isLoading: false,
          error: null,
          searchKeyword: keyword,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  Future<void> filterJobs({
    String? jobType,
    String? workLocation,
    String? location,
    int? categoryId,
    int? skillId,
    int page = 0,
    int size = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = JobFilterRequest(
        jobType: jobType,
        workLocation: workLocation,
        location: location,
        categoryId: categoryId,
        skillId: skillId,
        page: page,
        size: size,
        sortBy: sortBy ?? 'postedAt',
        sortOrder: sortOrder ?? 'DESC',
      );
      
      final response = await _apiService.filterJobs(request);

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          jobs: response.data!,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  Future<void> getJobDetail(int jobId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.getJobDetail(jobId);

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          selectedJob: response.data!,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  Future<void> getAllJobs() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.getAllJobs();

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          jobs: response.data!,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  Future<void> getJobsByCategory(int categoryId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.getJobsByCategory(categoryId);

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          jobs: response.data!,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }

  Future<void> getJobById(int jobId) async {
    await getJobDetail(jobId);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSelectedJob() {
    state = state.copyWith(selectedJob: null);
  }
}

// Providers
final jobProvider = StateNotifierProvider<JobNotifier, JobState>((ref) {
  return JobNotifier();
});

final jobsProvider = Provider<List<Job>>((ref) {
  return ref.watch(jobProvider).jobs;
});

final selectedJobProvider = Provider<Job?>((ref) {
  return ref.watch(jobProvider).selectedJob;
});

final jobLoadingProvider = Provider<bool>((ref) {
  return ref.watch(jobProvider).isLoading;
});

final jobErrorProvider = Provider<String?>((ref) {
  return ref.watch(jobProvider).error;
});

final searchKeywordProvider = Provider<String?>((ref) {
  return ref.watch(jobProvider).searchKeyword;
});
