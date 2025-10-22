import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 100,
                  color: Colors.blue.shade400,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXL),
            
            // Title
            const Text(
              'Không tìm thấy',
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            
            // Description
            Text(
              'Xin lỗi, từ khoá bạn nhập không tìm thấy, vui lòng kiểm tra lại hoặc tìm kiếm với từ khoá khác',
              style: TextStyle(
                fontSize: AppDimensions.fontM,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
