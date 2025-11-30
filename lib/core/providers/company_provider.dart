import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/company_model.dart';
import 'package:flutter_application_1/core/services/company_service.dart';
import 'package:flutter_application_1/core/services/api_service.dart';

// ============================================================================
// Service Provider
// ============================================================================

final companyServiceProvider = Provider<CompanyService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CompanyService(apiService);
});

// ============================================================================
// State Management for Companies List
// ============================================================================

class CompaniesState {
  final List<Company> companies;
  final Pagination? pagination;
  final bool isLoading;
  final String? error;

  CompaniesState({
    this.companies = const [],
    this.pagination,
    this.isLoading = false,
    this.error,
  });

  CompaniesState copyWith({
    List<Company>? companies,
    Pagination? pagination,
    bool? isLoading,
    String? error,
  }) {
    return CompaniesState(
      companies: companies ?? this.companies,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CompaniesNotifier extends StateNotifier<CompaniesState> {
  final CompanyService _companyService;

  CompaniesNotifier(this._companyService) : super(CompaniesState());

  Future<void> fetchCompanies({
    int page = 1,
    int limit = 10,
    String? search,
    String? industry,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _companyService.getCompanies(
        page: page,
        limit: limit,
        search: search,
        industry: industry,
      );

      state = state.copyWith(
        companies: response.companies,
        pagination: response.pagination,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.pagination == null || state.isLoading) return;
    
    final currentPage = state.pagination!.page;
    final totalPages = state.pagination!.totalPages;
    
    if (currentPage >= totalPages) return;

    try {
      final response = await _companyService.getCompanies(
        page: currentPage + 1,
        limit: state.pagination!.limit,
      );

      state = state.copyWith(
        companies: [...state.companies, ...response.companies],
        pagination: response.pagination,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final companiesProvider = StateNotifierProvider<CompaniesNotifier, CompaniesState>((ref) {
  final companyService = ref.watch(companyServiceProvider);
  return CompaniesNotifier(companyService);
});

// ============================================================================
// FutureProviders for One-Time Data Fetching
// ============================================================================

/// Featured companies for home page
final featuredCompaniesProvider = FutureProvider<List<Company>>((ref) async {
  final companyService = ref.watch(companyServiceProvider);
  return companyService.getFeaturedCompanies(limit: 6);
});

/// Company details with jobs for detail page
final companyDetailsProvider = FutureProvider.family<CompanyDetails, int>((ref, companyId) async {
  final companyService = ref.watch(companyServiceProvider);
  return companyService.getCompanyById(companyId);
});

/// Company jobs (alternative endpoint)
final companyJobsProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, companyId) async {
  final companyService = ref.watch(companyServiceProvider);
  return companyService.getCompanyJobs(companyId: companyId);
});
