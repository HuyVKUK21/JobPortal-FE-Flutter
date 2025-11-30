import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';

class HeaderSection extends ConsumerWidget {
  final VoidCallback onPressed;
  const HeaderSection({required this.onPressed, super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Chào buổi sáng';
    } else if (hour < 18) {
      return 'Chào buổi chiều';
    } else {
      return 'Chào buổi tối';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final greeting = _getGreeting();
    final userName = currentUser != null 
        ? '${currentUser.firstName} ${currentUser.lastName}'
        : 'Khách';
    
    // Get first letter of first name for avatar
    final initial = currentUser?.firstName.isNotEmpty == true 
        ? currentUser!.firstName[0].toUpperCase()
        : 'K';

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4285F4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}
