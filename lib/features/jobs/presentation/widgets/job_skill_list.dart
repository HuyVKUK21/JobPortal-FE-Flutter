import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/tag_chip.dart';

class JobSkillList extends StatelessWidget {
  final String title;
  final List<String> skills;

  const JobSkillList({
    super.key,
    required this.title,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: skills.map((skill) => TagChip(label: skill)).toList(),
        ),
      ],
    );
  }
}

