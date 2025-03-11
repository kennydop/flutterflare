import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  static const routePath = '/';

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    // Use the centralized error handler
    ref.watch(authErrorHandlerProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.goNamed('profile');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user != null)
                Text(
                  'Welcome, ${user.firstName ?? 'User'}!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              const SizedBox(height: 24),
              Button(
                label: 'View Profile',
                onPressed: () {
                  context.goNamed('profile');
                },
              ),
              const SizedBox(height: 16),
              Button(
                label: 'Sign Out',
                onPressed: () {
                  ref.read(authProvider.notifier).signOut();
                },
                variant: ButtonVariant.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
