import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/core/constants/app_gradients.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/providers/profile_provider.dart';
import 'package:flutter_application_1/core/services/api_service.dart';
import 'package:flutter_application_1/core/models/profile.dart';
import 'package:flutter_application_1/core/models/resume.dart';
import 'package:flutter_application_1/features/profile/presentation/widgets/education_form_dialog.dart';
import 'package:flutter_application_1/features/profile/presentation/widgets/work_experience_form_dialog.dart';
import 'package:flutter_application_1/features/profile/presentation/widgets/skill_selector_dialog.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  bool _isEditingPersonalInfo = false;
  
  // Controllers
  final _portfolioController = TextEditingController();
  final _summaryController = TextEditingController();
  final _addressController = TextEditingController();
  final _currentPositionController = TextEditingController();
  final _salaryMinController = TextEditingController();
  final _salaryMaxController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  final _resumeUrlController = TextEditingController();
  
  String _salaryFrequency = 'per_month';
  bool _isEditingSalary = false;
  String? _selectedCVFileName;
  int? _selectedCVFileSize;
  bool _showAllCVs = false;
  
  // Lists for education, experience, skills, resumes
  List<EducationDTO> _educations = [];
  List<WorkExperienceDTO> _workExperiences = [];
  List<SkillDTO> _skills = [];
  List<Resume> _resumes = [];
  bool _isLoadingResumes = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getMyProfile();
      _fetchResumes();
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
    _avatarUrlController.dispose();
    _resumeUrlController.dispose();
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
    _avatarUrlController.text = profile.avatarUrl ?? '';
    
    // Force rebuild when loading skills
    setState(() {
      _educations = List.from(profile.educations);
      _workExperiences = List.from(profile.workExperiences);
      _skills = List.from(profile.skills);
    });
  }

  Future<void> _saveAllChanges() async {
    final request = UpdateProfileRequest(
      portfolioLink: _portfolioController.text.trim().isEmpty ? null : _portfolioController.text.trim(),
      summary: _summaryController.text.trim().isEmpty ? null : _summaryController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      currentPosition: _currentPositionController.text.trim().isEmpty ? null : _currentPositionController.text.trim(),
      expectedSalaryMin: int.tryParse(_salaryMinController.text.trim()),
      expectedSalaryMax: int.tryParse(_salaryMaxController.text.trim()),
      expectedSalaryFrequency: _salaryFrequency,
      avatarUrl: _avatarUrlController.text.trim().isEmpty ? null : _avatarUrlController.text.trim(),
      educations: _educations.isNotEmpty ? _educations : null,
      workExperiences: _workExperiences.isNotEmpty ? _workExperiences : null,
      skillIds: _skills.isNotEmpty ? _skills.map((s) => s.skillId).toList() : null,
    );

    await ref.read(profileProvider.notifier).updateMyProfile(request);
    
    final error = ref.read(profileErrorProvider);
    if (mounted) {
      if (error == null) {
        setState(() => _isEditingPersonalInfo = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Cập nhật hồ sơ thành công!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✗ Lỗi: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _fetchResumes() async {
    setState(() => _isLoadingResumes = true);
    try {
      final apiService = ref.read(apiServiceProvider);
      final token = apiService.token;
      
      if (token == null) {
        if (kDebugMode) print('No token for CV fetch');
        setState(() => _isLoadingResumes = false);
        return;
      }
      
      // Manual API call with auth header
      final uri = Uri.parse('${ApiConstants.baseUrl}/resumes');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (kDebugMode) {
        print('CV Response Status: ${response.statusCode}');
      }
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final dynamic responseData = jsonResponse['data'];
        
        if (responseData is List) {
          setState(() {
            _resumes = responseData.map((json) => Resume.fromJson(json)).toList();
            _isLoadingResumes = false;
          });
        } else {
          setState(() => _isLoadingResumes = false);
        }
      } else {
        setState(() => _isLoadingResumes = false);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('CV Fetch error: $e');
      }
      setState(() => _isLoadingResumes = false);
    }
  }

  Future<void> _pickCVFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true,
      );
      
      if (result == null || !mounted) return;
      
      final file = result.files.first;
      
     // Display selected file
      setState(() {
        _selectedCVFileName = file.name;
        _selectedCVFileSize = file.size;
      });
      
      if (file.bytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể đọc file. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text('Đang upload ${file.name}...')),
              ],
            ),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 30),
          ),
        );
      }
      
      // Upload to server
      final success = await _uploadCVToBackend(file);
      
      // Hide loading
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        
        if (success) {
          // Clear selected file display
          setState(() {
            _selectedCVFileName = null;
            _selectedCVFileSize = null;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ Upload ${file.name} thành công!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Refresh CV list
          _fetchResumes();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✗ Upload thất bại. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('Upload error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✗ Lỗi: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
  
  Future<bool> _uploadCVToBackend(PlatformFile file) async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final token = apiService.token;
      
      if (token == null) {
        if (kDebugMode) print('No token found');
        return false;
      }
      
      // Create multipart request
      final uri = Uri.parse('${ApiConstants.baseUrl}/resumes/upload');
      final request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      
      // Add file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file.bytes!,
          filename: file.name,
        ),
      );
      
      // Add setAsDefault parameter
      request.fields['setAsDefault'] = 'false';
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (kDebugMode) {
        print('Upload status: ${response.statusCode}');
      }
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) print('Upload error: $e');
      return false;
    }
  }

  Future<void> _pickAvatarImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image == null || !mounted) return;
      
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(child: Text('Đang upload ảnh đại diện...')),
              ],
            ),
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 30),
          ),
        );
      }
      
      // Upload to server
      final avatarUrl = await _uploadImageToBackend(image);
      
      //Hide loading
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        
        if (avatarUrl != null) {
          setState(() {
            _avatarUrlController.text = avatarUrl;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Upload ảnh thành công!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✗ Upload thất bại. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('Image picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }
  }
  
  Future<String?> _uploadImageToBackend(XFile image) async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final token = apiService.token;
      
      if (token == null) {
        if (kDebugMode) print('No token found');
        return null;
      }
      
      // Read image bytes
      final bytes = await image.readAsBytes();
      
      // Use dedicated avatar upload endpoint
      final uri = Uri.parse('${ApiConstants.baseUrl}/job-seekers/avatar');
      final request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      
      // Add file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: image.name,
        ),
      );
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (kDebugMode) {
        print('Avatar upload status: ${response.statusCode}');
        print('Avatar upload response: ${response.body}');
      }
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Response contains full profile with avatarUrl
        final data = jsonResponse['data'];
        if (data != null && data['avatarUrl'] != null) {
          // Return the avatarUrl directly (backend stores as filename only)
          return data['avatarUrl'];
        }
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) print('Image upload error: $e');
      return null;
    }
  }
  
  Future<void> _setDefaultCV(int resumeId) async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final token = apiService.token;
      
      if (token == null) {
        if (kDebugMode) print('No token found');
        return;
      }
      
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(child: Text('Đang cập nhật CV mặc định...')),
              ],
            ),
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 5),
          ),
        );
      }
      
      // API call
      final uri = Uri.parse('${ApiConstants.baseUrl}/resumes/$resumeId/set-default');
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (kDebugMode) {
        print('Set default CV status: ${response.statusCode}');
      }
      
      // Hide loading
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Đã đặt CV làm mặc định!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Refresh CV list
          _fetchResumes();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✗ Không thể cập nhật. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('Set default CV error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✗ Lỗi: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _getSalaryFrequencyText(String frequency) {
    const Map<String, String> frequencyMap = {
      'per_month': '/tháng',
      'per_year': '/năm',
      'per_hour': '/giờ',
      'per_day': '/ngày',
      'per_project': '/dự án',
    };
    return frequencyMap[frequency] ?? '';
  }

  String _formatSalaryDisplay(int? min, int? max, String frequency) {
    if (min == null && max == null) return 'Chưa cập nhật';
    
    String salaryText = '';
    if (min != null && max != null) {
      salaryText = '${(min / 1000000).toStringAsFixed(0)} - ${(max / 1000000).toStringAsFixed(0)} triệu';
    } else if (min != null) {
      salaryText = 'Từ ${(min / 1000000).toStringAsFixed(0)} triệu';
    } else if (max != null) {
      salaryText = 'Lên đến ${(max / 1000000).toStringAsFixed(0)} triệu';
    }
    
    return '$salaryText ${_getSalaryFrequencyText(frequency)}';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final profile = ref.watch(currentProfileProvider);
    final isLoading = ref.watch(profileLoadingProvider);

    if (profile != null && !_isEditingPersonalInfo && _educations.isEmpty) {
      _loadProfileData(profile);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
          if (profile != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _isEditingPersonalInfo || _isEditingSalary
                  ? TextButton.icon(
                      onPressed: _saveAllChanges,
                      icon: const Icon(Icons.save, size: 20),
                      label: const Text('Lưu'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() => _isEditingPersonalInfo = true);
                      },
                      icon: const Icon(Icons.edit, size: 22),
                      color: AppColors.primary,
                      tooltip: 'Chỉnh sửa',
                    ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(currentUser, profile),
                      const SizedBox(height: 24),
                      
                      _buildAvatarSection(profile),
                      const SizedBox(height: 20),
                      
                      _buildCVSection(profile),
                      const SizedBox(height: 20),
                      
                      _buildPersonalInfoSection(profile),
                      const SizedBox(height: 20),
                      
                      _buildSalarySection(profile),
                      const SizedBox(height: 20),
                      
                      _buildEducationSection(),
                      const SizedBox(height: 20),
                      
                      _buildWorkExperienceSection(),
                      const SizedBox(height: 20),
                      
                      _buildSkillsSection(),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Chưa có thông tin hồ sơ',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(profileProvider.notifier).getMyProfile();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Tải lại'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic currentUser, ProfileResponse profile) {
    final initial = currentUser?.firstName.isNotEmpty == true 
        ? currentUser!.firstName[0].toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 3),
              image: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage('${ApiConstants.baseUrl}/uploads/${profile.avatarUrl}'),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                ? Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : null,
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.currentPosition ?? 'Chưa cập nhật vị trí',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(ProfileResponse profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.account_circle, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Ảnh đại diện',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Avatar Preview
              if (_avatarUrlController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('${ApiConstants.baseUrl}/uploads/${_avatarUrlController.text}'),
                      backgroundColor: Colors.grey[200],
                      onBackgroundImageError: (_, __) {},
                    ),
                  ),
                ),
              
              // Image Picker Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isEditingPersonalInfo ? _pickAvatarImage : null,
                  icon: const Icon(Icons.camera_alt, size: 20),
                  label: Text(_avatarUrlController.text.isEmpty ? 'Chọn ảnh đại diện' : 'Thay đổi ảnh'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    disabledForegroundColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCVSection(ProfileResponse profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.description, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'CV / Resume',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: _pickCVFile,
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Upload CV'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Selected CV file display (before upload)
        if (_selectedCVFileName != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.insert_drive_file, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedCVFileName!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_selectedCVFileSize != null)
                        Text(
                          _formatFileSize(_selectedCVFileSize!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    setState(() {
                      _selectedCVFileName = null;
                      _selectedCVFileSize = null;
                    });
                  },
                  color: Colors.grey[700],
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        // List of uploaded CVs
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _isLoadingResumes
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : _resumes.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Chưa có CV nào được upload',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CV đã upload (${_resumes.length})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Sort and display CVs - default first
                        ...() {
                          // Sort: default CV first
                          final sortedResumes = List<Resume>.from(_resumes);
                          sortedResumes.sort((a, b) {
                            if (a.isDefault == true && b.isDefault != true) return -1;
                            if (a.isDefault != true && b.isDefault == true) return 1;
                            return 0;
                          });
                          
                          // Limit to 3 if not showing all
                          final displayResumes = _showAllCVs 
                              ? sortedResumes 
                              : sortedResumes.take(3).toList();
                          
                          return displayResumes.map((resume) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: resume.isDefault == true ? Colors.green[50] : Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: resume.isDefault == true ? Colors.green[300]! : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: resume.isDefault == true ? Colors.green[700] : Colors.grey[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                resume.originalFilename ?? 'CV',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (resume.isDefault == true)
                                              Container(
                                                margin: const EdgeInsets.only(left: 8),
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.green[700],
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  'Mặc định',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                resume.formattedFileSize,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                            // Set as default button for non-default CVs
                                            if (resume.isDefault != true)
                                              TextButton.icon(
                                                onPressed: () => _setDefaultCV(resume.resumeId!),
                                                icon: Icon(Icons.star_border, size: 14, color: Colors.grey[700]),
                                                label: Text(
                                                  'Đặt mặc định',
                                                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                                                ),
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  minimumSize: Size.zero,
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        }(),
                        
                        // Show more button if > 3 CVs
                        if (_resumes.length > 3) ...[
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showAllCVs = !_showAllCVs;
                                });
                              },
                              icon: Icon(
                                _showAllCVs ? Icons.expand_less : Icons.expand_more,
                                size: 18,
                              ),
                              label: Text(_showAllCVs ? 'Thu gọn' : 'Xem thêm ${_resumes.length - 3} CV'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
        ),
      ],
    );
  }
  
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAdd, IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (onAdd != null)
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Thêm'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(ProfileResponse profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isEditingPersonalInfo ? Icons.close : Icons.edit,
                color: AppColors.primary,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isEditingPersonalInfo = !_isEditingPersonalInfo;
                  if (!_isEditingPersonalInfo) {
                    _loadProfileData(profile);
                  }
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTextField(
                label: 'Portfolio/Website',
                controller: _portfolioController,
                enabled: _isEditingPersonalInfo,
                hint: 'https://your-portfolio.com',
                icon: Icons.link,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Vị trí hiện tại',
                controller: _currentPositionController,
                enabled: _isEditingPersonalInfo,
                hint: 'VD: Senior Developer',
                icon: Icons.work,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Địa chỉ',
                controller: _addressController,
                enabled: _isEditingPersonalInfo,
                hint: 'VD: Quận 1, TP.HCM',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Giới thiệu bản thân',
                controller: _summaryController,
                enabled: _isEditingPersonalInfo,
                hint: 'Viết vài dòng về bản thân...',
                maxLines: 4,
                icon: Icons.description,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalarySection(ProfileResponse profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.attach_money, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Mức lương mong muốn',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Edit button for salary
            if (!_isEditingSalary && !_isEditingPersonalInfo)
              IconButton(
                onPressed: () {
                  setState(() {
                    _isEditingSalary = true;
                    // Load current values into controllers
                    if (profile.expectedSalaryMin != null) {
                      _salaryMinController.text = profile.expectedSalaryMin.toString();
                    }
                    if (profile.expectedSalaryMax != null) {
                      _salaryMaxController.text = profile.expectedSalaryMax.toString();
                    }
                    _salaryFrequency = profile.expectedSalaryFrequency ?? 'per_month';
                  });
                },
                icon: const Icon(Icons.edit, size: 18),
                color: AppColors.primary,
                tooltip: 'Chỉnh sửa',
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Read-only view
              if (!_isEditingSalary && !_isEditingPersonalInfo) ...[
                Row(
                  children: [
                    const Icon(Icons.payments, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatSalaryDisplay(
                          profile.expectedSalaryMin,
                          profile.expectedSalaryMax,
                          profile.expectedSalaryFrequency ?? 'per_month',
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ]
              // Edit mode
              else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      label: 'Lương tối thiểu (VNĐ)',
                      controller: _salaryMinController,
                      enabled: true,
                      hint: '15000000',
                      keyboardType: TextInputType.number,
                      icon: Icons.money_off,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Lương tối đa (VNĐ)',
                      controller: _salaryMaxController,
                      enabled: true,
                      hint: '25000000',
                      keyboardType: TextInputType.number,
                      icon: Icons.attach_money,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Chu kỳ:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFrequencyChip('Tháng', 'per_month'),
                        _buildFrequencyChip('Năm', 'per_year'),
                        _buildFrequencyChip('Giờ', 'per_hour'),
                        _buildFrequencyChip('Ngày', 'per_day'),
                        _buildFrequencyChip('Dự án', 'per_project'),
                      ],
                    ),
                    
                    // Save/Cancel buttons for salary edit mode
                    if (_isEditingSalary) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditingSalary = false;
                                _salaryMinController.clear();
                                _salaryMaxController.clear();
                              });
                            },
                            child: const Text('Hủy'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _saveAllChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Lưu'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyChip(String label, String value) {
    final isSelected = _salaryFrequency == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _salaryFrequency = value);
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Học vấn',
          icon: Icons.school,
          onAdd: () async {
            final result = await showDialog<EducationDTO>(
              context: context,
              builder: (context) => const EducationFormDialog(),
            );
            if (result != null) {
              setState(() {
                _educations.add(result);
              });
            }
          },
        ),
        const SizedBox(height: 12),
        if (_educations.isEmpty)
          _buildEmptyCard('Chưa có thông tin học vấn', Icons.school_outlined)
        else
          ..._educations.asMap().entries.map((entry) {
            final index = entry.key;
            final edu = entry.value;
            return _buildEducationCard(edu, index);
          }).toList(),
      ],
    );
  }

  Widget _buildEducationCard(EducationDTO edu, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edu.institution,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${edu.degree} - ${edu.fieldOfStudy}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
                onPressed: () async {
                  final result = await showDialog<EducationDTO>(
                    context: context,
                    builder: (context) => EducationFormDialog(education: edu),
                  );
                  if (result != null) {
                    setState(() {
                      _educations[index] = result;
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _educations.removeAt(index);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                _formatDateDisplay(edu.startDate, edu.endDate),
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Kinh nghiệm làm việc',
          icon: Icons.work,
          onAdd: () async {
            final result = await showDialog<WorkExperienceDTO>(
              context: context,
              builder: (context) => const WorkExperienceFormDialog(),
            );
            if (result != null) {
              setState(() {
                _workExperiences.add(result);
              });
            }
          },
        ),
        const SizedBox(height: 12),
        if (_workExperiences.isEmpty)
          _buildEmptyCard('Chưa có kinh nghiệm làm việc', Icons.work_outline)
        else
          ..._workExperiences.asMap().entries.map((entry) {
            final index = entry.key;
            final exp = entry.value;
            return _buildWorkExperienceCard(exp, index);
          }).toList(),
      ],
    );
  }

  Widget _buildWorkExperienceCard(WorkExperienceDTO exp, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp.position,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      exp.company,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
                onPressed: () async {
                  final result = await showDialog<WorkExperienceDTO>(
                    context: context,
                    builder: (context) => WorkExperienceFormDialog(experience: exp),
                  );
                  if (result != null) {
                    setState(() {
                      _workExperiences[index] = result;
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _workExperiences.removeAt(index);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                _formatDateDisplay(exp.startDate, exp.endDate),
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
          if (exp.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              exp.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Kỹ năng',
          icon: Icons.stars,
          onAdd: () async {
            final mockSkills = _generateMockSkills();
            
            final result = await showDialog<List<int>>(
              context: context,
              builder: (context) => SkillSelectorDialog(
                currentSkills: _skills,
                availableSkills: mockSkills,
              ),
            );
            
            if (result != null) {
              setState(() {
                _skills = mockSkills.where((s) => result.contains(s.skillId)).toList();
              });
            }
          },
        ),
        const SizedBox(height: 12),
        if (_skills.isEmpty)
          _buildEmptyCard('Chưa có kỹ năng', Icons.auto_awesome)
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _skills.map((skill) {
                return Container(
                  constraints: const BoxConstraints(minHeight: 38),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        AppColors.primary.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 40),
                        child: Text(
                          skill.skillName,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyCard(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
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
            fillColor: enabled ? Colors.white : Colors.grey[50],
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: maxLines > 1 ? 12 : 14,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateDisplay(String start, String? end) {
    try {
      final startDate = DateFormat('yyyy-MM-dd').parse(start);
      final startStr = DateFormat('MM/yyyy').format(startDate);
      
      if (end == null) {
        return '$startStr - Hiện tại';
      }
      
      final endDate = DateFormat('yyyy-MM-dd').parse(end);
      final endStr = DateFormat('MM/yyyy').format(endDate);
      return '$startStr - $endStr';
    } catch (e) {
      return 'Invalid date';
    }
  }

  List<SkillDTO> _generateMockSkills() {
    return [
      SkillDTO(skillId: 1, skillName: 'Java'),
      SkillDTO(skillId: 2, skillName: 'Spring Boot'),
      SkillDTO(skillId: 3, skillName: 'ReactJS'),
      SkillDTO(skillId: 4, skillName: 'Flutter'),
      SkillDTO(skillId: 5, skillName: 'Docker'),
      SkillDTO(skillId: 6, skillName: 'Kubernetes'),
      SkillDTO(skillId: 7, skillName: 'PostgreSQL'),
      SkillDTO(skillId: 8, skillName: 'MongoDB'),
      SkillDTO(skillId: 9, skillName: 'Redis'),
      SkillDTO(skillId: 10, skillName: 'AWS'),
      SkillDTO(skillId: 11, skillName: 'Python'),
      SkillDTO(skillId: 12, skillName: 'Node.js'),
      SkillDTO(skillId: 13, skillName: 'TypeScript'),
      SkillDTO(skillId: 14, skillName: 'Git'),
      SkillDTO(skillId: 15, skillName: 'CI/CD'),
    ];
  }
}
