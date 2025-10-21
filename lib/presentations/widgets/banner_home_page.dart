import 'package:flutter/widgets.dart';

class BannerHomePage extends StatelessWidget {
  const BannerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Image.asset('assets/header_banner_mobile.webp'),
    );
  }
}
