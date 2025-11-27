import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ResultRow> rows;

  const ResultCard({
    super.key,
    required this.title,
    this.subtitle = '(VNĐ)',
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ...rows.map((row) => row).toList(),
        ],
      ),
    );
  }
}

class ResultRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isHighlight;
  final Color? color;
  final bool showDivider;

  const ResultRow({
    super.key,
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.color,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###', 'vi_VN');

    return Column(
      children: [
        if (showDivider) const Divider(height: 24),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isHighlight ? 15 : 14,
                    fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
                    color: color ?? (isHighlight ? AppColors.textPrimary : AppColors.textSecondary),
                  ),
                ),
              ),
              Text(
                currencyFormat.format(value.abs()),
                style: TextStyle(
                  fontSize: isHighlight ? 16 : 14,
                  fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
                  color: color ?? (value < 0 ? Colors.red : AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
