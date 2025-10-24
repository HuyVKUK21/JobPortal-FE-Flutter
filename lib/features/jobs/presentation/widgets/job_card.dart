import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/core/widgets/tag_chip.dart';

/// Job card component for displaying job listing
class JobCard extends StatelessWidget {
  final String title;
  final String companyName;
  final String location;
  final String salary;
  final String workingTime;
  final String workLocation;
  final String companyLogo;
  final bool isSaved;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  const JobCard({
    super.key,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.workingTime,
    required this.workLocation,
    required this.companyLogo,
    this.isSaved = false,
    this.onTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final double logoSize = SizeConfig.screenWidth * 0.12;
    final double gapBetweenLogoAndContent = 12;
    final double leftInset = logoSize + gapBetweenLogoAndContent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE3DEDE)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFF6F3F3),
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(companyLogo, fit: BoxFit.contain),
                ),
                SizedBox(width: gapBetweenLogoAndContent),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        companyName,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onBookmarkTap,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.red : Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.only(left: leftInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workLocation,
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    salary,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: [
                      TagChip(label: workingTime),
                      TagChip(label: location),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

