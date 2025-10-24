import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';

class SimpleFilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;

  const SimpleFilterBottomSheet({
    super.key,
    required this.onApply,
  });

  @override
  State<SimpleFilterBottomSheet> createState() => _SimpleFilterBottomSheetState();
}

class _SimpleFilterBottomSheetState extends State<SimpleFilterBottomSheet> {
  String? _selectedLocation;
  String? _selectedJobType;
  String? _selectedWorkLocation;

  // Actual data from API
  final List<String> _locations = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Hải Phòng',
    'Cần Thơ',
    'Remote',
  ];

  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
  ];

  final List<String> _workLocations = [
    'Office',
    'Remote',
    'Hybrid',
  ];

  void _handleApply() {
    widget.onApply({
      'location': _selectedLocation,
      'jobType': _selectedJobType,
      'workLocation': _selectedWorkLocation,
    });
    Navigator.pop(context);
  }

  void _handleReset() {
    setState(() {
      _selectedLocation = null;
      _selectedJobType = null;
      _selectedWorkLocation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bộ lọc',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _handleReset,
                  child: const Text(
                    'Đặt lại',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location filter
                  _buildFilterSection(
                    title: 'Địa điểm',
                    options: _locations,
                    selectedValue: _selectedLocation,
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: AppDimensions.spaceL),
                  
                  // Job Type filter
                  _buildFilterSection(
                    title: 'Loại công việc',
                    options: _jobTypes,
                    selectedValue: _selectedJobType,
                    onChanged: (value) {
                      setState(() {
                        _selectedJobType = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: AppDimensions.spaceL),
                  
                  // Work Location filter
                  _buildFilterSection(
                    title: 'Hình thức làm việc',
                    options: _workLocations,
                    selectedValue: _selectedWorkLocation,
                    onChanged: (value) {
                      setState(() {
                        _selectedWorkLocation = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Apply button
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Áp dụng bộ lọc',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () {
                onChanged(isSelected ? null : option);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

