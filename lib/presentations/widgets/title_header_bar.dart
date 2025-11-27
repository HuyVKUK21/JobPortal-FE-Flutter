import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class TitleHeaderBar extends StatelessWidget {
  final String titleHeaderBar;
  final IconData iconHeaderLeftBar;
  final IconData iconHeaderRightBar;

  const TitleHeaderBar({
    super.key,
    required this.titleHeaderBar,
    required this.iconHeaderLeftBar,
    required this.iconHeaderRightBar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(iconHeaderLeftBar, color: AppColors.textPrimary),
        ),
        Text(
          titleHeaderBar,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(iconHeaderRightBar, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
