import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Image.asset(
        'assets/header_banner_mobile.webp',
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
