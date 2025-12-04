import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/job_constants.dart';
import 'package:flutter_application_1/core/providers/job_provider.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/empty_search_state.dart';
import 'package:flutter_application_1/presentations/widgets/job_filter_bottom_sheet.dart';
import 'package:flutter_application_1/core/models/job.dart';
import 'package:go_router/go_router.dart';

// Extracted widgets
import 'search_page_widgets/search_header.dart';
import 'search_page_widgets/results_summary.dart';
import 'search_page_widgets/loading_state.dart';
import 'search_page_widgets/error_state.dart';
import 'search_page_widgets/empty_search_prompt.dart';
import 'search_page_widgets/job_list_view.dart';
import 'search_page_widgets/sort_bottom_sheet.dart';

/// Search jobs page with clean architecture
class SearchJobsPage extends ConsumerStatefulWidget {
  const SearchJobsPage({super.key});

  @override
  ConsumerState<SearchJobsPage> createState() => _SearchJobsPageState();
}

class _SearchJobsPageState extends ConsumerState<SearchJobsPage> {
  // Controllers and state
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  
  String _searchQuery = '';
  String _selectedSort = JobConstants.sortMostRelevant;
  bool _hasSearched = false;
  JobFilterRequest _currentFilter = JobFilterRequest();

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // ============================================================================
  // Event Handlers
  // ============================================================================

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _hasSearched = query.isNotEmpty || _currentFilter.hasActiveFilters;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), _performSearch);
  }

  void _onFilterApplied(JobFilterRequest filter) {
    if (kDebugMode) {
      print('🔍 Filter applied: $filter');
    }
    
    setState(() {
      _currentFilter = filter;
      _hasSearched = _searchQuery.isNotEmpty || filter.hasActiveFilters;
    });
    
    _applyFiltersWithSort();
  }

  void _onSortSelected(String sortOption) {
    setState(() => _selectedSort = sortOption);
    _performSearch();
  }

  void _onClearFilters() {
    setState(() {
      _currentFilter = JobFilterRequest();
      _hasSearched = _searchQuery.isNotEmpty;
    });
    
    if (_searchQuery.isEmpty) {
      ref.read(jobProvider.notifier).getAllJobs();
    } else {
      _performSearch();
    }
  }

  // ============================================================================
  // Business Logic
  // ============================================================================

  void _performSearch() {
    if (_searchQuery.isNotEmpty) {
      ref.read(jobProvider.notifier).quickSearch(_searchQuery);
    } else if (_currentFilter.hasActiveFilters) {
      _applyFiltersWithSort();
    }
  }

  void _applyFiltersWithSort() {
    ref.read(jobProvider.notifier).filterJobs(
      jobType: _currentFilter.jobType,
      workLocation: _currentFilter.workLocation,
      location: _currentFilter.location,
      categoryId: _currentFilter.categoryId,
      skillId: _currentFilter.skillId,
      page: 0,
      size: 20,
      sortBy: _convertSortToFieldName(_selectedSort),
      sortOrder: 'desc',
    );
  }

  String _convertSortToFieldName(String sortOption) {
    switch (sortOption) {
      case JobConstants.sortMostRelevant:
        return 'postedAt';
      case JobConstants.sortAlphabetical:
        return 'title';
      case JobConstants.sortHighestSalary:
        return 'salaryRange';
      case JobConstants.sortNewlyPosted:
        return 'postedAt';
      case JobConstants.sortEndingSoon:
        return 'deadline';
      default:
        return 'postedAt';
    }
  }

  // ============================================================================
  // UI Helpers
  // ============================================================================

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JobFilterBottomSheet(
        initialFilter: _currentFilter,
        onApply: _onFilterApplied,
      ),
    );
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheet(
        selectedSort: _selectedSort,
        onSortSelected: _onSortSelected,
      ),
    );
  }

  // ============================================================================
  // Build Method
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final jobState = ref.watch(jobProvider);
    final savedJobs = ref.watch(savedJobsProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    final jobs = jobState.jobs;
    final isLoading = jobState.isLoading;
    final error = jobState.error;
    final resultsCount = jobs.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            SearchHeader(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              onFilterTap: _showFilterModal,
              onBackTap: () => context.pop(),
              currentFilter: _currentFilter,
              onClearFilters: _onClearFilters,
            ),

            // Results Summary
            if (_hasSearched)
              ResultsSummary(
                resultsCount: resultsCount,
                onSortTap: _showSortModal,
              ),

            // Content
            Expanded(
              child: _buildContent(
                hasSearched: _hasSearched,
                isLoading: isLoading,
                error: error,
                resultsCount: resultsCount,
                jobs: jobs,
                savedJobs: savedJobs,
                currentUser: currentUser,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({
    required bool hasSearched,
    required bool isLoading,
    required String? error,
    required int resultsCount,
    required List jobs,
    required List savedJobs,
    required currentUser,
  }) {
    if (!hasSearched) {
      return const EmptySearchPrompt();
    }

    if (isLoading) {
      return const LoadingState();
    }

    if (error != null) {
      return ErrorState(
        errorMessage: error,
        onRetry: _performSearch,
      );
    }

    if (resultsCount == 0) {
      return const EmptySearchState();
    }

    return JobListView(
      jobs: jobs.cast<Job>(),
      savedJobs: savedJobs.cast<SavedJob>(),
      currentUser: currentUser,
      ref: ref,
    );
  }
}
