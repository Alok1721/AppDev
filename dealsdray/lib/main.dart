import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'dashboard.dart';

void main() {
  runApp(const TaskCollectionApp());
}

class TaskCollectionApp extends StatelessWidget {
  const TaskCollectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}