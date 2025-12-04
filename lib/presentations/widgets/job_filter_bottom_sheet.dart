import 'dart:ui';
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

class _JobFilterBottomSheetState extends ConsumerState<JobFilterBottomSheet> with SingleTickerProviderStateMixin {
  late JobFilterRequest _filter;
  late AnimationController _animationController;
  
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
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              _buildGlassmorphicHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildJobTypeSection(),
                      const SizedBox(height: 28),
                      _buildWorkLocationSection(),
                      const SizedBox(height: 28),
                      _buildLocationSection(),
                      const SizedBox(height: 28),
                      _buildSalarySection(),
                      const SizedBox(height: 28),
                      _buildExperienceSection(),
                      const SizedBox(height: 28),
                      _buildCompanyNameSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildModernFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphicHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4285F4).withOpacity(0.08),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 48,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 16, 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4285F4), Color(0xFF3367D6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4285F4).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Bộ lọc tìm kiếm',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4285F4).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF4285F4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildJobTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Loại công việc', Icons.work_outline),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: jobTypes.map((type) {
            final isSelected = _filter.jobType == type;
            return _buildModernFilterChip(
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
        _buildSectionHeader('Hình thức làm việc', Icons.location_on_outlined),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: workLocations.map((location) {
            final isSelected = _filter.workLocation == location;
            return _buildModernFilterChip(
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
        _buildSectionHeader('Địa điểm', Icons.place_outlined),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: locations.map((location) {
            final isSelected = _filter.location == location;
            return _buildModernFilterChip(
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
        _buildSectionHeader('Mức lương', Icons.attach_money),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4285F4).withOpacity(0.05),
                const Color(0xFF3367D6).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4285F4).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSalaryLabel('Từ', _minSalary),
                  const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF4285F4),
                    size: 20,
                  ),
                  _buildSalaryLabel('Đến', _maxSalary),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF4285F4),
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  thumbColor: const Color(0xFF4285F4),
                  overlayColor: const Color(0xFF4285F4).withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  trackHeight: 6,
                ),
                child: RangeSlider(
                  values: RangeValues(_minSalary, _maxSalary),
                  min: 0,
                  max: 50000000,
                  divisions: 50,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryLabel(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(value / 1000000).toStringAsFixed(0)}M VNĐ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4285F4),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Kinh nghiệm', Icons.timeline),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(experienceLevels.length, (index) {
            final isSelected = _filter.experienceRequiredId == (index + 1);
            return _buildModernFilterChip(
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
        _buildSectionHeader('Tên công ty', Icons.business_outlined),
        const SizedBox(height: 14),
        TextField(
          decoration: InputDecoration(
            hintText: 'Nhập tên công ty...',
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 15,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF6B7280),
              size: 22,
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF4285F4), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  Widget _buildModernFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF3367D6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4285F4).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Clear Button
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.clear_all, size: 20, color: Color(0xFF6B7280)),
                  SizedBox(width: 8),
                  Text(
                    'Xóa bộ lọc',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Apply Button
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF3367D6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4285F4).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_filter);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Áp dụng',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
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
