import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/core/widgets/build_tag.dart';

class CardItemJob extends StatelessWidget {
  final String titleJob;
  final String conpanyJob;
  final String location;
  final String workSalary;
  final String workingTime;
  final String workLocation;
  final String logoCompany;
  final VoidCallback? onTap;
  final bool isSaved;
  final VoidCallback? onBookmarkTap;
  const CardItemJob({
    required this.titleJob,
    required this.conpanyJob,
    required this.location,
    required this.workingTime,
    required this.workSalary,
    required this.workLocation,
    required this.logoCompany,
    this.onTap,
    this.isSaved = false,
    this.onBookmarkTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double logoSize = SizeConfig.screenWidth * 0.12;
    final double gapBetweenLogoAndContent = 12;
    final double leftInset = logoSize + gapBetweenLogoAndContent;
    return GestureDetector(
      onTap: onTap,
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
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 246, 243, 243),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(logoCompany, fit: BoxFit.contain),
              ),

              SizedBox(width: gapBetweenLogoAndContent),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleJob,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(conpanyJob, style: TextStyle(color: Colors.black54)),
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
                Text(workLocation, style: TextStyle(color: Colors.black87)),

                const SizedBox(height: 8),

                Text(
                  workSalary,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 12),
                // Tags: workingTime first, then location
                Wrap(
                  spacing: 10,
                  children: [
                    buildTag(workingTime), 
                    buildTag(location)
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
