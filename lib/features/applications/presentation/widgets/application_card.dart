import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/application.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationResponse application;
  final VoidCallback onTap;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Company Logo
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getCompanyColor(application.job?.company?.name ?? ''),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _getCompanyInitial(application.job?.company?.name ?? ''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Job Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Title
                  Text(
                    application.job?.title ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Company Name
                  Text(
                    application.job?.company?.name ?? 'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(application.status),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _getStatusText(application.status),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Arrow Icon
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
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
        return 'Application Sent';
      case 'accepted':
      case 'approved':
        return 'Application Accepted';
      case 'rejected':
      case 'declined':
        return 'Application Rejected';
      case 'pending':
      case 'review':
        return 'Application Pending';
      default:
        return 'Unknown Status';
    }
  }
}
