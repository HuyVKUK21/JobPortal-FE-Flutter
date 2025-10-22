import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';

class ItemGeneralNotification extends StatelessWidget {
  const ItemGeneralNotification({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final double logoSize = SizeConfig.screenWidth * 0.12;
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEAF1FF),
              ),
              child: Icon(
                Icons.verified_user,
                color: Color(0xFF3B82F6),
                size: SizeConfig.blockWidth * 6,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Mật khẩu đã thay đổi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 4),
                Text('20 thg 8, 2025 | 20:01', style: TextStyle(fontSize: 12)),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 97, 232),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Mới',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Hệ thống ghi nhận bạn đã thay đổi mật khẩu. Nếu không phải là bạn vui lòng liên hệ Trung tâm hỗ trợ để khoá tài khoản!',
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
