import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/presentations/widgets/item_notification.dart';

class GeneralNotification extends StatefulWidget {
  const GeneralNotification({super.key});

  @override
  State<GeneralNotification> createState() => _GeneralNotificationState();
}

class _GeneralNotificationState extends State<GeneralNotification>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig.init(context);
    return ListView(children: [ItemNotification(), ItemNotification()]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
