import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/router/app_navigation_bar.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize auth state when app starts
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(authProvider.notifier).initializeAuth();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Job Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'SF Pro',
      ),
      routerConfig: AppNavigationBar.router,
    );
  }
}
