import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';
import 'package:flutter_application_1/core/widgets/build_tag.dart';

class JobDetailInfomationHeader extends StatelessWidget {
  const JobDetailInfomationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final double logoSize = SizeConfig.screenWidth * 0.14;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 246, 243, 243)),
      ),
      child: Padding(
        padding: EdgeInsets.all(4 * SizeConfig.blockWidth),
        child: Column(
          children: [
            Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromARGB(255, 246, 243, 243),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/logo_lutech.png', fit: BoxFit.contain),
            ),
            SizedBox(height: 6),
            Text(
              'Flutter Developer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              'Lutech Digital',
              style: TextStyle(color: const Color(0xFF246BFD)),
            ),
            SizedBox(height: 6),
            Divider(),
            SizedBox(height: 6),
            Text(
              'Toà nhà 18 Lê Lợi, TP. Huế',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
            SizedBox(height: 4),
            Text(
              '40 - 80 triệu /tháng',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                buildTag('Full Time'),
                buildTag('TP. Huế & 2 nơi khác'),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Đăng vào 10 ngày trước, hết hạn 15/10/2025',
              style: TextStyle(
                color: const Color.fromARGB(221, 103, 102, 102),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
