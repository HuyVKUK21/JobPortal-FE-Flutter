import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/providers/job_provider.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/providers/category_provider.dart';
import 'package:flutter_application_1/core/utils/salary_formatter.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';
import 'package:flutter_application_1/presentations/widgets/job_filter_bottom_sheet.dart';
import 'package:flutter_application_1/presentations/widgets/active_filter_chip.dart';
import 'package:flutter_application_1/core/models/job.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class AllJobsPage extends ConsumerStatefulWidget {
  final String title;
  final int? categoryId;
  final String? categoryName;
  
  const AllJobsPage({
    super.key,
    this.title = 'Tất cả việc làm',
    this.categoryId,
    this.categoryName,
  });

  @override
  ConsumerState<AllJobsPage> createState() => _AllJobsPageState();
}

class _AllJobsPageState extends ConsumerState<AllJobsPage> {
  int? _selectedCategoryId;
  late TextEditingController _searchController;
  Timer? _debounce;
  JobFilterRequest _currentFilter = JobFilterRequest();


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    
    // Load jobs when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load categories
      ref.read(categoryProvider.notifier).loadCategories();
      
      if (widget.categoryId != null) {
        // Load jobs by category
        _selectedCategoryId = widget.categoryId;
        _currentFilter = _currentFilter.copyWith(categoryId: widget.categoryId);
        _applyFilters();
      } else {
        // Load all jobs
        ref.read(jobProvider.notifier).getAllJobs();
      }
      
