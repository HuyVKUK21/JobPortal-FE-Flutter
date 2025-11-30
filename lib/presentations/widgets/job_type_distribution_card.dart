import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

class JobTypeDistributionCard extends StatelessWidget {
  const JobTypeDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.pie_chart_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phân bố loại hình',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Các loại công việc phổ biến',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isSmallScreen = screenWidth < 380;
              final chartSize = isSmallScreen ? 140.0 : 180.0;
              
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Donut Chart
                  SizedBox(
                    width: chartSize,
                    height: chartSize,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: chartSize * 0.35,
                        sections: [
                          PieChartSectionData(
                            color: const Color(0xFF4285F4),
                            value: 65,
                            title: '65%',
                            radius: chartSize * 0.22,
                            titleStyle: TextStyle(
                              fontSize: isSmallScreen ? 11 : 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: const Color(0xFFFF6B00),
                            value: 15,
                            title: '15%',
                            radius: chartSize * 0.22,
                            titleStyle: TextStyle(
                              fontSize: isSmallScreen ? 11 : 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: const Color(0xFF8B5CF6),
                            value: 12,
                            title: '12%',
                            radius: chartSize * 0.22,
                            titleStyle: TextStyle(
                              fontSize: isSmallScreen ? 11 : 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: const Color(0xFF26C281),
                            value: 8,
                            title: '8%',
                            radius: chartSize * 0.22,
                            titleStyle: TextStyle(
                              fontSize: isSmallScreen ? 11 : 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 16 : 24),
                  // Legend
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLegendItem(
                          'Full-time',
                          const Color(0xFF4285F4),
                          '65%',
                          Icons.work,
                          isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 8 : 12),
                        _buildLegendItem(
                          'Part-time',
                          const Color(0xFFFF6B00),
                          '15%',
                          Icons.access_time,
                          isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 8 : 12),
                        _buildLegendItem(
                          'Remote',
                          const Color(0xFF8B5CF6),
                          '12%',
                          Icons.home_work,
                          isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 8 : 12),
                        _buildLegendItem(
                          'Contract',
                          const Color(0xFF26C281),
                          '8%',
                          Icons.description,
                          isSmallScreen,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    String label,
    Color color,
    String percentage,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: isSmallScreen ? 14 : 16,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$percentage việc',
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 11,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
