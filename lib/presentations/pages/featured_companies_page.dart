import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/presentations/widgets/featured_company_card.dart';
import 'package:flutter_application_1/core/providers/company_provider.dart';
import 'package:flutter_application_1/core/providers/saved_company_provider.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class FeaturedCompaniesPage extends ConsumerStatefulWidget {
  const FeaturedCompaniesPage({super.key});

  @override
  ConsumerState<FeaturedCompaniesPage> createState() => _FeaturedCompaniesPageState();
}

class _FeaturedCompaniesPageState extends ConsumerState<FeaturedCompaniesPage> {
  String selectedCategory = 'Tất cả';
  
  @override
  void initState() {
    super.initState();
    // Load saved companies when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ref.read(savedCompaniesNotifierProvider.notifier).getSavedCompanies(currentUser.userId);
      }
    });
  }
  
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
          
          // Companies Grid with API data
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final companiesAsync = ref.watch(featuredCompaniesProvider);
                
                return companiesAsync.when(
                  data: (companies) {
                    if (companies.isEmpty) {
                      return const Center(
                        child: Text('Không có công ty nào'),
                      );
                    }
                    
                    // Filter by category
                    final filteredCompanies = selectedCategory == 'Tất cả'
                        ? companies
                        : companies.where((c) => c.industry == selectedCategory).toList();
                    
                    if (filteredCompanies.isEmpty) {
                      return const Center(
                        child: Text('Không có công ty nào trong danh mục này'),
                      );
                    }
                    
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final screenWidth = constraints.maxWidth;
                        final crossAxisCount = screenWidth > 600 ? 3 : 2;
                        final childAspectRatio = screenWidth > 600 ? 0.7 : 0.65;
                        
                        return GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: childAspectRatio,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filteredCompanies.length,
                          itemBuilder: (context, index) {
                            final company = filteredCompanies[index];
                            final savedCompanies = ref.watch(savedCompaniesProvider);
                            final isSaved = savedCompanies.any((sc) => sc.company.id == company.id);
                            
                            return FeaturedCompanyCard(
                              companyName: company.name,
                              category: company.industry,
                              logoAsset: company.logo ?? 'assets/logo_lutech.png',
                              salaryBadge: '${company.totalJobs}+ việc',
                              isFollowing: isSaved,
                              onFollowTap: () {
                                final currentUser = ref.read(currentUserProvider);
                                if (currentUser == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Vui lòng đăng nhập để lưu công ty'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }
                                
                                if (isSaved) {
                                  ref.read(savedCompaniesNotifierProvider.notifier).unsaveCompany(
                                    currentUser.userId,
                                    company.id,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đã bỏ theo dõi công ty'),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Color(0xFF6B7280),
                                    ),
                                  );
                                } else {
                                  ref.read(savedCompaniesNotifierProvider.notifier).saveCompany(
                                    currentUser.userId,
                                    company.id,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đã theo dõi công ty'),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Color(0xFF10B981),
                                    ),
                                  );
                                }
                              },
                              onTap: () {
                                context.pushNamed(
                                  'companyDetail',
                                  pathParameters: {'companyId': company.id.toString()},
                                  extra: {
                                    'companyName': company.name,
                                    'category': company.industry,
                                    'logoAsset': company.logo ?? 'assets/logo_lutech.png',
                                    'location': company.location,
                                    'employeeCount': company.employeeCount ?? 0,
                                    'website': company.website ?? '',
                                    'description': company.description,
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Lỗi: $error'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
