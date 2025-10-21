import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/app_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'SF Pro',
      ),
      routerConfig: AppNavigationBar.router,
    );
  }
}
