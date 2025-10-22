import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/job_constants.dart';
import 'package:flutter_application_1/core/widgets/search_field.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/empty_search_state.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/filter_bottom_sheet.dart';
import 'package:flutter_application_1/features/jobs/presentation/widgets/job_card.dart';
import 'package:go_router/go_router.dart';

class SearchJobsPage extends StatefulWidget {
  const SearchJobsPage({super.key});

  @override
  State<SearchJobsPage> createState() => _SearchJobsPageState();
}

class _SearchJobsPageState extends State<SearchJobsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = JobConstants.sortMostRelevant;
  bool _hasSearched = false;

  // Mock data
  final List<Map<String, String>> _allJobs = [
    {
      'title': 'Graphic Designer',
      'company': 'Apple Inc.',
      'location': 'Tokyo, Japan',
      'salary': '\$10,000 - \$20,000 /month',
      'workingTime': 'Full Time',
      'workLocation': 'Onsite',
      'logo': 'assets/logo_lutech.png',
    },
    {
      'title': 'UI & UX Designer',
      'company': 'Pinterest',
      'location': 'New York, United States',
      'salary': '\$8,000 - \$20,000 /month',
      'workingTime': 'Full Time',
      'workLocation': 'Remote',
      'logo': 'assets/logo_google.png',
    },
    {
      'title': 'Web Designer',
      'company': 'Twitter Inc.',
      'location': 'Chicago, United States',
      'salary': '\$5,000 - \$12,000 /month',
      'workingTime': 'Freelance',
      'workLocation': 'Remote',
      'logo': 'assets/logo_google.png',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredJobs {
    if (_searchQuery.isEmpty) return [];
    return _allJobs
        .where((job) =>
            job['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            job['company']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _hasSearched = query.isNotEmpty;
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        onApply: (filters) {
          // TODO: Apply filters
          debugPrint('Filters applied: $filters');
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
    final resultsCount = _filteredJobs.length;

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
                      '$resultsCount kết quả',
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
                  ? resultsCount > 0
                      ? ListView.separated(
                          padding: const EdgeInsets.all(AppDimensions.space),
                          itemCount: resultsCount,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppDimensions.space),
                          itemBuilder: (context, index) {
                            final job = _filteredJobs[index];
                            return JobCard(
                              title: job['title']!,
                              companyName: job['company']!,
                              location: job['location']!,
                              workLocation: job['workLocation']!,
                              workingTime: job['workingTime']!,
                              salary: job['salary']!,
                              companyLogo: job['logo']!,
                              onTap: () {
                                context.pushNamed('jobDetail');
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
