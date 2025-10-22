import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';

class ItemApplicationNotification extends StatelessWidget {
  const ItemApplicationNotification({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final double logoSize = SizeConfig.screenWidth * 0.12;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Flutter Developer',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text('Lutech Digital', style: TextStyle(color: Colors.black54)),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
        SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: logoSize + 12),
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0XFFEEF4FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Mới',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0XFF246BFD),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
