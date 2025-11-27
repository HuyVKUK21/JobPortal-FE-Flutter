import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/application.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/company_colors.dart';
import 'package:flutter_application_1/core/constants/status_colors.dart';

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
    final companyName = application.job?.company?.name ?? 'N/A';
    final jobTitle = application.job?.title ?? 'N/A';
    final status = application.status;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Company Logo - Circular with brand color
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: CompanyColors.getColor(companyName),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  CompanyColors.getInitial(companyName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
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
                    jobTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Company Name
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: StatusColors.getBackgroundColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      StatusColors.getStatusText(status),
                      style: TextStyle(
                        color: StatusColors.getTextColor(status),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Arrow Icon
            const Icon(
              Icons.chevron_right,
              color: AppColors.iconGrey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
