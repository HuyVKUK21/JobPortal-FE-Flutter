import 'package:flutter/material.dart';

class JobTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentTab;
  final void Function(int) onTap;

  const JobTabBar({
    required this.tabs,
    required this.currentTab,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isActive = currentTab == index;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  color: isActive ? const Color(0xFF246BFD) : Colors.black54,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                child: Text(tabs[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
