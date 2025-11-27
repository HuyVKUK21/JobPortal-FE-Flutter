import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/widgets/item_application_notification.dart';

class ApplicationNotification extends StatefulWidget {
  const ApplicationNotification({super.key});

  @override
  State<ApplicationNotification> createState() =>
      _ApplicationNotificationState();
}

class _ApplicationNotificationState extends State<ApplicationNotification>
    with AutomaticKeepAliveClientMixin {
  
  // Sample data
  final List<Map<String, dynamic>> sampleNotifications = [
    {
      'title': 'Senior Backend Developer',
      'company': 'VPBank',
      'date': '27 thg 11, 2025 | 10:00',
      'message': 'Đơn ứng tuyển của bạn đã được chấp nhận',
      'isNew': true,
    },
    {
      'title': 'UI/UX Designer',
      'company': 'FPT Software',
      'date': '26 thg 11, 2025 | 14:30',
      'message': 'Đơn ứng tuyển của bạn đang được xem xét',
      'isNew': true,
    },
    {
      'title': 'Frontend Developer',
      'company': 'Techcombank',
      'date': '25 thg 11, 2025 | 09:15',
      'message': 'Đơn ứng tuyển của bạn đã được gửi',
      'isNew': false,
    },
    {
      'title': 'Product Manager',
      'company': 'Viettel',
      'date': '24 thg 11, 2025 | 16:45',
      'message': 'Đơn ứng tuyển của bạn đang được xử lý',
      'isNew': false,
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sampleNotifications.length,
      itemBuilder: (context, index) {
        final notification = sampleNotifications[index];
        return ItemApplicationNotification(
          title: notification['title'] as String,
          company: notification['company'] as String,
          date: notification['date'] as String,
          message: notification['message'] as String,
          isNew: notification['isNew'] as bool,
          onTap: () {
            // TODO: Navigate to detail
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
