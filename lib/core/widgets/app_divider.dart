import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

/// Reusable divider with text
class AppDivider extends StatelessWidget {
  final String? text;
  final Color color;
  final double thickness;
  final double indent;
  final double endIndent;

  const AppDivider({
    super.key,
    this.text,
    this.color = AppColors.borderLight,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
  });

  /// Divider with text in the middle
  factory AppDivider.withText(String text) {
    return AppDivider(text: text);
  }

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Row(
        children: [
          Expanded(
            child: Divider(
              color: color,
              thickness: thickness,
              indent: indent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: color,
              thickness: thickness,
              endIndent: endIndent,
            ),
          ),
        ],
      );
    }

    return Divider(
      color: color,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
