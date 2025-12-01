import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class EnhancedSearchBox extends StatelessWidget {
  final String placeholder;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final bool showFilter;
  final int filterCount;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  
  const EnhancedSearchBox({
    super.key,
    this.placeholder = 'Tìm kiếm việc làm, công ty...',
    this.onTap,
    this.onFilterTap,
    this.showFilter = true,
    this.filterCount = 0,
    this.controller,
    this.onChanged,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: readOnly ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Search Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF3367D6)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Search Input
            Expanded(
              child: readOnly
                  ? Text(
                      placeholder,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : TextField(
                      controller: controller,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: placeholder,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
            
            // Filter Button with Badge
            if (showFilter) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onFilterTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: filterCount > 0
                            ? const Color(0xFF4285F4).withOpacity(0.1)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                        border: filterCount > 0
                            ? Border.all(
                                color: const Color(0xFF4285F4).withOpacity(0.3),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Icon(
                        Icons.tune,
                        color: filterCount > 0
                            ? const Color(0xFF4285F4)
                            : const Color(0xFF6B7280),
                        size: 20,
                      ),
                    ),
                    if (filterCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              filterCount > 9 ? '9+' : '$filterCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
