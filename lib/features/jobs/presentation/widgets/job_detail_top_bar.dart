import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobDetailTopBar extends StatelessWidget {
  const JobDetailTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
            ),
          ),
          const Text(
            'Chi tiết công việc',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_border,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

