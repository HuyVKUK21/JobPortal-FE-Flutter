import 'package:flutter/material.dart';

class JobDetailInfomationSummary extends StatelessWidget {
  final String title;
  const JobDetailInfomationSummary({required this.title, super.key});

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
                children: const [
                  Text('Trình độ công việc', style: TextStyle()),
                  SizedBox(height: 4),
                  Text(
                    'Junior',
                    style: TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Yêu cầu học vấn', style: TextStyle()),
                  SizedBox(height: 4),
                  Text(
                    'Đại học trở lên',
                    style: TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Số lượng', style: TextStyle()),
                  SizedBox(height: 4),
                  Text(
                    '2 người',
                    style: TextStyle(
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
                children: const [
                  Text('Danh mục công việc', style: TextStyle()),
                  SizedBox(height: 4),
                  Text(
                    'Công nghệ phần mềm',
                    softWrap: true,
                    overflow: TextOverflow.visible,

                    style: TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Yêu cầu kinh nghiệm', style: TextStyle()),
                  SizedBox(height: 4),
                  Text(
                    '1-3 năm',
                    style: TextStyle(
                      color: Color(0xFF246BFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Website', style: TextStyle()),
                  SizedBox(height: 4),
                  Text(
                    'lutech.vn',
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
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