      // Load saved jobs if user is authenticated
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.read(applicationProvider.notifier).getSavedJobs(currentUser.userId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _currentFilter = _currentFilter.copyWith(title: query.isEmpty ? null : query);
      });
      _applyFilters();
    });
  }

  void _applyFilters() {
    // If we have a title search, use searchJobs
    if (_currentFilter.title != null && _currentFilter.title!.isNotEmpty) {
      ref.read(jobProvider.notifier).searchJobs(
        title: _currentFilter.title,
        location: _currentFilter.location,
        categoryIds: _currentFilter.categoryId != null ? [_currentFilter.categoryId!] : null,
        salaryMin: _currentFilter.salaryMin?.toInt(),
        salaryMax: _currentFilter.salaryMax?.toInt(),
      );
    }
    // If we have other filters (jobType, workLocation), use filterJobs
    else if (_currentFilter.jobType != null || 
             _currentFilter.workLocation != null ||
             _currentFilter.location != null ||
             _currentFilter.categoryId != null) {
      ref.read(jobProvider.notifier).filterJobs(
        jobType: _currentFilter.jobType,
        workLocation: _currentFilter.workLocation,
        location: _currentFilter.location,
        categoryId: _currentFilter.categoryId,
        skillId: _currentFilter.skillId,
      );
    }
    // If we have a selected category but no other filters
    else if (_selectedCategoryId != null) {
      ref.read(jobProvider.notifier).getJobsByCategory(_selectedCategoryId!);
    }
    // Otherwise, get all jobs
    else {
      ref.read(jobProvider.notifier).getAllJobs();
    }
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _currentFilter = JobFilterRequest();
      _selectedCategoryId = null;
    });
    ref.read(jobProvider.notifier).getAllJobs();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JobFilterBottomSheet(
        initialFilter: _currentFilter,
        onApply: (filter) {
          setState(() {
            _currentFilter = filter;
          });
          _applyFilters();
        },
      ),
    );
  }

  List<Widget> _buildActiveFilterChips() {
    List<Widget> chips = [];

    if (_currentFilter.title != null && _currentFilter.title!.isNotEmpty) {
      chips.add(ActiveFilterChip(
        label: 'Tìm kiếm',
        value: _currentFilter.title!,
        onRemove: () {
          setState(() {
            _searchController.clear();
            _currentFilter = _currentFilter.copyWith(title: null);
          });
          _applyFilters();
        },
      ));
    }

    if (_currentFilter.location != null) {
      chips.add(ActiveFilterChip(
        label: 'Địa điểm',
        value: _currentFilter.location!,
        onRemove: () {
          setState(() {
            _currentFilter = _currentFilter.copyWith(location: null);
          });
          _applyFilters();
        },
      ));
    }

    if (_currentFilter.jobType != null) {
      chips.add(ActiveFilterChip(
        label: 'Loại CV',
        value: _formatJobType(_currentFilter.jobType!),
        onRemove: () {
          setState(() {
            _currentFilter = _currentFilter.copyWith(jobType: null);
          });
          _applyFilters();
        },
      ));
    }

    if (_currentFilter.workLocation != null) {
      chips.add(ActiveFilterChip(
        label: 'Hình thức',
        value: _formatWorkLocation(_currentFilter.workLocation!),
        onRemove: () {
          setState(() {
            _currentFilter = _currentFilter.copyWith(workLocation: null);
          });
          _applyFilters();
        },
      ));
    }

    if (_currentFilter.salaryMin != null || _currentFilter.salaryMax != null) {
      final min = _currentFilter.salaryMin ?? 0;
      final max = _currentFilter.salaryMax ?? 50000000;
      chips.add(ActiveFilterChip(
        label: 'Lương',
        value: '${(min / 1000000).toStringAsFixed(0)}M - ${(max / 1000000).toStringAsFixed(0)}M',
        onRemove: () {
          setState(() {
            _currentFilter = _currentFilter.copyWith(salaryMin: null, salaryMax: null);
          });
          _applyFilters();
        },
      ));
    }

    return chips;
  }

  String _formatJobType(String type) {
    switch (type) {
      case 'full-time':
        return 'Toàn thời gian';
      case 'part-time':
        return 'Bán thời gian';
      case 'freelance':
        return 'Freelance';
      case 'contract':
        return 'Hợp đồng';
      default:
        return type;
    }
  }

  String _formatWorkLocation(String location) {
    switch (location) {
      case 'remote':
        return 'Từ xa';
      case 'office':
        return 'Văn phòng';
      case 'hybrid':
        return 'Kết hợp';
      default:
        return location;
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobs = ref.watch(jobsProvider);
    final savedJobs = ref.watch(savedJobsProvider);
    final isLoading = ref.watch(jobLoadingProvider);
    final error = ref.watch(jobErrorProvider);
    final categories = ref.watch(categoriesListProvider);
    final activeFilterCount = _currentFilter.activeFilterCount;
    
    // Debug print
    print('🔍 Categories count: ${categories.length}');
    if (categories.isNotEmpty) {
      print('📋 First category: ${categories.first.name}');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName ?? widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
                onPressed: _showFilterBottomSheet,
              ),
              if (activeFilterCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4285F4),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$activeFilterCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm công việc...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Category Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 12),
            child: categories.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Loading categories...', style: TextStyle(color: Colors.grey)),
                    ),
                  )
                : SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isSelected = _selectedCategoryId == null;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('Tất cả'),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategoryId = null;
                              _currentFilter = _currentFilter.copyWith(categoryId: null);
                            });
                            _applyFilters();
                          },
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFF4285F4),
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF4285F4) : AppColors.borderLight,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      );
                    }
                    
                    final category = categories[index - 1];
                    final isSelected = _selectedCategoryId == category.categoryId;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategoryId = category.categoryId;
                            _currentFilter = _currentFilter.copyWith(categoryId: category.categoryId);
                          });
                          _applyFilters();
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF4285F4),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF4285F4) : AppColors.borderLight,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Active Filters
          if (_buildActiveFilterChips().isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 32,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        ..._buildActiveFilterChips(),
                        GestureDetector(
                          onTap: _clearAllFilters,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.clear_all, size: 16, color: Colors.red),
                                SizedBox(width: 4),
                                Text(
                                  'Xóa tất cả',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 8),
          
          // Jobs List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              error,
                              style: const TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (widget.categoryId != null) {
                                  ref.read(jobProvider.notifier).getJobsByCategory(widget.categoryId!);
                                } else {
                                  ref.read(jobProvider.notifier).getAllJobs();
                                }
                              },
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      )
                    : jobs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.work_off_outlined, size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  _currentFilter.hasActiveFilters
                                      ? 'Không tìm thấy việc làm phù hợp'
                                      : 'Không có việc làm nào',
                                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                                if (_currentFilter.hasActiveFilters) ...[
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: _clearAllFilters,
                                    child: const Text('Xóa bộ lọc'),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            itemCount: jobs.length,
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              final isSaved = savedJobs.any((savedJob) => savedJob.job?.jobId == job.jobId);
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: CardItemJob(
                                  titleJob: job.title,
                                  conpanyJob: job.company?.name ?? 'Công ty',
                                  location: job.location,
                                  workLocation: job.workLocation ?? 'Văn phòng',
                                  workingTime: job.jobType ?? 'Full Time',
                                  workSalary: SalaryFormatter.formatSalaryWithPeriod(
                                    salaryMin: job.salaryMin,
                                    salaryMax: job.salaryMax,
                                    salaryType: job.salaryType,
                                  ),
                                  logoCompany: 'assets/logo_lutech.png',
                                  isSaved: isSaved,
                                  onTap: () {
                                    context.pushNamed('jobDetail', pathParameters: {
                                      'jobId': job.jobId.toString(),
                                    });
                                  },
                                  onBookmarkTap: () {
                                    final currentUser = ref.read(currentUserProvider);
                                    if (currentUser == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Vui lòng đăng nhập để lưu việc làm')),
                                      );
                                      return;
                                    }
                                    
                                    if (isSaved) {
                                      ref.read(applicationProvider.notifier).unsaveJob(currentUser.userId, job.jobId);
                                    } else {
                                      ref.read(applicationProvider.notifier).saveJob(currentUser.userId, job.jobId);
                                    }
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
