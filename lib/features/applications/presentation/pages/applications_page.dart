import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/presentations/widgets/item_application_notification.dart';
import 'package:flutter_application_1/presentations/pages/application_detail.dart';

class ApplicationsPage extends ConsumerStatefulWidget {
  const ApplicationsPage({super.key});

  @override
  ConsumerState<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends ConsumerState<ApplicationsPage> {
  String _searchQuery = '';
  String _sortBy = 'Mới nhất';

  // Sample data - TODO: Thay bằng API sau này
  final List<Map<String, dynamic>> _allApplications = [
    {
      'title': 'Senior Backend Developer',
      'company': 'VPBank',
      'date': '27 thg 11, 2025 | 10:00',
      'message': 'Đơn ứng tuyển của bạn đã được chấp nhận',
      'isNew': true,
      'status': 'accepted',
      'timestamp': DateTime(2025, 11, 27, 10, 0),
    },
    {
      'title': 'UI/UX Designer',
      'company': 'FPT Software',
      'date': '26 thg 11, 2025 | 14:30',
      'message': 'Đơn ứng tuyển của bạn đang được xem xét',
      'isNew': true,
      'status': 'reviewing',
      'timestamp': DateTime(2025, 11, 26, 14, 30),
    },
    {
      'title': 'Frontend Developer',
      'company': 'Techcombank',
      'date': '25 thg 11, 2025 | 09:15',
      'message': 'Đơn ứng tuyển của bạn đã được gửi',
      'isNew': false,
      'status': 'pending',
      'timestamp': DateTime(2025, 11, 25, 9, 15),
    },
    {
      'title': 'Product Manager',
      'company': 'Viettel',
      'date': '24 thg 11, 2025 | 16:45',
      'message': 'Đơn ứng tuyển của bạn đang được xử lý',
      'isNew': false,
      'status': 'pending',
      'timestamp': DateTime(2025, 11, 24, 16, 45),
    },
    {
      'title': 'Mobile Developer',
      'company': 'Vingroup',
      'date': '23 thg 11, 2025 | 11:20',
      'message': 'Đơn ứng tuyển của bạn đã được nhận',
      'isNew': false,
      'status': 'pending',
      'timestamp': DateTime(2025, 11, 23, 11, 20),
    },
    {
      'title': 'Data Analyst',
      'company': 'Grab Vietnam',
      'date': '22 thg 11, 2025 | 15:30',
      'message': 'Đơn ứng tuyển của bạn đã được gửi',
      'isNew': false,
      'status': 'pending',
      'timestamp': DateTime(2025, 11, 22, 15, 30),
    },
  ];

  List<Map<String, dynamic>> get _filteredApplications {
    var filtered = _allApplications.where((app) {
      if (_searchQuery.isEmpty) return true;
      final title = (app['title'] as String).toLowerCase();
      final company = (app['company'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || company.contains(query);
    }).toList();

    // Sort
    if (_sortBy == 'Mới nhất') {
      filtered.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
    } else if (_sortBy == 'Cũ nhất') {
      filtered.sort((a, b) => (a['timestamp'] as DateTime).compareTo(b['timestamp'] as DateTime));
    } else if (_sortBy == 'Tên A-Z') {
      filtered.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));
    }

    return filtered;
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
        color: isSelected ? const Color(0xFF4285F4).withOpacity(0.1) : Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? const Color(0xFF4285F4) : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF4285F4) : AppColors.textPrimary,
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
    final filteredApps = _filteredApplications;

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
                  icon: const Icon(Icons.account_circle, color: AppColors.textPrimary),
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
                  icon: const Icon(Icons.more_horiz_sharp, color: AppColors.textPrimary),
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
            
            // Results count
            if (_searchQuery.isNotEmpty)
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
            if (_searchQuery.isNotEmpty) const SizedBox(height: 12),
            
            // List of applications
            Expanded(
              child: filteredApps.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isEmpty ? Icons.work_outline : Icons.search_off,
                            size: 80,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(height: 16),
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
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filteredApps.length,
                      itemBuilder: (context, index) {
                        final app = filteredApps[index];
                        return ItemApplicationNotification(
                          title: app['title'] as String,
                          company: app['company'] as String,
                          date: app['date'] as String,
                          message: app['message'] as String,
                          isNew: app['isNew'] as bool,
                          onTap: () {
                            // TODO: Tích hợp API để lấy thông tin chi tiết
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ApplicationDetail(
                                  jobTitle: app['title'] as String,
                                  companyName: app['company'] as String,
                                  companyLogo: 'assets/logo_lutech.png',
                                  location: 'Hà Nội',
                                  salary: '20 - 40 triệu /tháng',
                                  applicationStatus: app['status'] as String,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
