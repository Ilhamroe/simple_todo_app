import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_todo_app/pages/assign_todo_page.dart';
import 'package:simple_todo_app/pages/home_page.dart';
import 'package:simple_todo_app/pages/setting_page.dart';
import 'package:simple_todo_app/pages/splash_screen.dart';
import 'package:simple_todo_app/pages/starting_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'startingpage',
          builder: (BuildContext context, GoRouterState state) {
            return const StartingPage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/homepage',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const SettingPage();
      },
    ),
    GoRoute(
      path: '/assigntodo',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic>? data = state.extra as Map<String, dynamic>?;
        return AssignTodoPage(
          todo: data?['todo'],
          isEdit: data?['isEdit'] ?? false,
        );
      },
    ),
  ],
);
