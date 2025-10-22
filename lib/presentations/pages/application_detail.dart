import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_screen_layout.dart';
import 'package:flutter_application_1/presentations/widgets/title_header_bar.dart';

class ApplicationDetail extends StatelessWidget {
  const ApplicationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppScreenLayout(
        child: TitleHeaderBar(
          titleHeaderBar: 'Tiến trình ứng tuyển',
          iconHeaderLeftBar: Icons.arrow_back,
          iconHeaderRightBar: Icons.more_horiz_sharp,
        ),
      ),
    );
  }
}
