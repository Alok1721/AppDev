import 'package:flutter/material.dart';
import '../page/create_task_screen.dart';
import '../page/dashboard.dart';
import '../page/splash_screen.dart';
import '../page/task_list_screen.dart';


class AppRoutes {
  static const String splash = '/';
  static const String taskList = '/task_list';
  static const String dashboard = '/dashboard';
  static const String createTask = '/create_task';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case taskList:
        return MaterialPageRoute(builder: (_) => const TaskListScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case createTask:
        return MaterialPageRoute(builder: (_) => const CreateTaskScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('404'),
              leading: Navigator.canPop(context) ? const BackButton() : null,
            ),
            body: const Center(child: Text('Route not found')),
          ),
        );

    }
  }
}