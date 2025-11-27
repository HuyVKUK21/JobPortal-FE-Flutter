import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:go_router/go_router.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () {
        // Navigate to search page
        context.pushNamed('searchJobs');
      },
      child: Container(
        height: SizeConfig.screenHeight * 0.06,
        decoration: BoxDecoration(
          color: AppColors.searchBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          enabled: false, // Disable text input, only allow tap to navigate
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppStrings.searchPlaceholder,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.searchIcon),
            suffixIcon: const Icon(Icons.filter_list, color: AppColors.searchIcon),
          ),
        ),
      ),
    );
  }
}
