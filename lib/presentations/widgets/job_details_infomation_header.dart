import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/core/widgets/build_tag.dart';
import 'package:flutter_application_1/core/models/job.dart';

class JobDetailInfomationHeader extends StatelessWidget {
  final Job job;
  
  const JobDetailInfomationHeader({super.key, required this.job});

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final double logoSize = SizeConfig.screenWidth * 0.14;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 246, 243, 243)),
      ),
      child: Padding(
        padding: EdgeInsets.all(4 * SizeConfig.blockWidth),
        child: Column(
          children: [
            Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromARGB(255, 246, 243, 243),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/logo_lutech.png', fit: BoxFit.contain),
            ),
            SizedBox(height: 6),
            Text(
              job.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              job.company?.name ?? 'Công ty',
              style: TextStyle(color: const Color(0xFF246BFD)),
            ),
            SizedBox(height: 6),
            Divider(),
            SizedBox(height: 6),
            Text(
              job.location,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
            SizedBox(height: 4),
            Text(
              job.salaryRange ?? 'Thỏa thuận',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                buildTag(job.jobType ?? 'Full Time'),
                buildTag(job.workLocation ?? 'Văn phòng'),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Đăng vào ${_formatDate(job.postedAt)}, hết hạn ${_formatDate(job.expiresAt)}',
              style: TextStyle(
                color: const Color.fromARGB(221, 103, 102, 102),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
