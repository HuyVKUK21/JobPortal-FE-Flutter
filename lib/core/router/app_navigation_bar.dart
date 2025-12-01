import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/create_new_password_page.dart';
import 'package:flutter_application_1/presentations/pages/apply_job_page.dart';
import 'package:flutter_application_1/features/jobs/presentation/pages/home_page.dart';
import 'package:flutter_application_1/features/jobs/presentation/pages/search_jobs_page.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/profile_placeholder_page.dart';
import 'package:flutter_application_1/features/applications/presentation/pages/applications_page.dart';
import 'package:flutter_application_1/features/applications/presentation/pages/application_detail_page.dart';
import 'package:flutter_application_1/core/models/application.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/presentations/pages/detail_job.dart';
import 'package:flutter_application_1/presentations/pages/lastest_job_screen.dart';
import 'package:flutter_application_1/presentations/pages/messages_screen.dart';
import 'package:flutter_application_1/presentations/pages/notification_page_screen.dart';
import 'package:flutter_application_1/presentations/pages/saved_items_screen.dart';
import 'package:flutter_application_1/presentations/pages/chat_detail_screen.dart';
import 'package:flutter_application_1/core/models/conversation.dart';
import 'package:flutter_application_1/presentations/wrapper/main_wrapper.dart';
import 'package:flutter_application_1/presentations/pages/settings/deactivate_account_screen.dart';
import 'package:flutter_application_1/presentations/pages/settings/job_seeking_status_screen.dart';
import 'package:flutter_application_1/presentations/pages/settings/linked_accounts_screen.dart';
import 'package:flutter_application_1/presentations/pages/settings/notification_settings_screen.dart';
import 'package:flutter_application_1/presentations/pages/settings/security_settings_screen.dart';
import 'package:flutter_application_1/presentations/pages/settings/language_settings_screen.dart';
import 'package:flutter_application_1/presentations/pages/settings/help_center_screen.dart';
import 'package:flutter_application_1/presentations/pages/company_detail_page.dart';

// Wrapper widget to check auth state
class _ProfileRouteWrapper extends ConsumerWidget {
  const _ProfileRouteWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    if (authState.user == null) {
      return const ProfilePlaceholderPage();
    }
    return const ProfilePage();
  }
}

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
                path: '/savedItems',
                name: 'savedItems',
                builder: (context, state) => const SavedItemsScreen(),
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
                builder: (context, state) => const _ProfileRouteWrapper(),
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
        path: '/companyDetail/:companyId',
        name: 'companyDetail',
        builder: (context, state) {
          final companyId = int.parse(state.pathParameters['companyId']!);
          final extra = state.extra as Map<String, dynamic>?;
          return CompanyDetailPage(
            companyId: companyId,
            companyName: extra?['companyName'] ?? '',
            category: extra?['category'] ?? '',
            logoAsset: extra?['logoAsset'] ?? 'assets/logo_lutech.png',
            location: extra?['location'],
            employeeCount: extra?['employeeCount'],
            website: extra?['website'],
            description: extra?['description'],
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
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/forgotPassword',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/otpVerification',
        name: 'otpVerification',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OTPVerificationPage(extra: extra);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/createNewPassword',
        name: 'createNewPassword',
        builder: (context, state) => const CreateNewPasswordPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/chatDetail',
        name: 'chatDetail',
        builder: (context, state) {
          final conversation = state.extra as Conversation;
          return ChatDetailScreen(conversation: conversation);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/deactivateAccount',
        name: 'deactivateAccount',
        builder: (context, state) => const DeactivateAccountScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/jobSeekingStatus',
        name: 'jobSeekingStatus',
        builder: (context, state) => const JobSeekingStatusScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/personalInformation',
        name: 'personalInformation',
        builder: (context, state) => const ProfileEditPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/linkedAccounts',
        name: 'linkedAccounts',
        builder: (context, state) => const LinkedAccountsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/notificationSettings',
        name: 'notificationSettings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/securitySettings',
        name: 'securitySettings',
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/languageSettings',
        name: 'languageSettings',
        builder: (context, state) => const LanguageSettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/helpCenter',
        name: 'helpCenter',
        builder: (context, state) => const HelpCenterScreen(),
      ),
    ],
  );
}
