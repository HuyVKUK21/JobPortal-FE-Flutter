import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'vi';

  final List<Map<String, String>> _languages = [
    {'code': 'en_us', 'name': 'English (US)', 'nativeName': 'English (US)'},
    {'code': 'en_uk', 'name': 'English (UK)', 'nativeName': 'English (UK)'},
    {'code': 'vi', 'name': 'Tiếng Việt', 'nativeName': 'Tiếng Việt'},
    {'code': 'zh', 'name': 'Mandarin', 'nativeName': '普通话'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'বাংলা'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский'},
    {'code': 'id', 'name': 'Indonesian', 'nativeName': 'Bahasa Indonesia'},
  ];

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
          'Ngôn ngữ',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đề xuất',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildLanguageItem(
                  code: 'en_us',
                  name: 'English (US)',
                  nativeName: 'English (US)',
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Ngôn ngữ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ..._languages.map((lang) => _buildLanguageItem(
                      code: lang['code']!,
                      name: lang['name']!,
                      nativeName: lang['nativeName']!,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem({
    required String code,
    required String name,
    required String nativeName,
  }) {
    final isSelected = _selectedLanguage == code;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã chọn: $nativeName')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                nativeName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
