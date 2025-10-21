import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/size_config.dart';

class AppScreenLayout extends StatelessWidget {
  final Widget child;
  final bool scrollable;

  const AppScreenLayout({
    super.key,
    required this.child,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    // final padding = EdgeInsets.all(6 * SizeConfig.blockWidth);
    final padding = EdgeInsets.only(
      top: 6 * SizeConfig.blockWidth,
      left: 6 * SizeConfig.blockWidth,
      right: 6 * SizeConfig.blockWidth,
    );
    Widget content = Padding(padding: padding, child: child);
    if (scrollable) content = SingleChildScrollView(child: content);

    return SafeArea(child: content);
  }
}
