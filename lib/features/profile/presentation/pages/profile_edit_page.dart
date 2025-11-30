import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/providers/profile_provider.dart';
import 'package:flutter_application_1/core/models/profile.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  bool _isEditMode = false;
  
  // Controllers
  final _portfolioController = TextEditingController();
  final _summaryController = TextEditingController();
  final _addressController = TextEditingController();
  final _currentPositionController = TextEditingController();
  final _salaryMinController = TextEditingController();
  final _salaryMaxController = TextEditingController();
  
  String _salaryFrequency = 'per_month';
  
  @override
  void initState() {
    super.initState();
    // Load profile when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getMyProfile();
    });
  }

  @override
  void dispose() {
    _portfolioController.dispose();
    _summaryController.dispose();
    _addressController.dispose();
    _currentPositionController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    super.dispose();
  }

  void _loadProfileData(ProfileResponse profile) {
    _portfolioController.text = profile.portfolioLink ?? '';
    _summaryController.text = profile.summary ?? '';
    _addressController.text = profile.address ?? '';
    _currentPositionController.text = profile.currentPosition ?? '';
    _salaryMinController.text = profile.expectedSalaryMin?.toString() ?? '';
    _salaryMaxController.text = profile.expectedSalaryMax?.toString() ?? '';
    _salaryFrequency = profile.expectedSalaryFrequency ?? 'per_month';
  }

  Future<void> _saveProfile() async {
    final request = UpdateProfileRequest(
      portfolioLink: _portfolioController.text.trim().isEmpty ? null : _portfolioController.text.trim(),
      summary: _summaryController.text.trim().isEmpty ? null : _summaryController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      currentPosition: _currentPositionController.text.trim().isEmpty ? null : _currentPositionController.text.trim(),
      expectedSalaryMin: int.tryParse(_salaryMinController.text.trim()),
      expectedSalaryMax: int.tryParse(_salaryMaxController.text.trim()),
      expectedSalaryFrequency: _salaryFrequency,
    );

    await ref.read(profileProvider.notifier).updateMyProfile(request);
    
    final error = ref.read(profileErrorProvider);
    if (mounted) {
      if (error == null) {
        setState(() => _isEditMode = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật hồ sơ thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final profile = ref.watch(currentProfileProvider);
    final isLoading = ref.watch(profileLoadingProvider);

    // Load data into controllers when profile is loaded
    if (profile != null && !_isEditMode) {
      _loadProfileData(profile);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Hồ sơ cá nhân',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isEditMode && profile != null)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () => setState(() => _isEditMode = true),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Chưa có thông tin hồ sơ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(profileProvider.notifier).getMyProfile();
                        },
                        child: const Text('Tải lại'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with avatar
                      _buildHeader(currentUser, profile),
                      const SizedBox(height: 24),
                      
                      // Personal Info Section
                      _buildSectionTitle('Thông tin cá nhân'),
                      const SizedBox(height: 12),
                      _buildPersonalInfoSection(profile),
                      
                      const SizedBox(height: 24),
                      
                      // Expected Salary Section
                      _buildSectionTitle('Mức lương mong muốn'),
                      const SizedBox(height: 12),
                      _buildSalarySection(profile),
                      
                      const SizedBox(height: 24),
                      
                      // Education Section (View only for now)
                      _buildSectionTitle('Học vấn'),
                      const SizedBox(height: 12),
                      _buildEducationSection(profile),
                      
                      const SizedBox(height: 24),
                      
                      // Work Experience Section (View only for now)
                      _buildSectionTitle('Kinh nghiệm làm việc'),
                      const SizedBox(height: 12),
                      _buildWorkExperienceSection(profile),
                      
                      const SizedBox(height: 24),
                      
                      // Skills Section (View only for now)
                      _buildSectionTitle('Kỹ năng'),
                      const SizedBox(height: 12),
                      _buildSkillsSection(profile),
                      
                      const SizedBox(height: 32),
                      
                      // Save/Cancel buttons
                      if (_isEditMode) _buildActionButtons(),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(dynamic currentUser, ProfileResponse profile) {
    final initial = currentUser?.firstName.isNotEmpty == true 
        ? currentUser!.firstName[0].toUpperCase()
        : 'U';

    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${profile.firstName} ${profile.lastName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile.currentPosition ?? 'Chưa cập nhật vị trí',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile.email,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPersonalInfoSection(ProfileResponse profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildTextField(
            label: 'Portfolio/Website',
            controller: _portfolioController,
            enabled: _isEditMode,
            hint: 'https://your-portfolio.com',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Vị trí hiện tại',
            controller: _currentPositionController,
            enabled: _isEditMode,
            hint: 'VD: Senior Developer',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Địa chỉ',
            controller: _addressController,
            enabled: _isEditMode,
            hint: 'VD: Quận 1, TP.HCM',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Giới thiệu bản thân',
            controller: _summaryController,
            enabled: _isEditMode,
            hint: 'Viết vài dòng về bản thân...',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildSalarySection(ProfileResponse profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Lương tối thiểu (VNĐ)',
                  controller: _salaryMinController,
                  enabled: _isEditMode,
                  hint: '15000000',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: 'Lương tối đa (VNĐ)',
                  controller: _salaryMaxController,
                  enabled: _isEditMode,
                  hint: '25000000',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          if (_isEditMode) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Chu kỳ: ', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Tháng'),
                  selected: _salaryFrequency == 'per_month',
                  onSelected: (selected) {
                    if (selected) setState(() => _salaryFrequency = 'per_month');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Năm'),
                  selected: _salaryFrequency == 'per_year',
                  onSelected: (selected) {
                    if (selected) setState(() => _salaryFrequency = 'per_year');
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEducationSection(ProfileResponse profile) {
    if (profile.educations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const Text(
          'Chưa có thông tin học vấn',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      children: profile.educations.map((edu) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                edu.institution,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${edu.degree} - ${edu.fieldOfStudy}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${edu.startDate} - ${edu.endDate ?? "Hiện tại"}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWorkExperienceSection(ProfileResponse profile) {
    if (profile.workExperiences.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const Text(
          'Chưa có kinh nghiệm làm việc',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      children: profile.workExperiences.map((exp) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exp.position,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                exp.company,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${exp.startDate} - ${exp.endDate ?? "Hiện tại"}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              if (exp.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  exp.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillsSection(ProfileResponse profile) {
    if (profile.skills.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const Text(
          'Chưa có kỹ năng',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: profile.skills.map((skill) {
        return Chip(
          label: Text(skill.skillName),
          backgroundColor: AppColors.primary.withOpacity(0.1),
          labelStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() => _isEditMode = false);
              // Reload data from profile
              final profile = ref.read(currentProfileProvider);
              if (profile != null) {
                _loadProfileData(profile);
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Hủy',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Lưu',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
