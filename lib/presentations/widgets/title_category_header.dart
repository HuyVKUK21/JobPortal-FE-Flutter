import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TitleCategoryHeader extends StatelessWidget {
  final String titleCategoryHeader;
  final VoidCallback onPressed;
  const TitleCategoryHeader({
    required this.onPressed,
    required this.titleCategoryHeader,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          titleCategoryHeader,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Spacer(),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onPressed,
          child: Text(
            'Xem tất cả',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xFF248BFD),
            ),
          ),
        ),
      ],
    );
  }
}
