import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/job.dart';

class JobDetailInfomationSummary extends StatelessWidget {
  final String title;
  final Job job;
  const JobDetailInfomationSummary({required this.title, required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        
        // First Row - Job Level and Category
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildInfoItem(
                'Trình độ công việc',
                'Không yêu cầu', // jobLevel removed from API
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoItem(
                'Danh mục công việc',
                job.categories.isNotEmpty ? job.categories.first.name : 'Không có',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Second Row - Education and Experience
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildInfoItem(
                'Trình độ học vấn',
                'Không yêu cầu', // education removed from API
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoItem(
                'Yêu cầu kinh nghiệm',
                job.experienceRequired?.experiences ?? 'Không yêu cầu',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Third Row - Applicants and Website
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildInfoItem(
                'Số lượng ứng tuyển',
                '0 người', // numberOfApplicants removed from API
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoItem(
                'Website công ty',
                job.company?.website ?? 'Không có',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF246BFD),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
