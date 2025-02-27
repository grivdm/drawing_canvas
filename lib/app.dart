// lib/app.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

sealed class App {
  const App._();

  static Future<void> startup() async {
    await runZonedGuarded(
      () async {
        runApp(const MyApp());
      },
      (error, stack) {
        debugPrint('Error: $error');
        debugPrint('Stack trace: $stack');
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
