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
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView(
      children: [
        ItemApplicationNotification(),
        ItemApplicationNotification(),
        ItemApplicationNotification(),
        ItemApplicationNotification(),
        ItemApplicationNotification(),
        ItemApplicationNotification(),
        ItemApplicationNotification(),
        ItemApplicationNotification(),
        ItemApplicationNotification(),
        ItemApplicationNotification(),
        ItemApplicationNotification(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
