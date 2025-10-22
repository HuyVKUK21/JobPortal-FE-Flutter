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
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Trình độ công việc', style: TextStyle()),
                  const SizedBox(height: 4),
                  Text(
                    job.jobInformation?.jobLevel ?? 'Không yêu cầu',
                    style: const TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Yêu cầu học vấn', style: TextStyle()),
                  const SizedBox(height: 4),
                  Text(
                    job.jobInformation?.education ?? 'Không yêu cầu',
                    style: const TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Số lượng ứng viên', style: TextStyle()),
                  const SizedBox(height: 4),
                  Text(
                    '${job.jobInformation?.numberOfApplicants ?? 0} người',
                    style: const TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Danh mục công việc', style: TextStyle()),
                  const SizedBox(height: 4),
                  Text(
                    job.categories.isNotEmpty ? job.categories.first.name : 'Không có',
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Yêu cầu kinh nghiệm', style: TextStyle()),
                  const SizedBox(height: 4),
                  Text(
                    job.experienceRequired?.experiences ?? 'Không yêu cầu',
                    style: const TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Website', style: TextStyle()),
                  const SizedBox(height: 4),
                  Text(
                    job.company?.website ?? 'Không có',
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
