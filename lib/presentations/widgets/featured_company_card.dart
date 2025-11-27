import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class FeaturedCompanyCard extends StatelessWidget {
  final String companyName;
  final String category;
  final String logoAsset;
  final String? salaryBadge;
  final bool isFollowing;
  final VoidCallback? onFollowTap;
  final VoidCallback? onTap;

  const FeaturedCompanyCard({
    super.key,
    required this.companyName,
    required this.category,
    required this.logoAsset,
    this.salaryBadge,
    this.isFollowing = false,
    this.onFollowTap,
    this.onTap,
  });

  Color _getBadgeColor(String? badge) {
    if (badge == null) return const Color(0xFF4285F4);
    
    final jobCount = int.tryParse(badge.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    
    if (jobCount >= 200) {
      return const Color(0xFFFF6B00); // Orange for high job count
    } else if (jobCount >= 100) {
      return const Color(0xFF26C281); // Green for medium-high
    } else {
      return const Color(0xFF4285F4); // Blue for normal
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF26C281),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Job Count Badge (if available)
            if (salaryBadge != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getBadgeColor(salaryBadge),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    salaryBadge!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            
            // Company Logo
            Center(
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFF5F5F5),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  logoAsset,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Company Name
            SizedBox(
              height: 36,
              child: Center(
                child: Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 6),
            
            // Category
            Center(
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            
            // Follow Button
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isFollowing 
                    ? null 
                    : const LinearGradient(
                        colors: [Color(0xFF26C281), Color(0xFF1FA76D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                  borderRadius: BorderRadius.circular(8),
                  border: isFollowing 
                    ? Border.all(color: AppColors.borderLight, width: 1.5)
                    : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onFollowTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isFollowing ? Icons.check : Icons.add,
                            size: 13,
                            color: isFollowing ? AppColors.textSecondary : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isFollowing ? AppColors.textSecondary : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
