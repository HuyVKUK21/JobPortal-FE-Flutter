import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final String subtitle;
  final Color color;
  final bool showTrend;
  final double? trendValue;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.showTrend = false,
    this.trendValue,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              if (showTrend && trendValue != null)
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 6 : 8,
                      vertical: isSmallScreen ? 3 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: trendValue! >= 0
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendValue! >= 0
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: isSmallScreen ? 12 : 14,
                          color: trendValue! >= 0 ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${trendValue!.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10 : 11,
                            fontWeight: FontWeight.w600,
                            color: trendValue! >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 10 : 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: value.toDouble()),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, child) {
              return Text(
                animatedValue.toInt().toString(),
                style: TextStyle(
                  fontSize: isSmallScreen ? 26 : 30,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1.1,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 11,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
