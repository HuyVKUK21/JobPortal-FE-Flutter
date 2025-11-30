import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/presentations/widgets/featured_company_card.dart';
import 'package:flutter_application_1/presentations/pages/company_detail_page.dart';

class FeaturedCompaniesPage extends StatefulWidget {
  const FeaturedCompaniesPage({super.key});

  @override
  State<FeaturedCompaniesPage> createState() => _FeaturedCompaniesPageState();
}

class _FeaturedCompaniesPageState extends State<FeaturedCompaniesPage> {
  String selectedCategory = 'Tất cả';
  
  final List<String> categories = [
    'Tất cả',
    'Ngân hàng',
    'Công nghệ',
    'Sản xuất',
    'Viễn thông',
    'Bất động sản',
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
          'Thương hiệu lớn tiêu biểu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF4285F4),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF4285F4) : AppColors.borderLight,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const Divider(height: 1),
          
          // Companies Grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate responsive grid parameters
                final screenWidth = constraints.maxWidth;
                final crossAxisCount = screenWidth > 600 ? 3 : 2;
                // Use fixed aspect ratio that works well for the card design
                final childAspectRatio = screenWidth > 600 ? 0.7 : 0.65;
                
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return _buildCompanyGridCard(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyGridCard(int index) {
    final companies = [
      {
        'name': 'Ngân Hàng TMCP Việt Nam Thịnh Vượng',
        'category': 'Ngân hàng',
        'logo': 'assets/logo_lutech.png',
        'jobs': '120+',
        'location': 'Hà Nội',
        'employees': 5000,
      },
      {
        'name': 'NGÂN HÀNG KỸ THƯƠNG VIỆT NAM',
        'category': 'Ngân hàng',
        'logo': 'assets/logo_google.png',
        'jobs': '150+',
        'location': 'TP. HCM',
        'employees': 8000,
      },
      {
        'name': 'CÔNG TY TẬP ĐOÀN TRƯỜNG HẢI',
        'category': 'Sản xuất',
        'logo': 'assets/logo_lutech.png',
        'jobs': '80+',
        'location': 'Quảng Nam',
        'employees': 15000,
      },
      {
        'name': 'TẬP ĐOÀN VIỄN THÔNG QUÂN ĐỘI',
        'category': 'Viễn thông',
        'logo': 'assets/logo_google.png',
        'jobs': '200+',
        'location': 'Hà Nội',
        'employees': 20000,
      },
      {
        'name': 'FPT Software',
        'category': 'Công nghệ',
        'logo': 'assets/logo_lutech.png',
        'jobs': '180+',
        'location': 'Hà Nội',
        'employees': 10000,
      },
      {
        'name': 'Vietcombank',
        'category': 'Ngân hàng',
        'logo': 'assets/logo_google.png',
        'jobs': '130+',
        'location': 'Hà Nội',
        'employees': 12000,
      },
      {
        'name': 'Vingroup',
        'category': 'Bất động sản',
        'logo': 'assets/logo_lutech.png',
        'jobs': '250+',
        'location': 'Hà Nội',
        'employees': 50000,
      },
      {
        'name': 'Masan Group',
        'category': 'Sản xuất',
        'logo': 'assets/logo_google.png',
        'jobs': '90+',
        'location': 'TP. HCM',
        'employees': 8000,
      },
      {
        'name': 'Samsung Vietnam',
        'category': 'Công nghệ',
        'logo': 'assets/logo_lutech.png',
        'jobs': '300+',
        'location': 'Bắc Ninh',
        'employees': 60000,
      },
      {
        'name': 'Grab Vietnam',
        'category': 'Công nghệ',
        'logo': 'assets/logo_google.png',
        'jobs': '60+',
        'location': 'TP. HCM',
        'employees': 2000,
      },
      {
        'name': 'Shopee Vietnam',
        'category': 'Công nghệ',
        'logo': 'assets/logo_lutech.png',
        'jobs': '110+',
        'location': 'TP. HCM',
        'employees': 3000,
      },
      {
        'name': 'Tiki Corporation',
        'category': 'Công nghệ',
        'logo': 'assets/logo_google.png',
        'jobs': '50+',
        'location': 'TP. HCM',
        'employees': 1500,
      },
    ];

    final company = companies[index % companies.length];
    
    return FeaturedCompanyCard(
      companyName: company['name'] as String,
      category: company['category'] as String,
      logoAsset: company['logo'] as String,
      salaryBadge: '${company['jobs']} việc',
      isFollowing: index % 4 == 0,
      onFollowTap: () {},
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailPage(
              companyName: company['name'] as String,
              category: company['category'] as String,
              logoAsset: company['logo'] as String,
              location: company['location'] as String,
              employeeCount: company['employees'] as int,
            ),
          ),
        );
      },
    );
  }
}
