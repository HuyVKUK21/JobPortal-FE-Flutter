import 'package:flutter/widgets.dart';

class JobDetailInfomation extends StatelessWidget {
  final List<String> items;
  final String title;
  const JobDetailInfomation({
    required this.items,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 6),
        ...items.map(
          (text) => Row(
            children: [
              const Text('•', style: TextStyle(fontSize: 18, height: 1.5)),
              const SizedBox(width: 8),
              Expanded(child: Text(text, style: const TextStyle(height: 1.5))),
            ],
          ),
        ),
      ],
    );
  }
}
