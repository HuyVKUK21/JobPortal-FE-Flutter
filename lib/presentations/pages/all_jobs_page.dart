import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/presentations/widgets/card_item_job.dart';

class AllJobsPage extends StatefulWidget {
  final String title;
  
  const AllJobsPage({
    super.key,
    this.title = 'Tất cả việc làm',
  });

  @override
  State<AllJobsPage> createState() => _AllJobsPageState();
}

class _AllJobsPageState extends State<AllJobsPage> {
  String selectedCategory = 'Tất cả';
  
  final List<String> categories = [
    'Tất cả',
    'Công nghệ',
    'Thiết kế',
    'Marketing',
    'Kinh doanh',
    'Tài chính',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
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
          
          const SizedBox(height: 8),
          
          // Jobs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildJobCard(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(int index) {
    final jobs = [
      {
        'title': 'Senior Backend Developer',
        'company': 'VPBank',
        'location': 'Hà Nội',
        'workLocation': 'Hybrid',
        'workingTime': 'Full Time',
        'salary': '30 - 50 triệu /tháng',
        'logo': 'assets/logo_lutech.png',
        'tags': ['Remote', 'Finance'],
      },
      {
        'title': 'UI/UX Designer',
        'company': 'FPT Software',
        'location': 'TP. HCM',
        'workLocation': 'Onsite',
        'workingTime': 'Full Time',
        'salary': '20 - 35 triệu /tháng',
        'logo': 'assets/logo_google.png',
        'tags': ['Design', 'Remote'],
      },
      {
        'title': 'Product Manager',
        'company': 'Viettel',
        'location': 'Hà Nội',
        'workLocation': 'Hybrid',
        'workingTime': 'Full Time',
        'salary': '40 - 60 triệu /tháng',
        'logo': 'assets/logo_lutech.png',
        'tags': ['Part-time', 'Finance'],
      },
      {
        'title': 'Frontend Developer',
        'company': 'Techcombank',
        'location': 'Hà Nội',
        'workLocation': 'Remote',
        'workingTime': 'Full Time',
        'salary': '25 - 45 triệu /tháng',
        'logo': 'assets/logo_google.png',
        'tags': ['Full Time', 'Remote'],
      },
      {
        'title': 'Data Analyst',
        'company': 'Vingroup',
        'location': 'TP. HCM',
        'workLocation': 'Onsite',
        'workingTime': 'Full Time',
        'salary': '18 - 30 triệu /tháng',
        'logo': 'assets/logo_lutech.png',
        'tags': ['Finance'],
      },
      {
        'title': 'Marketing Manager',
        'company': 'Grab Vietnam',
        'location': 'Hà Nội',
        'workLocation': 'Hybrid',
        'workingTime': 'Full Time',
        'salary': '35 - 55 triệu /tháng',
        'logo': 'assets/logo_google.png',
        'tags': ['Remote'],
      },
      {
        'title': 'Business Analyst',
        'company': 'Shopee Vietnam',
        'location': 'TP. HCM',
        'workLocation': 'Onsite',
        'workingTime': 'Full Time',
        'salary': '22 - 38 triệu /tháng',
        'logo': 'assets/logo_lutech.png',
        'tags': ['Finance', 'Remote'],
      },
      {
        'title': 'DevOps Engineer',
        'company': 'FPT Software',
        'location': 'Đà Nẵng',
        'workLocation': 'Hybrid',
        'workingTime': 'Full Time',
        'salary': '28 - 48 triệu /tháng',
        'logo': 'assets/logo_google.png',
        'tags': ['Full Time'],
      },
      {
        'title': 'Mobile Developer',
        'company': 'Tiki Corporation',
        'location': 'Hà Nội',
        'workLocation': 'Remote',
        'workingTime': 'Full Time',
        'salary': '26 - 42 triệu /tháng',
        'logo': 'assets/logo_lutech.png',
        'tags': ['Remote'],
      },
      {
        'title': 'QA Engineer',
        'company': 'Vietcombank',
        'location': 'Hà Nội',
        'workLocation': 'Onsite',
        'workingTime': 'Full Time',
        'salary': '15 - 25 triệu /tháng',
        'logo': 'assets/logo_google.png',
        'tags': ['Finance'],
      },
    ];

    final job = jobs[index % jobs.length];
    
    return CardItemJob(
      titleJob: job['title'] as String,
      conpanyJob: job['company'] as String,
      location: job['location'] as String,
      workLocation: job['workLocation'] as String,
      workingTime: job['workingTime'] as String,
      workSalary: job['salary'] as String,
      logoCompany: job['logo'] as String,
      onTap: () {},
    );
  }
}
