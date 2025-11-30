import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/lottie_assets.dart';
import 'package:lottie/lottie.dart';

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceXXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Illustration
              Lottie.asset(
                LottieAssets.noResultFound,
                width: 250,
                height: 250,
                fit: BoxFit.contain,
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
      ),
    );
  }
}
