import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimensions.dart';
import 'package:flutter_application_1/core/constants/job_constants.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;

  const FilterBottomSheet({
    super.key,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String _selectedLocation = 'Hà Nội';
  RangeValues _salaryRange = const RangeValues(5, 100);
  String _selectedWorkType = JobConstants.workTypeOnsite;
  Set<String> _selectedJobLevels = {};
  Set<String> _selectedEmploymentTypes = {};
  String? _selectedExperience;
  Set<String> _selectedEducation = {};
  Set<String> _selectedJobFunctions = {};

  bool _isLocationSalaryExpanded = true;
  bool _isWorkTypeExpanded = true;
  bool _isJobLevelExpanded = true;
  bool _isEmploymentTypeExpanded = false;
  bool _isExperienceExpanded = false;
  bool _isEducationExpanded = false;
  bool _isJobFunctionExpanded = false;

  void _handleApply() {
    widget.onApply({
      'location': _selectedLocation,
      'salaryRange': _salaryRange,
      'workType': _selectedWorkType,
      'jobLevels': _selectedJobLevels,
      'employmentTypes': _selectedEmploymentTypes,
      'experience': _selectedExperience,
      'education': _selectedEducation,
      'jobFunctions': _selectedJobFunctions,
    });
    Navigator.pop(context);
  }

  void _handleReset() {
    setState(() {
      _selectedLocation = 'Hà Nội';
      _salaryRange = const RangeValues(5, 100);
      _selectedWorkType = JobConstants.workTypeOnsite;
      _selectedJobLevels.clear();
      _selectedEmploymentTypes.clear();
      _selectedExperience = null;
      _selectedEducation.clear();
      _selectedJobFunctions.clear();
    });
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusL)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
              child: Text(
                'Chọn địa điểm',
                style: TextStyle(
                  fontSize: AppDimensions.fontXL,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Expanded(
              child: ListView(
                children: JobConstants.vietnameseCities.map((city) {
                  final isSelected = city == _selectedLocation;
                  return ListTile(
                    title: Text(
                      city,
                      style: TextStyle(
                        fontSize: AppDimensions.fontM,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.primary : Colors.black87,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedLocation = city;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.space),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Tuỳ chọn lọc',
                    style: TextStyle(
                      fontSize: AppDimensions.fontXL,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space),
              child: Column(
                children: [
                  _buildLocationSalarySection(),
                  _buildWorkTypeSection(),
                  _buildJobLevelSection(),
                  _buildEmploymentTypeSection(),
                  _buildExperienceSection(),
                  _buildEducationSection(),
                  _buildJobFunctionSection(),
                  const SizedBox(height: AppDimensions.spaceL),
                ],
              ),
            ),
          ),

          // Buttons
          Container(
            padding: const EdgeInsets.all(AppDimensions.space),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleReset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space),
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      ),
                    ),
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.space),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _handleApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) content,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildLocationSalarySection() {
    return _buildExpandableSection(
      title: 'Địa điểm & Lương',
      isExpanded: _isLocationSalaryExpanded,
      onToggle: () => setState(() => _isLocationSalaryExpanded = !_isLocationSalaryExpanded),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _showLocationPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceM,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 20),
                  const SizedBox(width: AppDimensions.spaceS),
                  Expanded(
                    child: Text(
                      _selectedLocation,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontM,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_salaryRange.start.round()} Tr',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_salaryRange.end.round()} Tr',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child: RangeSlider(
              values: _salaryRange,
              min: JobConstants.minSalary,
              max: JobConstants.maxSalary,
              onChanged: (values) {
                setState(() {
                  _salaryRange = values;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceM,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'mỗi tháng',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
        ],
      ),
    );
  }

  Widget _buildWorkTypeSection() {
    return _buildExpandableSection(
      title: 'Loại hình công việc',
      isExpanded: _isWorkTypeExpanded,
      onToggle: () => setState(() => _isWorkTypeExpanded = !_isWorkTypeExpanded),
      content: Column(
        children: JobConstants.workTypes.map((type) {
          return RadioListTile<String>(
            value: type,
            groupValue: _selectedWorkType,
            onChanged: (value) {
              setState(() {
                _selectedWorkType = value!;
              });
            },
            title: Text(
              type,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
              ),
            ),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJobLevelSection() {
    return _buildExpandableSection(
      title: 'Cấp bậc',
      isExpanded: _isJobLevelExpanded,
      onToggle: () => setState(() => _isJobLevelExpanded = !_isJobLevelExpanded),
      content: Column(
        children: JobConstants.jobLevels.map((level) {
          return CheckboxListTile(
            value: _selectedJobLevels.contains(level),
            onChanged: (checked) {
              setState(() {
                if (checked!) {
                  _selectedJobLevels.add(level);
                } else {
                  _selectedJobLevels.remove(level);
                }
              });
            },
            title: Text(
              level,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
              ),
            ),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmploymentTypeSection() {
    return _buildExpandableSection(
      title: 'Loại hợp đồng',
      isExpanded: _isEmploymentTypeExpanded,
      onToggle: () => setState(() => _isEmploymentTypeExpanded = !_isEmploymentTypeExpanded),
      content: Column(
        children: JobConstants.employmentTypes.map((type) {
          return CheckboxListTile(
            value: _selectedEmploymentTypes.contains(type),
            onChanged: (checked) {
              setState(() {
                if (checked!) {
                  _selectedEmploymentTypes.add(type);
                } else {
                  _selectedEmploymentTypes.remove(type);
                }
              });
            },
            title: Text(
              type,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
              ),
            ),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return _buildExpandableSection(
      title: 'Kinh nghiệm',
      isExpanded: _isExperienceExpanded,
      onToggle: () => setState(() => _isExperienceExpanded = !_isExperienceExpanded),
      content: Column(
        children: JobConstants.experienceLevels.map((exp) {
          return RadioListTile<String>(
            value: exp,
            groupValue: _selectedExperience,
            onChanged: (value) {
              setState(() {
                _selectedExperience = value;
              });
            },
            title: Text(
              exp,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
              ),
            ),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEducationSection() {
    return _buildExpandableSection(
      title: 'Trình độ học vấn',
      isExpanded: _isEducationExpanded,
      onToggle: () => setState(() => _isEducationExpanded = !_isEducationExpanded),
      content: Column(
        children: JobConstants.educationLevels.map((edu) {
          return CheckboxListTile(
            value: _selectedEducation.contains(edu),
            onChanged: (checked) {
              setState(() {
                if (checked!) {
                  _selectedEducation.add(edu);
                } else {
                  _selectedEducation.remove(edu);
                }
              });
            },
            title: Text(
              edu,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
              ),
            ),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJobFunctionSection() {
    return _buildExpandableSection(
      title: 'Lĩnh vực',
      isExpanded: _isJobFunctionExpanded,
      onToggle: () => setState(() => _isJobFunctionExpanded = !_isJobFunctionExpanded),
      content: Column(
        children: JobConstants.jobFunctions.map((func) {
          return CheckboxListTile(
            value: _selectedJobFunctions.contains(func),
            onChanged: (checked) {
              setState(() {
                if (checked!) {
                  _selectedJobFunctions.add(func);
                } else {
                  _selectedJobFunctions.remove(func);
                }
              });
            },
            title: Text(
              func,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
              ),
            ),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }
}
