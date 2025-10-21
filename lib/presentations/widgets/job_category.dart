import 'package:flutter/material.dart';

class JobCategory extends StatelessWidget {
  final List<String> categories;

  const JobCategory({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < categories.length; i++) ...[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF248BFD)),
              ),
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: 20,
                right: 20,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: Text(
                  categories[i],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF248BFD),
                  ),
                ),
              ),
            ),
            if (i != categories.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
