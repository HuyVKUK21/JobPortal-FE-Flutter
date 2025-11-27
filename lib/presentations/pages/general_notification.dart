import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/widgets/item_general_notification.dart';

class GeneralNotification extends StatefulWidget {
  const GeneralNotification({super.key});

  @override
  State<GeneralNotification> createState() => _GeneralNotificationState();
}

class _GeneralNotificationState extends State<GeneralNotification>
    with AutomaticKeepAliveClientMixin {
  
  // Sample data
  final List<Map<String, dynamic>> sampleNotifications = [
    {
      'title': 'Chào mừng bạn đến với JobPortal',
      'message': 'Tài khoản của bạn đã được tạo thành công. Bắt đầu ứng tuyển công việc ngay bây giờ!',
      'date': '27 thg 11, 2025 | 10:00',
      'isNew': true,
    },
    {
      'title': 'Cập nhật hồ sơ',
      'message': 'Hãy hoàn thiện hồ sơ của bạn để tăng cơ hội được tuyển dụng',
      'date': '26 thg 11, 2025 | 14:30',
      'isNew': true,
    },
    {
      'title': 'Việc làm mới phù hợp với bạn',
      'message': 'Có 15 việc làm mới phù hợp với hồ sơ của bạn. Xem ngay!',
      'date': '25 thg 11, 2025 | 09:15',
      'isNew': false,
    },
    {
      'title': 'Bảo trì hệ thống',
      'message': 'Hệ thống sẽ bảo trì vào 28/11/2025 từ 2:00 - 4:00 sáng',
      'date': '24 thg 11, 2025 | 16:45',
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
        return ItemGeneralNotification(
          title: notification['title'] as String,
          message: notification['message'] as String,
          date: notification['date'] as String,
          isNew: notification['isNew'] as bool,
          onTap: () {
            // TODO: Handle notification tap
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
