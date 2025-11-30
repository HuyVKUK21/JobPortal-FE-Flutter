import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/providers/application_provider.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';

class ApplicationDetail extends ConsumerStatefulWidget {
  final int? applicationId;
  final String? jobTitle;
  final String? companyName;
  final String? location;
  final String? salary;
  final String? postedTime;
  final String? applicationStatus; // 'sent', 'reviewing', 'accepted', 'rejected'
  final String? companyLogo;

  const ApplicationDetail({
    super.key,
    this.applicationId,
    this.jobTitle,
    this.companyName,
    this.location,
    this.salary,
    this.postedTime,
    this.applicationStatus,
    this.companyLogo,
  });

  @override
  ConsumerState<ApplicationDetail> createState() => _ApplicationDetailState();
}

class _ApplicationDetailState extends ConsumerState<ApplicationDetail> {
  bool _isWithdrawing = false;

  Future<void> _handleWithdrawApplication() async {
    if (widget.applicationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy ID đơn ứng tuyển'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isWithdrawing = true;
    });

    try {
      await ref.read(applicationProvider.notifier).cancelApplication(widget.applicationId!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã rút đơn ứng tuyển thành công'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to applications list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isWithdrawing = false;
        });
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return const Color(0xFF26C281);
      case 'rejected':
        return const Color(0xFFFF6B6B);
      case 'reviewing':
        return const Color(0xFFFFA726);
      default:
        return const Color(0xFF4285F4);
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return 'Đơn đã gửi';
      case 'reviewing':
        return 'Đang xem xét';
      case 'accepted':
        return 'Đã chấp nhận';
      case 'rejected':
        return 'Đã từ chối';
      default:
        return 'Đơn đã gửi';
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayJobTitle = widget.jobTitle ?? 'UI/UX Designer';
    final displayCompanyName = widget.companyName ?? 'Google Inc.';
    final displayLocation = widget.location ?? 'California, United States';
    final displaySalary = widget.salary ?? '\$9,000 - \$15,000/month';
    final displayPostedTime = widget.postedTime ?? '2 days ago';
    final displayStatus = widget.applicationStatus ?? 'reviewing';
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Tiến trình ứng tuyển',
              iconHeaderLeftBar: Icons.arrow_back,
              iconHeaderRightBar: Icons.more_horiz_sharp,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Company Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        widget.companyLogo ?? 'assets/logo_lutech.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Job Title
                    Text(
                      displayJobTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    
                    // Company Name
                    Text(
                      displayCompanyName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Job Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.location_on_outlined,
                            label: 'Địa điểm',
                            value: displayLocation,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.attach_money,
                            label: 'Lương',
                            value: displaySalary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.access_time,
                      label: 'Đăng',
                      value: displayPostedTime,
                      fullWidth: true,
                    ),
                    const SizedBox(height: 32),
                    
                    // Application Status Title
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Trạng thái ứng tuyển',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Application Stages
                    _buildStage(
                      title: 'Đơn đã gửi',
                      isCompleted: true,
                      isActive: displayStatus == 'sent',
                      showLine: true,
                    ),
                    _buildStage(
                      title: 'Đang xem xét',
                      isCompleted: displayStatus == 'reviewing' || 
                                   displayStatus == 'accepted' || 
                                   displayStatus == 'rejected',
                      isActive: displayStatus == 'reviewing',
                      showLine: true,
                    ),
                    _buildStage(
                      title: displayStatus == 'rejected' 
                          ? 'Đơn bị từ chối' 
                          : 'Đơn được chấp nhận',
                      isCompleted: displayStatus == 'accepted' || 
                                   displayStatus == 'rejected',
                      isActive: displayStatus == 'accepted' || 
                               displayStatus == 'rejected',
                      showLine: false,
                      isRejected: displayStatus == 'rejected',
                    ),
                    const SizedBox(height: 32),
                    
                    // Your Application Status Badge
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(displayStatus).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(displayStatus).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Trạng thái của bạn: ',
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _getStatusText(displayStatus),
                            style: TextStyle(
                              fontSize: 15,
                              color: _getStatusColor(displayStatus),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Withdraw Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Rút đơn ứng tuyển'),
                        content: const Text(
                          'Bạn có chắc chắn muốn rút đơn ứng tuyển này không?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: _isWithdrawing ? null : () {
                              Navigator.pop(context); // Close dialog
                              _handleWithdrawApplication();
                            },
                            child: _isWithdrawing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                    ),
                                  )
                                : const Text(
                                    'Rút đơn',
                                    style: TextStyle(color: Colors.red),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Rút đơn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF4285F4),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStage({
    required String title,
    required bool isCompleted,
    required bool isActive,
    required bool showLine,
    bool isRejected = false,
  }) {
    final stageColor = isRejected 
        ? const Color(0xFFFF6B6B) 
        : isCompleted || isActive 
            ? const Color(0xFF26C281) 
            : AppColors.grey500;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted || isActive 
                    ? stageColor 
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: stageColor,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(
                      isRejected ? Icons.close : Icons.check,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (showLine)
              Container(
                width: 2,
                height: 40,
                color: isCompleted 
                    ? stageColor.withOpacity(0.3) 
                    : AppColors.grey500.withOpacity(0.2),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isCompleted || isActive 
                    ? AppColors.textPrimary 
                    : AppColors.grey500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
