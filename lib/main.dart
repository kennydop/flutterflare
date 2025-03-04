import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/app/app.dart';

void main() async {
  final container = ProviderContainer();

  await initializeApp();
  // Run the app with the initialized container
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
