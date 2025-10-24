import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/job_constants.dart';
import 'package:flutter_application_1/core/providers/job_provider.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/widgets/search_field.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/empty_search_state.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/simple_filter_bottom_sheet.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_card.dart';
import 'package:go_router/go_router.dart';

class SearchJobsPage extends ConsumerStatefulWidget {
  const SearchJobsPage({super.key});

  @override
  ConsumerState<SearchJobsPage> createState() => _SearchJobsPageState();
}

class _SearchJobsPageState extends ConsumerState<SearchJobsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = JobConstants.sortMostRelevant;
  bool _hasSearched = false;
  Timer? _debounceTimer;
  
  // Track active filters
  Map<String, dynamic> _activeFilters = {};

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _hasSearched = query.isNotEmpty;
    });

    // Debounce search to avoid too many API calls
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        ref.read(jobProvider.notifier).quickSearch(query);
      }
    });
  }

  // Convert Vietnamese sort option to English field name
  String _convertSortToFieldName(String sortOption) {
    switch (sortOption) {
      case JobConstants.sortMostRelevant:
        return 'postedAt'; // Default to posted date for relevance
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

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SimpleFilterBottomSheet(
        onApply: (filters) {
          // Debug filter values
          if (kDebugMode) {
            print('🔍 Filter values: $filters');
          }
          
          // Store active filters
          setState(() {
            _activeFilters = Map.from(filters);
          });
          
          // Apply filters using API with correct field mapping
          ref.read(jobProvider.notifier).filterJobs(
            jobType: filters['jobType'],
            workLocation: filters['workLocation'],
            location: filters['location'],
            categoryId: null,
            skillId: null,
            page: 0,
            size: 20,
            sortBy: _convertSortToFieldName(_selectedSort),
            sortOrder: 'desc',
          );
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusL)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: JobConstants.sortOptions.map((option) {
            final isSelected = option == _selectedSort;
            return ListTile(
              title: Text(
                option,
                style: TextStyle(
                  fontSize: AppDimensions.fontM,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary : Colors.black87,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedSort = option;
                });
                context.pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and search
            Padding(
              padding: const EdgeInsets.all(AppDimensions.space),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: AppDimensions.spaceS),
                  Expanded(
                    child: SearchField(
                      controller: _searchController,
                      hintText: 'Tìm kiếm công việc...',
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceS),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed: _showFilterOptions,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),

            // Results count and sort
            if (_hasSearched)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceL,
                  vertical: AppDimensions.spaceS,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${jobs.length} kết quả',
                      style: const TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: _showSortOptions,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceS,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.swap_vert,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Sắp xếp',
                              style: TextStyle(
                                fontSize: AppDimensions.fontM,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: _hasSearched
                  ? isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Lỗi: $error'),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_searchQuery.isNotEmpty) {
                                        ref.read(jobProvider.notifier).quickSearch(_searchQuery);
                                      }
                                    },
                                    child: const Text('Thử lại'),
                                  ),
                                ],
                              ),
                            )
                          : resultsCount > 0
                              ? ListView.separated(
                                  padding: const EdgeInsets.all(AppDimensions.space),
                                  itemCount: resultsCount,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: AppDimensions.space),
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
                                      salary: job.salaryRange ?? 'Thỏa thuận',
                                      companyLogo: 'assets/logo_lutech.png',
                                      isSaved: isSaved,
                                      onBookmarkTap: () {
                                        if (currentUser != null) {
                                          if (isSaved) {
                                            ref.read(applicationProvider.notifier).unsaveJob(currentUser.userId, job.jobId);
                                          } else {
                                            ref.read(applicationProvider.notifier).saveJob(currentUser.userId, job.jobId);
                                          }
                                        }
                                      },
                                      onTap: () {
                                        context.pushNamed('jobDetail', pathParameters: {'jobId': job.jobId.toString()});
                                      },
                                    );
                                  },
                                )
                              : const EmptySearchState()
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
