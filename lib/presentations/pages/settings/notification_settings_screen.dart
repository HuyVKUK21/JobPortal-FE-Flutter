import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final Map<String, bool> _notificationSettings = {
    'general': true,
    'sound': true,
    'vibrate': false,
    'job_recommendation': true,
    'job_invitation': true,
    'recruiter_view': false,
    'app_updates': true,
    'new_services': false,
    'new_tips': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSwitchItem(
            title: 'Thông báo chung',
            key: 'general',
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            title: 'Âm thanh',
            key: 'sound',
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            title: 'Rung',
            key: 'vibrate',
          ),
          const SizedBox(height: 24),
          const Text(
            'Thông báo công việc',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            title: 'Thông báo khi có đề xuất công việc',
            key: 'job_recommendation',
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            title: 'Thông báo khi có lời mời ứng tuyển',
            key: 'job_invitation',
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            title: 'Thông báo khi nhà tuyển dụng xem hồ sơ',
            key: 'recruiter_view',
          ),
          const SizedBox(height: 24),
          const Text(
            'Cập nhật ứng dụng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            title: 'Cập nhật ứng dụng',
            key: 'app_updates',
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            title: 'Dịch vụ mới có sẵn',
            key: 'new_services',
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            title: 'Mẹo mới có sẵn',
            key: 'new_tips',
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String key,
  }) {
    final isEnabled = _notificationSettings[key] ?? false;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Switch(
          value: isEnabled,
          onChanged: (value) {
            setState(() {
              _notificationSettings[key] = value;
            });
          },
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
