import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/presentations/widgets/item_application_notification.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';
import 'package:flutter_application_1/presentations/pages/application_detail.dart';

class ApplicationScreen extends ConsumerWidget {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sample data - sau này sẽ thay bằng API
    final sampleApplications = [
      {
        'title': 'Senior Backend Developer',
        'company': 'VPBank',
        'date': '27 thg 11, 2025 | 10:00',
        'message': 'Đơn ứng tuyển của bạn đã được chấp nhận',
        'isNew': true,
        'status': 'accepted',
      },
      {
        'title': 'UI/UX Designer',
        'company': 'FPT Software',
        'date': '26 thg 11, 2025 | 14:30',
        'message': 'Đơn ứng tuyển của bạn đang được xem xét',
        'isNew': true,
        'status': 'reviewing',
      },
      {
        'title': 'Frontend Developer',
        'company': 'Techcombank',
        'date': '25 thg 11, 2025 | 09:15',
        'message': 'Đơn ứng tuyển của bạn đã được gửi',
        'isNew': false,
        'status': 'pending',
      },
      {
        'title': 'Product Manager',
        'company': 'Viettel',
        'date': '24 thg 11, 2025 | 16:45',
        'message': 'Đơn ứng tuyển của bạn đang được xử lý',
        'isNew': false,
        'status': 'pending',
      },
      {
        'title': 'Mobile Developer',
        'company': 'Vingroup',
        'date': '23 thg 11, 2025 | 11:20',
        'message': 'Đơn ứng tuyển của bạn đã được nhận',
        'isNew': false,
        'status': 'pending',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: Column(
          children: [
            TitleHeaderBar(
              titleHeaderBar: 'Ứng tuyển',
              iconHeaderLeftBar: Icons.account_circle,
              iconHeaderRightBar: Icons.more_horiz_sharp,
            ),
            const SizedBox(height: 16),
            
            // List of applications
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: sampleApplications.length,
                itemBuilder: (context, index) {
                  final app = sampleApplications[index];
                  return ItemApplicationNotification(
                    title: app['title'] as String,
                    company: app['company'] as String,
                    date: app['date'] as String,
                    message: app['message'] as String,
                    isNew: app['isNew'] as bool,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplicationDetail(
                            jobTitle: app['title'] as String,
                            companyName: app['company'] as String,
                            companyLogo: 'assets/logo_lutech.png',
                            location: 'Hà Nội',
                            salary: '20 - 40 triệu /tháng',
                            applicationStatus: app['status'] as String,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
