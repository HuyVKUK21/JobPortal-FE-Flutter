import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/widgets/widgets.dart';
import 'package:flutter_application_1/presentations/widgets/item_application_notification.dart';
import 'package:flutter_application_1/presentations/pages/application_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_1/core/constants/lottie_assets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/core/utils/salary_formatter.dart';

class ApplicationsPage extends ConsumerStatefulWidget {
  const ApplicationsPage({super.key});

  @override
  ConsumerState<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends ConsumerState<ApplicationsPage> {
  String _searchQuery = '';
  String _sortBy = 'Mới nhất';
  String? _selectedStatus; // null = All, or 'Pending', 'Review', 'Accepted', 'Rejected'

  @override
  void initState() {
    super.initState();
    // Load applications when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.read(applicationProvider.notifier).getMyApplications(
            currentUser.userId, status: _selectedStatus);
      }
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      final formatter = DateFormat('dd \'thg\' MM, yyyy | HH:mm');
      return formatter.format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'Đơn ứng tuyển của bạn đã được chấp nhận';
      case 'rejected':
        return 'Đơn ứng tuyển của bạn đã bị từ chối';
      case 'review':
      case 'reviewed':
      case 'reviewing':
      case 'in_review':
        return 'Đơn ứng tuyển của bạn đang được xem xét';
      case 'pending':
        return 'Đơn ứng tuyển của bạn đang được xử lý';
      case 'cancelled':
        return 'Đơn ứng tuyển đã bị hủy';
      default:
        return 'Đơn ứng tuyển của bạn đã được gửi';
    }
  }

  bool _isNewApplication(String? dateStr) {
    if (dateStr == null) return false;
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);
      return difference.inHours < 24;
    } catch (e) {
      return false;
    }
  }

  List<dynamic> _getFilteredAndSortedApplications(List<dynamic> applications) {
    // Filter by search query
    var filtered = applications.where((app) {
      if (_searchQuery.isEmpty) return true;
      final title = (app.job?.title ?? '').toLowerCase();
      final company = (app.job?.company?.name ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || company.contains(query);
    }).toList();

    // Sort
    if (_sortBy == 'Mới nhất') {
      filtered.sort((a, b) {
        final dateA = DateTime.tryParse(a.appliedAt ?? '') ?? DateTime(1970);
        final dateB = DateTime.tryParse(b.appliedAt ?? '') ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });
    } else if (_sortBy == 'Cũ nhất') {
      filtered.sort((a, b) {
        final dateA = DateTime.tryParse(a.appliedAt ?? '') ?? DateTime(1970);
        final dateB = DateTime.tryParse(b.appliedAt ?? '') ?? DateTime(1970);
        return dateA.compareTo(dateB);
      });
    } else if (_sortBy == 'Tên A-Z') {
      filtered.sort((a, b) {
        final titleA = a.job?.title ?? '';
        final titleB = b.job?.title ?? '';
        return titleA.compareTo(titleB);
      });
    }

    return filtered;
  }

  Widget _buildFilterChip(String label, String? status, IconData icon, [Color? color]) {
    final isSelected = _selectedStatus == status;
    final chipColor = color ?? AppColors.primary;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : chipColor),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = status;
        });
        // Debug logging
        print('🔍 Filter selected: $status');
        
        // Refresh data with new filter
        final currentUser = ref.read(currentUserProvider);
        if (currentUser != null) {
          print('📞 Calling API with status filter: $_selectedStatus');
          ref.read(applicationProvider.notifier).getMyApplications(
              currentUser.userId, status: _selectedStatus);
        }
      },
      selectedColor: chipColor,
      backgroundColor: chipColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : chipColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? chipColor : chipColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Sắp xếp theo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSortOption('Mới nhất', Icons.access_time),
              _buildSortOption('Cũ nhất', Icons.history),
              _buildSortOption('Tên A-Z', Icons.sort_by_alpha),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, IconData icon) {
    final isSelected = _sortBy == label;
    return InkWell(
      onTap: () {
        setState(() {
          _sortBy = label;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: isSelected ? const Color(0xFF4285F4).withOpacity(0.1) : Colors
            .transparent,
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? const Color(0xFF4285F4) : AppColors
                  .textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF4285F4) : AppColors
                      .textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                size: 22,
                color: Color(0xFF4285F4),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationsProvider);
    final isLoading = ref.watch(applicationLoadingProvider);
    final error = ref.watch(applicationErrorProvider);

    final filteredApps = _getFilteredAndSortedApplications(applications);

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            // Custom Header with Sort Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                      Icons.account_circle, color: AppColors.textPrimary),
                ),
                const Text(
                  'Ứng tuyển',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: _showSortOptions,
                  icon: const Icon(
                      Icons.more_horiz_sharp, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Custom Search Box
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.searchBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tìm kiếm công việc, công ty...',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.searchIcon),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Tất cả', null, Icons.apps),
                  const SizedBox(width: 8),
                  _buildFilterChip('Chờ duyệt', 'Pending', Icons.schedule, const Color(0xFFFFA726)),
                  const SizedBox(width: 8),
                  _buildFilterChip('Xem xét', 'Review', Icons.visibility, const Color(0xFF4285F4)),
                  const SizedBox(width: 8),
                  _buildFilterChip('Chấp nhận', 'Accepted', Icons.check_circle, const Color(0xFF26C281)),
                  const SizedBox(width: 8),
                  _buildFilterChip('Từ chối', 'Rejected', Icons.cancel, const Color(0xFFFF6B6B)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Results count
            if (_searchQuery.isNotEmpty && !isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Tìm thấy ${filteredApps.length} kết quả',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            if (_searchQuery.isNotEmpty && !isLoading) const SizedBox(
                height: 12),

            // List of applications
            Expanded(
              child: _buildApplicationsList(filteredApps, isLoading, error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsList(List<dynamic> filteredApps,
      bool isLoading,
      String? error,) {
    if (isLoading) {
      return const AppLoadingIndicator(
        message: 'Đang tải danh sách ứng tuyển...',
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Thử lại',
              onPressed: () {
                final currentUser = ref.read(currentUserProvider);
                if (currentUser != null) {
                  ref.read(applicationProvider.notifier).getMyApplications(
                      currentUser.userId);
                }
              },
            ),
          ],
        ),
      );
    }

    if (filteredApps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              LottieAssets.noResultFound,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isEmpty
                  ? 'Chưa có đơn ứng tuyển nào'
                  : 'Không tìm thấy kết quả',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty
                  ? 'Hãy ứng tuyển việc làm để xem danh sách'
                  : 'Thử tìm kiếm với từ khóa khác',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredApps.length,
      itemBuilder: (context, index) {
        final app = filteredApps[index];
        final jobTitle = app.jobTitle ?? app.job?.title ?? 'N/A';
        final companyName = app.company?.name ?? app.job?.company?.name ?? 'Công ty';
        final location = app.company?.location ?? app.job?.location ?? 'N/A';
        final status = app.status ?? 'pending';
        final appliedAt = app.appliedAt;
        
        // Format salary using SalaryFormatter with structured fields
        final salaryDisplay = app.job != null
            ? SalaryFormatter.formatSalaryWithPeriod(
                salaryMin: app.job!.salaryMin,
                salaryMax: app.job!.salaryMax,
                salaryType: app.job!.salaryType,
              )
            : 'Thỏa thuận';
        
        // Debug: Print actual status from backend
        print('📊 Application Status from Backend: "$status" (type: ${status.runtimeType})');
        
        // Debug: Print salary data
        print('💰 Salary Debug:');
        print('   - Has job object: ${app.job != null}');
        if (app.job != null) {
          print('   - salaryMin: ${app.job!.salaryMin}');
          print('   - salaryMax: ${app.job!.salaryMax}');
          print('   - salaryType: ${app.job!.salaryType}');
          print('   - salaryRange (deprecated): ${app.job!.salaryRange}');
        }
        print('   - Formatted display: "$salaryDisplay"');

        return ItemApplicationNotification(
          title: jobTitle,
          company: companyName,
          date: _formatDate(appliedAt),
          message: _getStatusMessage(status),
          isNew: _isNewApplication(appliedAt),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ApplicationDetail(
                      applicationId: app.applicationId,
                      jobTitle: jobTitle,
                      companyName: companyName,
                      companyLogo: 'assets/logo_lutech.png',
                      location: location,
                      salary: salaryDisplay,
                      applicationStatus: status,
                    ),
              ),
            );
          },
        );
      },
    );
  }
}
