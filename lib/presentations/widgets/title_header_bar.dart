import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TitleHeaderBar extends StatelessWidget {
  final String titleHeaderBar;
  final IconData iconHeaderLeftBar;
  final IconData iconHeaderRightBar;
  const TitleHeaderBar({
    required this.titleHeaderBar,
    required this.iconHeaderLeftBar,
    required this.iconHeaderRightBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconHeaderLeftBar, color: const Color.fromARGB(255, 17, 67, 18)),
        SizedBox(width: 12),
        Text(
          titleHeaderBar,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Spacer(),
        Icon(iconHeaderRightBar),
      ],
    );
  }
}
