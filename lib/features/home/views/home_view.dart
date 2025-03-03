import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/features/auth/repositories/auth_repository.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Button(
            label: 'Sign Out',
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ),
      ),
    );
  }
}
