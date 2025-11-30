import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/presentations/pages/settings/deactivate_account_screen.dart';
import 'package:flutter_application_1/core/utils/dialog_helpers.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_edit_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: const Color(0xFFF8F9FA),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Cài đặt',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

              // Profile Completion Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4285F4), Color(0xFF3367D6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4285F4).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // User Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Người dùng',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'email@example.com',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Job Seeking Status
              _buildSectionTitle('Trạng thái tìm việc'),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.work_outline,
                title: 'Trạng thái tìm việc',
                onTap: () {
                  context.pushNamed('jobSeekingStatus');
                },
              ),
              const SizedBox(height: 24),

              // Account Section
              _buildSectionTitle('Tài khoản'),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Thông tin cá nhân',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileEditPage(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.link,
                title: 'Tài khoản liên kết',
                onTap: () {
                  context.pushNamed('linkedAccounts');
                },
              ),
              const SizedBox(height: 24),

              // General Section
              _buildSectionTitle('Chung'),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Thông báo',
                onTap: () {
                  context.pushNamed('notificationSettings');
                },
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: 'Vấn đề ứng tuyển',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.access_time,
                title: 'Múi giờ',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.security,
                title: 'Bảo mật',
                onTap: () {
                  context.pushNamed('securitySettings');
                },
              ),
              _buildMenuItem(
                icon: Icons.language,
                title: 'Ngôn ngữ',
                trailing: const Text(
                  'Tiếng Việt',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {
                  context.pushNamed('languageSettings');
                },
              ),
              _buildMenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'Chế độ tối',
                trailing: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: false,
                    onChanged: (value) {},
                    activeColor: const Color(0xFF4285F4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                onTap: null,
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Trung tâm trợ giúp',
                onTap: () {
                  context.pushNamed('helpCenter');
                },
              ),
              _buildMenuItem(
                icon: Icons.person_add_outlined,
                title: 'Mời bạn bè',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.star_outline,
                title: 'Đánh giá ứng dụng',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // About Section
              _buildSectionTitle('Về chúng tôi'),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Chính sách bảo mật',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: 'Điều khoản dịch vụ',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'Giới thiệu',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // Danger Zone
              _buildMenuItem(
                icon: Icons.person_remove_outlined,
                title: 'Vô hiệu hóa tài khoản',
                titleColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  context.pushNamed('deactivateAccount');
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Đăng xuất',
                titleColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  DialogHelpers.showLogoutDialog(context, () {
                    ref.read(authProvider.notifier).logout();
                  });
                },
              ),
              const SizedBox(height: 32),
              // Extra padding for bottom nav bar
              const SizedBox(height: 80),
            ],
          ),

      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? titleColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: iconColor ?? AppColors.textPrimary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? AppColors.textPrimary,
                  ),
                ),
              ),
              if (trailing != null)
                trailing
              else if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
