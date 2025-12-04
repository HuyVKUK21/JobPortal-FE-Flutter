import 'package:flutter/material.dart';

/// Results summary card with count and sort button
class ResultsSummary extends StatelessWidget {
  final int resultsCount;
  final VoidCallback onSortTap;

  const ResultsSummary({
    super.key,
    required this.resultsCount,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildResultsCount(),
          _buildSortButton(),
        ],
      ),
    );
  }

  Widget _buildResultsCount() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.check_circle,
            size: 18,
            color: Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$resultsCount kết quả',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const Text(
              'Tìm thấy',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSortTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4285F4).withOpacity(0.1),
                const Color(0xFF3367D6).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4285F4).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: const [
              Icon(
                Icons.swap_vert,
                size: 18,
                color: Color(0xFF4285F4),
              ),
              SizedBox(width: 6),
              Text(
                'Sắp xếp',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4285F4),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
