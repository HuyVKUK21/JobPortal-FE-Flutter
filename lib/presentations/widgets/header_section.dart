import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final VoidCallback onPressed;
  const HeaderSection({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/avatar.jpg'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chào buổi sáng', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text(
              'Phạm Quốc Huy',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const Spacer(),
        IconButton(onPressed: onPressed, icon: Icon(Icons.notifications_none)),
      ],
    );
  }
}
