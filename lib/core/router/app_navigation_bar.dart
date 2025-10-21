import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentations/pages/home_page_screen.dart';
import 'package:flutter_application_1/presentations/pages/lastest_job_screen.dart';
import 'package:flutter_application_1/presentations/pages/notification_page_screen.dart';
import 'package:flutter_application_1/presentations/pages/saved_job_screen.dart';
import 'package:flutter_application_1/presentations/wrapper/main_wrapper.dart';
import 'package:go_router/go_router.dart';

class AppNavigationBar {
  AppNavigationBar._();

  static String initial = '/home';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome = GlobalKey<NavigatorState>(
    debugLabel: 'shellHome',
  );
  static final _shellNavigatorSaveJob = GlobalKey<NavigatorState>(
    debugLabel: 'shellSaveJob',
  );

  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomePageScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSaveJob,
            routes: <RouteBase>[
              GoRoute(
                path: '/saveJobs',
                name: 'saveJobs',
                builder: (context, state) => const SavedJobScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/lastestJob',
        name: 'lastestJob',
        builder: (context, state) => const LastestJobScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/notication',
        name: 'notication',
        builder: (context, state) => const NotificationPageScreen(),
      ),
    ],
  );
}
