import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Trang chủ'},
      {'icon': Icons.bookmark_outline, 'label': 'Đã lưu'},
      {'icon': Icons.work_outline, 'label': 'Ứng tuyển'},
      {'icon': Icons.chat_bubble_outline, 'label': 'Tin nhắn'},
      {'icon': Icons.person_outline, 'label': 'Hồ sơ'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 6 * SizeConfig.blockWidth,
          right: 6 * SizeConfig.blockWidth,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;

            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 250),
                      scale: isSelected ? 1.3 : 1.0,
                      curve: Curves.easeOutBack,
                      child: Icon(
                        item['icon'] as IconData,
                        color: isSelected
                            ? const Color(0xFF007AFF)
                            : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isSelected ? 1.0 : 0.7,
                      child: Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF007AFF)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
