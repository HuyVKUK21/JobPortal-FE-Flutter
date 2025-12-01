import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/services/api_service.dart';
import 'package:flutter_application_1/core/models/saved_company_model.dart';
import 'package:flutter_application_1/core/models/company_model.dart';

// ============================================================================
// State Providers
// ============================================================================

/// Provider for saved companies list
final savedCompaniesProvider = StateProvider<List<SavedCompany>>((ref) => []);

/// Provider for saved companies loading state
final savedCompaniesLoadingProvider = StateProvider<bool>((ref) => false);

/// Provider for saved companies error state
final savedCompaniesErrorProvider = StateProvider<String?>((ref) => null);

// ============================================================================
// Saved Companies Notifier
// ============================================================================

class SavedCompaniesNotifier extends StateNotifier<AsyncValue<void>> {
  final ApiService _apiService;
  final Ref _ref;

  SavedCompaniesNotifier(this._apiService, this._ref) : super(const AsyncValue.data(null));

  /// Get all saved companies for a user
  Future<void> getSavedCompanies(int seekerId) async {
    try {
      _ref.read(savedCompaniesLoadingProvider.notifier).state = true;
      _ref.read(savedCompaniesErrorProvider.notifier).state = null;

      final response = await _apiService.getSavedCompanies(seekerId);

      if (response.data != null) {
        // Parse the response data to SavedCompany objects
        final savedCompanies = response.data!.map((json) {
          return SavedCompany(
            id: json['id'] as int,
            company: Company.fromJson(json['company'] as Map<String, dynamic>),
            savedAt: DateTime.parse(json['savedAt'] as String),
          );
        }).toList();

        _ref.read(savedCompaniesProvider.notifier).state = savedCompanies;
      } else {
        _ref.read(savedCompaniesProvider.notifier).state = [];
        if (response.error != null) {
          _ref.read(savedCompaniesErrorProvider.notifier).state = response.message;
        }
      }
    } catch (e) {
      _ref.read(savedCompaniesErrorProvider.notifier).state = e.toString();
      _ref.read(savedCompaniesProvider.notifier).state = [];
    } finally {
      _ref.read(savedCompaniesLoadingProvider.notifier).state = false;
    }
  }

  /// Save a company
  Future<void> saveCompany(int seekerId, int companyId) async {
    try {
      state = const AsyncValue.loading();
      
      final response = await _apiService.saveCompany(seekerId, companyId);

      if (response.status == 201 || response.status == 200) {
        // Refresh the saved companies list
        await getSavedCompanies(seekerId);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(response.message, StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Unsave a company
  Future<void> unsaveCompany(int seekerId, int companyId) async {
    try {
      state = const AsyncValue.loading();
      
      final response = await _apiService.unsaveCompany(seekerId, companyId);

      if (response.status == 200) {
        // Remove the company from the local list
        final currentList = _ref.read(savedCompaniesProvider);
        _ref.read(savedCompaniesProvider.notifier).state = 
            currentList.where((sc) => sc.company.id != companyId).toList();
        
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(response.message, StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// ============================================================================
// Provider
// ============================================================================

final savedCompaniesNotifierProvider = StateNotifierProvider<SavedCompaniesNotifier, AsyncValue<void>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return SavedCompaniesNotifier(apiService, ref);
});
