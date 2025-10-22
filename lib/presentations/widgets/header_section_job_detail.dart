import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderSectionJobDetail extends StatelessWidget {
  const HeaderSectionJobDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            context.pop();
          },
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.bookmark_add_sharp, color: Colors.black87),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.ios_share, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }
}
