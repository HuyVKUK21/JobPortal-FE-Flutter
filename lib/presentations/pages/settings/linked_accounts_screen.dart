import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class LinkedAccountsScreen extends StatefulWidget {
  const LinkedAccountsScreen({super.key});

  @override
  State<LinkedAccountsScreen> createState() => _LinkedAccountsScreenState();
}

class _LinkedAccountsScreenState extends State<LinkedAccountsScreen> {
  final Map<String, bool> _linkedAccounts = {
    'google': true,
    'apple': true,
    'facebook': true,
    'twitter': false,
    'linkedin': false,
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
          'Tài khoản liên kết',
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
          _buildAccountItem(
            name: 'Google',
            key: 'google',
            icon: Icons.g_mobiledata,
            iconColor: const Color(0xFFDB4437),
          ),
          const SizedBox(height: 12),
          _buildAccountItem(
            name: 'Apple',
            key: 'apple',
            icon: Icons.apple,
            iconColor: Colors.black,
          ),
          const SizedBox(height: 12),
          _buildAccountItem(
            name: 'Facebook',
            key: 'facebook',
            icon: Icons.facebook,
            iconColor: const Color(0xFF1877F2),
          ),
          const SizedBox(height: 12),
          _buildAccountItem(
            name: 'Twitter',
            key: 'twitter',
            icon: Icons.close,
            iconColor: Colors.black,
          ),
          const SizedBox(height: 12),
          _buildAccountItem(
            name: 'LinkedIn',
            key: 'linkedin',
            icon: Icons.business,
            iconColor: const Color(0xFF0A66C2),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem({
    required String name,
    required String key,
    required IconData icon,
    required Color iconColor,
  }) {
    final isLinked = _linkedAccounts[key] ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: isLinked,
            onChanged: (value) {
              setState(() {
                _linkedAccounts[key] = value;
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value 
                        ? 'Đã liên kết với $name' 
                        : 'Đã hủy liên kết với $name',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
