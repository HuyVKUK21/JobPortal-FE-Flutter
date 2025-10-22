import 'package:flutter/material.dart';

class JobDetailSummaryCard extends StatelessWidget {
  final String title;

  const JobDetailSummaryCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildInfoRow('Loại công việc', 'Full Time'),
              const SizedBox(height: 12),
              _buildInfoRow('Mức lương', '40 - 80 triệu /tháng'),
              const SizedBox(height: 12),
              _buildInfoRow('Địa điểm', 'TP. Huế & 2 nơi khác'),
              const SizedBox(height: 12),
              _buildInfoRow('Hạn nộp', '31/12/2024'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

