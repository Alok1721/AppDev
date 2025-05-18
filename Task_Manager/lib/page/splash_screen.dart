import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print('SplashScreen: Loading tasks'); // Debug
    context.read<TaskBloc>().add(LoadTasks());
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        print('SplashScreen: Fallback navigation after 5s'); // Debug
        navigateToDashboardScreen();
      }
    });
  }

  void navigateToDashboardScreen() {
    print('SplashScreen: Navigating to /dashboard'); // Debug
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskLoaded) {
          print('SplashScreen: Tasks loaded, navigating'); // Debug
          navigateToDashboardScreen();
        } else if (state is TaskError) {
          print('SplashScreen: Error loading tasks, navigating'); // Debug
          navigateToDashboardScreen();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: CircleBackgroundPainter(),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  const Text(
                    'Manage your\ndaily tasks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Team & Project management\nsolution providing App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: ElevatedButton(
                      onPressed: navigateToDashboardScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final circles = [
      {'center': const Offset(150, 200), 'radius': 80.0, 'color': Colors.blue},
      {'center': const Offset(220, 150), 'radius': 50.0, 'color': Colors.purple},
      {'center': const Offset(100, 300), 'radius': 60.0, 'color': Colors.grey.shade300},
      {'center': const Offset(200, 250), 'radius': 40.0, 'color': Colors.blue.shade200},
      {'center': const Offset(180, 320), 'radius': 70.0, 'color': Colors.grey.shade500},
    ];

    for (var circle in circles) {
      paint.color = circle['color'] as Color;
      canvas.drawCircle(
        circle['center'] as Offset,
        circle['radius'] as double,
        paint,
      );
    }

    final linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path()
      ..moveTo(150, 150)
      ..quadraticBezierTo(200, 200, 150, 300)
      ..quadraticBezierTo(100, 350, 200, 350);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}