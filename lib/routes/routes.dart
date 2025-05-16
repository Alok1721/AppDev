import 'package:flutter/material.dart';
import '../page/splash_screen.dart';
import '../page/task_list_screen.dart';


class AppRoutes {
  static const String splash = '/';
  static const String taskList = '/task_list';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case taskList:
        return MaterialPageRoute(builder: (_) => const TaskListScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}