import 'package:flutter/material.dart';

class JobSkill extends StatelessWidget {
  final String title;
  final List<String> categories;

  const JobSkill({super.key, required this.title, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: categories.map((category) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF246BFD)),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF246BFD),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
