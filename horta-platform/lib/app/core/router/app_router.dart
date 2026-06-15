import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../modules/auth/_exports.dart';
import '../../modules/nursery/_exports.dart';
import '../../modules/garden/_exports.dart';
import '../../modules/lab/_exports.dart';
import '../../modules/about/_exports.dart';
import '../../modules/admin/_exports.dart';
import '../widgets/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/nursery',
  redirect: (context, state) {
    final authService = GetIt.I<AuthService>();
    final isAuth = authService.isAuthenticated;
    final uriPath = state.uri.path;
    final isAdminOnly = uriPath == '/admin';
    final isPublic = !isAdminOnly;

    if (!isAuth && !isPublic) {
      return '/login?from=${Uri.encodeComponent(uriPath)}';
    }
    if (isAuth && uriPath == '/login') {
      final from = state.uri.queryParameters['from'];
      return (from != null && from.isNotEmpty) ? from : '/nursery';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, state) =>
          LoginPage(from: state.uri.queryParameters['from']),
    ),
    GoRoute(
      path: '/s/:id',
      builder: (_, state) =>
          PublicSurveyPage(surveyId: state.pathParameters['id']!),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/nursery',
          builder: (_, __) => const NurseryScreen(),
        ),
        GoRoute(
          path: '/survey/:id',
          builder: (_, state) =>
              SurveyDetailScreen(surveyId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/garden',
          builder: (_, __) => const GardenScreen(),
        ),
        GoRoute(
          path: '/lab',
          builder: (_, __) => const LabScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (_, state) => AboutPage(section: state.uri.queryParameters['section']),
        ),
        GoRoute(
          path: '/admin',
          builder: (_, __) => const AdminDashboard(),
        ),
      ],
    ),
  ],
);
