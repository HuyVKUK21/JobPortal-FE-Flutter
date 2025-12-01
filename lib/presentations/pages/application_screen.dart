import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/core/utils/salary_formatter.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/widgets/widgets.dart';
import 'package:flutter_application_1/presentations/widgets/item_application_notification.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';
import 'package:flutter_application_1/presentations/pages/application_detail.dart';
import 'package:intl/intl.dart';

class ApplicationScreen extends ConsumerStatefulWidget {
  const ApplicationScreen({super.key});

  @override
  ConsumerState<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends ConsumerState<ApplicationScreen> {
  @override
  void initState() {
    super.initState();
    // Load applications when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.read(applicationProvider.notifier).getMyApplications(currentUser.userId);
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
      return difference.inHours < 24; // New if less than 24 hours
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationsProvider);
    final isLoading = ref.watch(applicationLoadingProvider);
    final error = ref.watch(applicationErrorProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Ứng tuyển',
              iconHeaderLeftBar: Icons.account_circle,
              iconHeaderRightBar: Icons.more_horiz_sharp,
            ),
            const SizedBox(height: 16),
            
            // List of applications
            Expanded(
              child: _buildApplicationsList(applications, isLoading, error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsList(
    List<dynamic> applications,
    bool isLoading,
    String? error,
  ) {
    if (isLoading) {
      return const AppLoadingIndicator(
        message: 'Đang tải danh sách ứng tuyển...',
      );
    }

    if (error != null) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Có lỗi xảy ra',
        subtitle: error,
        action: AppButton(
          text: 'Thử lại',
          onPressed: () {
            final currentUser = ref.read(currentUserProvider);
            if (currentUser != null) {
              ref.read(applicationProvider.notifier).getMyApplications(currentUser.userId);
            }
          },
        ),
      );
    }

    if (applications.isEmpty) {
      return EmptyState(
        icon: Icons.work_outline,
        title: 'Chưa có đơn ứng tuyển',
        subtitle: 'Hãy tìm kiếm và ứng tuyển các công việc phù hợp với bạn',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final app = applications[index];
        final jobTitle = app.job?.title ?? 'N/A';
        final companyName = app.job?.company?.name ?? 'Công ty';
        final status = app.status ?? 'pending';
        final appliedAt = app.appliedAt;
        
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
                builder: (context) => ApplicationDetail(
                  jobTitle: jobTitle,
                  companyName: companyName,
                  companyLogo: 'assets/logo_lutech.png',
                  location: app.job?.location ?? 'N/A',
                  salary: SalaryFormatter.formatSalary(
                    salaryMin: app.job?.salaryMin,
                    salaryMax: app.job?.salaryMax,
                    salaryType: app.job?.salaryType,
                  ),
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
