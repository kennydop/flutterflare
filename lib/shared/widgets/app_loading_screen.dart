import 'package:flutter/material.dart';

// A loading screen widget displayed during app initialization
// and while authentication state is being determined
class AppLoadingScreen extends StatelessWidget {
  static const routePath = '/loading';
  const AppLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
