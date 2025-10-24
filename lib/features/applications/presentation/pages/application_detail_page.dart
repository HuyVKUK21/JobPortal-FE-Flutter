import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/application.dart';

class ApplicationDetailPage extends StatelessWidget {
  final ApplicationResponse application;

  const ApplicationDetailPage({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết đơn ứng tuyển',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getCompanyColor(application.job?.company?.name ?? ''),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _getCompanyInitial(application.job?.company?.name ?? ''),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              application.job?.title ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              application.job?.company?.name ?? 'N/A',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(application.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(application.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Application Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin đơn ứng tuyển',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDetailRow('ID Đơn ứng tuyển', '#${application.applicationId}'),
                  _buildDetailRow('Ngày ứng tuyển', _formatDate(application.appliedAt)),
                  _buildDetailRow('Trạng thái', _getStatusText(application.status)),
                  
                  if (application.coverLetter != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Thư động lực',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        application.coverLetter!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  
                  if (application.resume != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'CV/Resume',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red[600],
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              application.resume!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.download,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Job Details
            if (application.job != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin công việc',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildDetailRow('Vị trí', application.job!.title),
                    _buildDetailRow('Công ty', application.job!.company?.name ?? 'N/A'),
                    _buildDetailRow('Địa điểm', application.job!.location),
                    _buildDetailRow('Loại hình', application.job!.jobType ?? 'N/A'),
                    _buildDetailRow('Mức lương', application.job!.salaryRange ?? 'N/A'),
                    _buildDetailRow('Ngày đăng', _formatDate(application.job!.postedAt ?? '')),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Color _getCompanyColor(String companyName) {
    switch (companyName.toLowerCase()) {
      case 'google':
        return const Color(0xFF4285F4);
      case 'paypal':
        return const Color(0xFF0070BA);
      case 'figma':
        return const Color(0xFFF24E1E);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'pinterest':
        return const Color(0xFFE60023);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getCompanyInitial(String companyName) {
    if (companyName.isEmpty) return '?';
    
    switch (companyName.toLowerCase()) {
      case 'google':
        return 'G';
      case 'paypal':
        return 'P';
      case 'figma':
        return 'F';
      case 'twitter':
        return 'T';
      case 'pinterest':
        return 'P';
      default:
        return companyName[0].toUpperCase();
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'sent':
      case 'submitted':
        return const Color(0xFF3B82F6); // Blue
      case 'accepted':
      case 'approved':
        return const Color(0xFF10B981); // Green
      case 'rejected':
      case 'declined':
        return const Color(0xFFEF4444); // Red
      case 'pending':
      case 'review':
        return const Color(0xFFF59E0B); // Yellow/Orange
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'sent':
      case 'submitted':
        return 'Đã gửi';
      case 'accepted':
      case 'approved':
        return 'Đã chấp nhận';
      case 'rejected':
      case 'declined':
        return 'Đã từ chối';
      case 'pending':
      case 'review':
        return 'Đang xem xét';
      default:
        return 'Không xác định';
    }
  }
}
