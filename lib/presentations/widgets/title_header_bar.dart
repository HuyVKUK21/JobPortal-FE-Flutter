import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TitleHeaderBar extends StatelessWidget {
  final String titleHeaderBar;
  final IconData iconHeaderLeftBar;
  final IconData iconHeaderRightBar;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;

  const TitleHeaderBar({
    required this.titleHeaderBar,
    required this.iconHeaderLeftBar,
    required this.iconHeaderRightBar,
    this.onLeftPressed,
    this.onRightPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(iconHeaderLeftBar, color: Colors.black87),
          onPressed: onLeftPressed ?? () {
            if (iconHeaderLeftBar == Icons.arrow_back) {
              context.pop();
            }
          },
        ),
        Text(
          titleHeaderBar,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(iconHeaderRightBar, color: Colors.black87),
          onPressed: onRightPressed ?? () {},
        ),
      ],
    );
  }
}
