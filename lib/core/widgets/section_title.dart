import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const SectionTitle({
    super.key,
    required this.title,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w600,
    this.color = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
