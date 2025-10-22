import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/application.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

// Application State
class ApplicationState {
  final List<Application> applications;
  final List<SavedJob> savedJobs;
  final Application? selectedApplication;
  final bool isLoading;
  final String? error;

  ApplicationState({
    this.applications = const [],
    this.savedJobs = const [],
    this.selectedApplication,
    this.isLoading = false,
    this.error,
  });

  ApplicationState copyWith({
    List<Application>? applications,
    List<SavedJob>? savedJobs,
    Application? selectedApplication,
    bool? isLoading,
    String? error,
  }) {
    return ApplicationState(
      applications: applications ?? this.applications,
      savedJobs: savedJobs ?? this.savedJobs,
      selectedApplication: selectedApplication ?? this.selectedApplication,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Application Notifier
class ApplicationNotifier extends StateNotifier<ApplicationState> {
  ApplicationNotifier() : super(ApplicationState());

  final ApiService _apiService = ApiService();

  Future<void> applyForJob({
    required int jobId,
    required String coverLetter,
    String? resume,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = ApplicationRequest(
        jobId: jobId,
        seekerId: 0, // Will be set by backend from JWT token
        coverLetter: coverLetter,
        resume: resume,
      );

      final response = await _apiService.applyForJob(request);

      if (response.isSuccess && response.data != null) {
        // Add to applications list
        final newApplications = [...state.applications, response.data!];
        state = state.copyWith(
          applications: newApplications,
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

  Future<void> getMyApplications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.getMyApplications();

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          applications: response.data!,
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

  Future<void> getApplicationDetail(int applicationId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.getApplicationDetail(applicationId);

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          selectedApplication: response.data!,
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

  Future<void> cancelApplication(int applicationId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.cancelApplication(applicationId);

      if (response.isSuccess) {
        // Remove from applications list
        final newApplications = state.applications
            .where((app) => app.applicationId != applicationId)
            .toList();
        state = state.copyWith(
          applications: newApplications,
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

  Future<void> saveJob(int jobId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.saveJob(jobId);

      if (response.isSuccess && response.data != null) {
        // Add to saved jobs list
        final newSavedJobs = [...state.savedJobs, response.data!];
        state = state.copyWith(
          savedJobs: newSavedJobs,
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

  Future<void> getSavedJobs() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.getSavedJobs();

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          savedJobs: response.data!,
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

  Future<void> unsaveJob(int jobId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.unsaveJob(jobId);

      if (response.isSuccess) {
        // Remove from saved jobs list
        final newSavedJobs = state.savedJobs
            .where((savedJob) => savedJob.job?.jobId != jobId)
            .toList();
        state = state.copyWith(
          savedJobs: newSavedJobs,
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

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSelectedApplication() {
    state = state.copyWith(selectedApplication: null);
  }
}

// Providers
final applicationProvider = StateNotifierProvider<ApplicationNotifier, ApplicationState>((ref) {
  return ApplicationNotifier();
});

final applicationsProvider = Provider<List<Application>>((ref) {
  return ref.watch(applicationProvider.select((state) => state.applications));
});

final savedJobsProvider = Provider<List<SavedJob>>((ref) {
  return ref.watch(applicationProvider.select((state) => state.savedJobs));
});


final selectedApplicationProvider = Provider<Application?>((ref) {
  return ref.watch(applicationProvider).selectedApplication;
});

final applicationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(applicationProvider).isLoading;
});

final applicationErrorProvider = Provider<String?>((ref) {
  return ref.watch(applicationProvider).error;
});





