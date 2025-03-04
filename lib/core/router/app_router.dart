import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/features/home/views/home_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/features/auth/views/login_view.dart';
import 'package:flutterflare/features/auth/views/register_view.dart';
import 'package:flutterflare/features/auth/views/forgot_password_view.dart';
import 'package:flutterflare/features/welcome/views/welcome_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: WelcomeView.routePath,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // If the auth state is loading, show a loading screen
      if (authState.isLoading) {
        return null;
      }

      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute =
          state.matchedLocation == LoginView.routePath ||
          state.matchedLocation == RegisterView.routePath ||
          state.matchedLocation == ForgotPasswordView.routePath;
      final isWelcomeRoute = state.matchedLocation == WelcomeView.routePath;

      // If not logged in and not on an auth route or welcome route, redirect to welcome
      if (!isLoggedIn && !isAuthRoute && !isWelcomeRoute) {
        return WelcomeView.routePath;
      }

      // If logged in and on an auth route or welcome route, redirect to home
      if (isLoggedIn && (isAuthRoute || isWelcomeRoute)) {
        return HomeView.routePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: WelcomeView.routePath,
        name: WelcomeView.routePath,
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: HomeView.routePath,
        name: HomeView.routePath,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: LoginView.routePath,
        name: LoginView.routePath,
        builder: (context, state) {
          final previousRoutePath = state.extra as String?;
          if (previousRoutePath == null) {
            return LoginView();
          }
          return LoginView(previousRoutePath: previousRoutePath);
        },
      ),
      GoRoute(
        path: RegisterView.routePath,
        name: RegisterView.routePath,
        builder: (context, state) {
          final previousRoutePath = state.extra as String?;
          if (previousRoutePath == null) {
            return RegisterView();
          }
          return RegisterView(previousRoutePath: previousRoutePath);
        },
      ),
      GoRoute(
        path: ForgotPasswordView.routePath,
        name: ForgotPasswordView.routePath,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder:
            (context, state) =>
                const Scaffold(body: Center(child: Text('Profile Screen'))),
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Text(
              'Error: ${state.error}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
  );
});
