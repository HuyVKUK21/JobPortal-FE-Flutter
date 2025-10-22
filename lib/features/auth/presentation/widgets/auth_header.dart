import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';

/// Auth page header widget
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppDimensions.fontLargeTitle,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: AppDimensions.fontL,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

