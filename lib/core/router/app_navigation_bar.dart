import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_application_1/presentations/pages/apply_job_page.dart';
import 'package:flutter_application_1/features/jobs/presentation/pages/home_page.dart';
import 'package:flutter_application_1/features/jobs/presentation/pages/search_jobs_page.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_placeholder_page.dart';
import 'package:flutter_application_1/features/applications/presentation/pages/applications_page.dart';
import 'package:flutter_application_1/features/applications/presentation/pages/application_detail_page.dart';
import 'package:flutter_application_1/core/models/application.dart';
import 'package:flutter_application_1/presentations/pages/detail_job.dart';
import 'package:flutter_application_1/presentations/pages/lastest_job_screen.dart';
import 'package:flutter_application_1/presentations/pages/messages_screen.dart';
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
  static final _shellNavigatorApplicationJob = GlobalKey<NavigatorState>(
    debugLabel: 'shellApplicationJob',
  );
  static final _shellNavigatorMessages = GlobalKey<NavigatorState>(
    debugLabel: 'shellMessages',
  );
  static final _shellNavigatorProfile = GlobalKey<NavigatorState>(
    debugLabel: 'shellProfile',
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
                builder: (context, state) => const HomePage(),
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
          StatefulShellBranch(
            navigatorKey: _shellNavigatorApplicationJob,
            routes: <RouteBase>[
              GoRoute(
                path: '/applications',
                name: 'applications',
                builder: (context, state) => const ApplicationsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMessages,
            routes: <RouteBase>[
              GoRoute(
                path: '/messages',
                name: 'messages',
                builder: (context, state) => const MessagesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) {
                  // TODO: Check auth state with Riverpod
                  // Show placeholder when not authenticated
                  final isAuthenticated = false; // Replace with actual auth check
                  if (!isAuthenticated) {
                    return const ProfilePlaceholderPage();
                  }
                  return const ProfilePage();
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/latestJobs',
        name: 'latestJobs',
        builder: (context, state) => const LastestJobScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/notifications',
        name: 'notification',
        builder: (context, state) => const NotificationPageScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/jobDetail/:jobId',
        name: 'jobDetail',
        builder: (context, state) {
          final jobId = int.parse(state.pathParameters['jobId']!);
          return DetailJob(jobId: jobId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/applyJob/:jobId',
        name: 'applyJob',
        builder: (context, state) {
          final jobId = int.parse(state.pathParameters['jobId']!);
          final jobTitle = state.uri.queryParameters['jobTitle'] ?? 'Việc làm';
          final companyName = state.uri.queryParameters['companyName'] ?? 'Công ty';
          return ApplyJobPage(
            jobId: jobId,
            jobTitle: jobTitle,
            companyName: companyName,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/applicationDetail',
        name: 'applicationDetail',
        builder: (context, state) {
          final application = state.extra as ApplicationResponse;
          return ApplicationDetailPage(application: application);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/searchJobs',
        name: 'searchJobs',
        builder: (context, state) => const SearchJobsPage(),
      ),
    ],
  );
}
