import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/job_constants.dart';
import 'package:go_router/go_router.dart';

/// Sort options bottom sheet
class SortBottomSheet extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const Divider(height: 24),
          ..._buildSortOptions(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.swap_vert,
              size: 20,
              color: Color(0xFF4285F4),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Sắp xếp theo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSortOptions(BuildContext context) {
    return JobConstants.sortOptions.map((option) {
      final isSelected = option == selectedSort;
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(
          option,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? const Color(0xFF4285F4) : Colors.black87,
          ),
        ),
        trailing: isSelected
            ? Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF4285F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              )
            : null,
        onTap: () {
          onSortSelected(option);
          context.pop();
        },
      );
    }).toList();
  }
}
