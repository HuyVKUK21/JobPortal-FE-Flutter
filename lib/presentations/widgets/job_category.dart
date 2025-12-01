import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/job.dart';

class JobCategory extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final Function(int?)? onCategorySelected; // Optional for backward compatibility

  const JobCategory({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "Tất cả" chip
          _buildCategoryChip(
            label: 'Tất cả',
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected?.call(null),
          ),
          const SizedBox(width: 8),
          
          // Category chips from API
          for (int i = 0; i < categories.length; i++) ...[
            _buildCategoryChip(
              label: categories[i].name,
              isSelected: selectedCategoryId == categories[i].categoryId,
              onTap: () => onCategorySelected?.call(categories[i].categoryId),
            ),
            if (i != categories.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF248BFD) : const Color(0xFFE0E0E0),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected ? const Color(0xFF248BFD).withValues(alpha: 0.1) : Colors.white,
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
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: const Color(0xFF248BFD),
          ),
        ),
      ),
    );
  }
}
