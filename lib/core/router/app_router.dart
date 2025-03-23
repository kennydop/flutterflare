import 'package:flutter/material.dart';
import 'package:flutterflare/core/services/storage/local_storage_service.dart';
import 'package:flutterflare/features/auth/views/user_profile_view.dart';
import 'package:flutterflare/features/home/views/home_view.dart';
import 'package:flutterflare/features/onboarding/views/onboarding_view.dart';
import 'package:flutterflare/features/settings/views/notification_settings_view.dart';
import 'package:flutterflare/shared/widgets/app_error_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/features/auth/views/login_view.dart';
import 'package:flutterflare/features/auth/views/register_view.dart';
import 'package:flutterflare/features/auth/views/forgot_password_view.dart';
import 'package:flutterflare/features/welcome/views/welcome_view.dart';
import 'package:flutterflare/shared/widgets/app_loading_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// Root navigator key for the app
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Provider to access the root navigator key
@Riverpod(keepAlive: true)
GlobalKey<NavigatorState> rootNavigatorKey(RootNavigatorKeyRef ref) {
  return _rootNavigatorKey;
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final localStorage = ref.watch(localStorageProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppLoadingScreen.routePath,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // If the auth state is loading, show a loading screen
      if (authState.isLoading) {
        return null;
      }
      final isLoggedIn = authState.valueOrNull != null;
      final isLoadingScreen =
          state.matchedLocation == AppLoadingScreen.routePath;
      final isAuthRoute =
          state.matchedLocation == LoginView.routePath ||
          state.matchedLocation == RegisterView.routePath ||
          state.matchedLocation == ForgotPasswordView.routePath;
      final isWelcomeRoute = state.matchedLocation == WelcomeView.routePath;
      final isOnboardingRoute =
          state.matchedLocation == OnboardingView.routePath;
      final hasCompletedOnboarding = localStorage.hasOnboardingCompleted();

      // 1. Handle loading screen redirections
      if (isLoadingScreen) {
        if (!hasCompletedOnboarding) {
          return OnboardingView.routePath;
        }
        return isLoggedIn ? HomeView.routePath : WelcomeView.routePath;
      }

      // 2. Handle onboarding redirections
      if (!hasCompletedOnboarding && !isOnboardingRoute) {
        return OnboardingView.routePath;
      }

      // 3. Handle authentication redirections
      if (!isLoggedIn) {
        // If not logged in, only allow access to public routes
        final isPublicRoute =
            isAuthRoute || isWelcomeRoute || isOnboardingRoute;
        if (!isPublicRoute) {
          return WelcomeView.routePath;
        }
      } else {
        // If logged in, redirect away from auth and welcome routes
        if (isAuthRoute || isWelcomeRoute) {
          return HomeView.routePath;
        }
      }

      // Allow the navigation to proceed
      return null;
    },
    routes: [
      // Loading screen route
      GoRoute(
        path: AppLoadingScreen.routePath,
        builder: (context, state) => const AppLoadingScreen(),
      ),
      GoRoute(
        path: OnboardingView.routePath,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: WelcomeView.routePath,
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: HomeView.routePath,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: LoginView.routePath,
        builder: (context, state) {
          final previousRoutePath = state.extra as String?;
          if (previousRoutePath == null) {
            return const LoginView();
          }
          return LoginView(previousRoutePath: previousRoutePath);
        },
      ),
      GoRoute(
        path: RegisterView.routePath,
        builder: (context, state) {
          final previousRoutePath = state.extra as String?;
          if (previousRoutePath == null) {
            return const RegisterView();
          }
          return RegisterView(previousRoutePath: previousRoutePath);
        },
      ),
      GoRoute(
        path: ForgotPasswordView.routePath,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: UserProfileView.routePath,
        builder: (context, state) => const UserProfileView(),
      ),
      GoRoute(
        path: NotificationSettingsView.routePath,
        builder: (context, state) => const NotificationSettingsView(),
      ),
    ],
    errorBuilder:
        (context, state) => AppErrorWidget(error: 'Error: ${state.error}'),
  );
});
