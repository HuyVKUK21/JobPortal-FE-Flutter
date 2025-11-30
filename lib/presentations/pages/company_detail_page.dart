import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/widgets/widgets.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';

class CompanyDetailPage extends StatelessWidget {
  final String companyName;
  final String category;
  final String logoAsset;
  final String? description;
  final String? location;
  final String? website;
  final int? employeeCount;

  const CompanyDetailPage({
    super.key,
    required this.companyName,
    required this.category,
    required this.logoAsset,
    this.description,
    this.location,
    this.website,
    this.employeeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF8F9FA),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Header with Elegant Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 100, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF667EEA),
                    const Color(0xFF764BA2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Logo
                  AppCard.elevated(
                    padding: const EdgeInsets.all(16),
                    margin: EdgeInsets.zero,
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: Image.asset(
                        logoAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Company Name
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Follow Button
                  AppButton(
                    text: 'Theo dõi công ty',
                    onPressed: () {},
                    icon: Icons.add,
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFF4285F4),
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Statistics Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      Icons.work_outline,
                      '${(employeeCount ?? 1000) ~/ 100}+',
                      'Việc làm',
                      const Color(0xFF4285F4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.people_outline,
                      '${employeeCount ?? 1000}+',
                      'Nhân viên',
                      const Color(0xFF26C281),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.location_on_outlined,
                      '5+',
                      'Chi nhánh',
                      const Color(0xFFFF6B00),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Company Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin công ty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    'Địa điểm',
                    location ?? 'Hà Nội, Việt Nam',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.people_outline,
                    'Quy mô',
                    '${employeeCount ?? 1000}+ nhân viên',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.language,
                    'Website',
                    website ?? 'www.company.com',
                  ),
                  const SizedBox(height: 24),
                  
                  // Benefits Section
                  const Text(
                    'Phúc lợi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppBadge(text: '💰 Lương thưởng hấp dẫn', backgroundColor: const Color(0xFFF0F9FF), textColor: const Color(0xFF0284C7)),
                      AppBadge(text: '🏥 Bảo hiểm sức khỏe', backgroundColor: const Color(0xFFF0FDF4), textColor: const Color(0xFF16A34A)),
                      AppBadge(text: '🏖️ Du lịch hàng năm', backgroundColor: const Color(0xFFFEF3C7), textColor: const Color(0xFFD97706)),
                      AppBadge(text: '📚 Đào tạo & Phát triển', backgroundColor: const Color(0xFFF5F3FF), textColor: const Color(0xFF7C3AED)),
                      AppBadge(text: '🎂 Sinh nhật & Lễ tết', backgroundColor: const Color(0xFFFCE7F3), textColor: const Color(0xFFDB2777)),
                      AppBadge(text: '⚖️ Work-life balance', backgroundColor: const Color(0xFFECFCCB), textColor: const Color(0xFF65A30D)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  const Text(
                    'Giới thiệu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description ?? 
                    'Công ty hàng đầu trong lĩnh vực $category, cung cấp các giải pháp và dịch vụ chất lượng cao cho khách hàng. Chúng tôi luôn tìm kiếm những tài năng xuất sắc để cùng phát triển và xây dựng tương lai tốt đẹp hơn.',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Jobs Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Việc làm đang tuyển',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Xem tất cả',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4285F4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Job Cards
                  CardItemJob(
                    titleJob: 'Senior Backend Developer',
                    conpanyJob: companyName,
                    location: location ?? 'Hà Nội',
                    workLocation: 'Hybrid',
                    workingTime: 'Full Time',
                    workSalary: '30 - 50 triệu /tháng',
                    logoCompany: logoAsset,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  CardItemJob(
                    titleJob: 'UI/UX Designer',
                    conpanyJob: companyName,
                    location: location ?? 'Hà Nội',
                    workLocation: 'Onsite',
                    workingTime: 'Full Time',
                    workSalary: '20 - 35 triệu /tháng',
                    logoCompany: logoAsset,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  CardItemJob(
                    titleJob: 'Product Manager',
                    conpanyJob: companyName,
                    location: location ?? 'Hà Nội',
                    workLocation: 'Hybrid',
                    workingTime: 'Full Time',
                    workSalary: '40 - 60 triệu /tháng',
                    logoCompany: logoAsset,
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  
                  // Related Companies Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Các công ty khác',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Xem tất cả',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4285F4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            
            // Related Companies Horizontal List
            SizedBox(
              height: 240,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildRelatedCompanyCard(
                    'FPT Software',
                    'Công nghệ',
                    'assets/logo_lutech.png',
                    '100+',
                  ),
                  const SizedBox(width: 12),
                  _buildRelatedCompanyCard(
                    'Vietcombank',
                    'Ngân hàng',
                    'assets/logo_google.png',
                    '200+',
                  ),
                  const SizedBox(width: 12),
                  _buildRelatedCompanyCard(
                    'Vingroup',
                    'Tập đoàn',
                    'assets/logo_lutech.png',
                    '500+',
                  ),
                  const SizedBox(width: 12),
                  _buildRelatedCompanyCard(
                    'Masan Group',
                    'Sản xuất',
                    'assets/logo_google.png',
                    '150+',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
    ),
      ),

    );
  }

  Widget _buildRelatedCompanyCard(String name, String category, String logo, String jobs) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              logo,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            category,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$jobs việc làm',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF4285F4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4285F4).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4285F4).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
