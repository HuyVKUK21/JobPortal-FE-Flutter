import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/job.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class JobFilterBottomSheet extends ConsumerStatefulWidget {
  final JobFilterRequest initialFilter;
  final Function(JobFilterRequest) onApply;

  const JobFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  ConsumerState<JobFilterBottomSheet> createState() => _JobFilterBottomSheetState();
}

class _JobFilterBottomSheetState extends ConsumerState<JobFilterBottomSheet> {
  late JobFilterRequest _filter;
  
  // Filter options
  final List<String> jobTypes = ['full-time', 'part-time', 'freelance', 'contract'];
  final List<String> workLocations = ['remote', 'office', 'hybrid'];
  final List<String> locations = ['Hà Nội', 'TP. Hồ Chí Minh', 'Đà Nẵng', 'Cần Thơ', 'Hải Phòng'];
  final List<String> experienceLevels = ['Entry Level', 'Mid Level', 'Senior Level', 'Manager'];
  
  double _minSalary = 0;
  double _maxSalary = 50000000;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    if (_filter.salaryMin != null) _minSalary = _filter.salaryMin!;
    if (_filter.salaryMax != null) _maxSalary = _filter.salaryMax!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          const Divider(height: 1),
          
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildJobTypeSection(),
                  const SizedBox(height: 24),
                  _buildWorkLocationSection(),
                  const SizedBox(height: 24),
                  _buildLocationSection(),
                  const SizedBox(height: 24),
                  _buildSalarySection(),
                  const SizedBox(height: 24),
                  _buildExperienceSection(),
                  const SizedBox(height: 24),
                  _buildCompanyNameSection(),
                ],
              ),
            ),
          ),
          
          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Text(
            'Bộ lọc tìm kiếm',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildJobTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Loại công việc'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: jobTypes.map((type) {
            final isSelected = _filter.jobType == type;
            return _buildFilterChip(
              label: _formatJobType(type),
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _filter = _filter.copyWith(
                    jobType: isSelected ? null : type,
                  );
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWorkLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Hình thức làm việc'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: workLocations.map((location) {
            final isSelected = _filter.workLocation == location;
            return _buildFilterChip(
              label: _formatWorkLocation(location),
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _filter = _filter.copyWith(
                    workLocation: isSelected ? null : location,
                  );
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Địa điểm'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: locations.map((location) {
            final isSelected = _filter.location == location;
            return _buildFilterChip(
              label: location,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _filter = _filter.copyWith(
                    location: isSelected ? null : location,
                  );
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSalarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Mức lương (VNĐ)'),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '${(_minSalary / 1000000).toStringAsFixed(0)}M',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4285F4),
              ),
            ),
            const Spacer(),
            Text(
              '${(_maxSalary / 1000000).toStringAsFixed(0)}M',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4285F4),
              ),
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(_minSalary, _maxSalary),
          min: 0,
          max: 50000000,
          divisions: 50,
          activeColor: const Color(0xFF4285F4),
          inactiveColor: const Color(0xFFE5E7EB),
          onChanged: (RangeValues values) {
            setState(() {
              _minSalary = values.start;
              _maxSalary = values.end;
              _filter = _filter.copyWith(
                salaryMin: _minSalary > 0 ? _minSalary : null,
                salaryMax: _maxSalary < 50000000 ? _maxSalary : null,
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Kinh nghiệm'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(experienceLevels.length, (index) {
            final isSelected = _filter.experienceRequiredId == (index + 1);
            return _buildFilterChip(
              label: experienceLevels[index],
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _filter = _filter.copyWith(
                    experienceRequiredId: isSelected ? null : (index + 1),
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCompanyNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Tên công ty'),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Nhập tên công ty...',
            prefixIcon: const Icon(Icons.business, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4285F4), width: 2),
            ),
          ),
          onChanged: (value) {
            _filter = _filter.copyWith(
              companyName: value.isEmpty ? null : value,
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF3367D6)],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _filter = _filter.clearFilters();
                  _minSalary = 0;
                  _maxSalary = 50000000;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Xóa bộ lọc',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_filter);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF4285F4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Áp dụng',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatJobType(String type) {
    switch (type) {
      case 'full-time':
        return 'Toàn thời gian';
      case 'part-time':
        return 'Bán thời gian';
      case 'freelance':
        return 'Freelance';
      case 'contract':
        return 'Hợp đồng';
      default:
        return type;
    }
  }

  String _formatWorkLocation(String location) {
    switch (location) {
      case 'remote':
        return 'Từ xa';
      case 'office':
        return 'Tại văn phòng';
      case 'hybrid':
        return 'Kết hợp';
      default:
        return location;
    }
  }
}
