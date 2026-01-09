import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/diary/presentation/pages/diary_page.dart';
import '../../features/fees/presentation/pages/fees_page.dart';
import '../../features/events/presentation/pages/events_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';

/// Application route names
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/';
  static const String diary = '/diary';
  static const String fees = '/fees';
  static const String events = '/events';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
}

/// GoRouter configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RegisterPage(),
        ),
      ),

      // Dashboard Route
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DashboardPage(),
        ),
      ),

      // Diary Route
      GoRoute(
        path: AppRoutes.diary,
        name: 'diary',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DiaryPage(),
        ),
      ),

      // Fees Route
      GoRoute(
        path: AppRoutes.fees,
        name: 'fees',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const FeesPage(),
        ),
      ),

      // Events Route
      GoRoute(
        path: AppRoutes.events,
        name: 'events',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const EventsPage(),
        ),
      ),

      // Profile Route
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ProfilePage(),
        ),
      ),

      // Notifications Route
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const NotificationsPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}
