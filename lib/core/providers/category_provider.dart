import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job.dart';
import '../services/api_service.dart';

// Category State
class CategoryState {
  final List<Category> categories;
  final int? selectedCategoryId;
  final List<Job> filteredJobs;
  final bool isLoading;
  final String? error;

  CategoryState({
    this.categories = const [],
    this.selectedCategoryId,
    this.filteredJobs = const [],
    this.isLoading = false,
    this.error,
  });

  CategoryState copyWith({
    List<Category>? categories,
    int? selectedCategoryId,
    List<Job>? filteredJobs,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      filteredJobs: filteredJobs ?? this.filteredJobs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Category Notifier
class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(CategoryState());

  final ApiService _apiService = ApiService();

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiService.getAllCategories();

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          categories: response.data!.cast<Category>(),
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

  Future<void> loadJobsByCategory(int categoryId) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedCategoryId: categoryId,
    );

    try {
      final response = await _apiService.getJobsByCategory(categoryId);

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          filteredJobs: response.data!,
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

  void clearCategoryFilter() {
    state = state.copyWith(
      selectedCategoryId: null,
      filteredJobs: [],
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  return CategoryNotifier();
});

final categoriesListProvider = Provider<List<Category>>((ref) {
  return ref.watch(categoryProvider).categories;
});

final selectedCategoryIdProvider = Provider<int?>((ref) {
  return ref.watch(categoryProvider).selectedCategoryId;
});

final filteredJobsProvider = Provider<List<Job>>((ref) {
  return ref.watch(categoryProvider).filteredJobs;
});

final categoryLoadingProvider = Provider<bool>((ref) {
  return ref.watch(categoryProvider).isLoading;
});

final categoryErrorProvider = Provider<String?>((ref) {
  return ref.watch(categoryProvider).error;
});
