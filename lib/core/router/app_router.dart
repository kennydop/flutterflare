import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/services/storage/local_storage_service.dart';
import 'package:flutterflare/features/auth/views/user_profile_view.dart';
import 'package:flutterflare/features/home/views/home_view.dart';
import 'package:flutterflare/features/onboarding/views/onboarding_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/features/auth/views/login_view.dart';
import 'package:flutterflare/features/auth/views/register_view.dart';
import 'package:flutterflare/features/auth/views/forgot_password_view.dart';
import 'package:flutterflare/features/welcome/views/welcome_view.dart';
import 'package:flutterflare/shared/widgets/app_loading_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final localStorage = ref.watch(localStorageProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/loading',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Show loading screen until auth state is determined
      final isLoading = authState.isLoading;
      final isLoggedIn = authState.valueOrNull != null;
      final isLoadingScreen = state.matchedLocation == '/loading';

      // If auth state is loading, stay on loading screen
      if (isLoading) {
        return isLoadingScreen ? null : '/loading';
      }

      // Now we have auth state, handle redirection
      final isAuthRoute =
          state.matchedLocation == LoginView.routePath ||
          state.matchedLocation == RegisterView.routePath ||
          state.matchedLocation == ForgotPasswordView.routePath;
      final isWelcomeRoute = state.matchedLocation == WelcomeView.routePath;
      final isOnboardingRoute =
          state.matchedLocation == OnboardingView.routePath;

      // Don't stay on loading screen once we have auth state
      if (isLoadingScreen) {
        // If onboarding hasn't been completed, go to onboarding
        if (!localStorage.hasOnboardingCompleted()) {
          return OnboardingView.routePath;
        }

        // If logged in, go to home, else go to welcome
        return isLoggedIn ? HomeView.routePath : WelcomeView.routePath;
      }

      // If onboarding hasn't been completed and not on onboarding route, redirect to onboarding
      if (!localStorage.hasOnboardingCompleted() && !isOnboardingRoute) {
        return OnboardingView.routePath;
      }

      // If not logged in and not on an auth route or welcome route or onboarding route, redirect to welcome
      if (!isLoggedIn &&
          !isAuthRoute &&
          !isWelcomeRoute &&
          !isOnboardingRoute) {
        return WelcomeView.routePath;
      }

      // If logged in and on an auth route or welcome route, redirect to home
      if (isLoggedIn && (isAuthRoute || isWelcomeRoute)) {
        return HomeView.routePath;
      }

      return null;
    },
    routes: [
      // Loading screen route
      GoRoute(
        path: '/loading',
        builder: (context, state) => const AppLoadingScreen(),
      ),
      GoRoute(
        path: OnboardingView.routePath,
        name: OnboardingView.routePath,
        builder: (context, state) => const OnboardingView(),
      ),
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
            return const LoginView();
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
            return const RegisterView();
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
        builder: (context, state) => const UserProfileView(),
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
