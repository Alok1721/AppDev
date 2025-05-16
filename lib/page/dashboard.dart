import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_state.dart';
import '../widgets/bottom_navigation.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              int doneCount = 0;
              int inProgressCount = 0;
              int waitingCount = 0;
              int reviewCount = 0;
              int pendingCount = 0;

              if (state is TaskLoaded) {
                final tasks = state.tasks;
                doneCount = tasks.where((task) => task.status).length;
                inProgressCount = tasks.where((task) => !task.status && task.priority == 1).length;
                waitingCount = tasks.where((task) => !task.status && task.priority == 2).length;
                reviewCount = tasks.where((task) => !task.status && task.priority == 3).length;
                pendingCount = tasks.where((task) => !task.status).length;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi Alkraj',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Text(
                            '$pendingCount tasks pending',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Mobile App Design Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mobile App Design',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 18),
                              ),
                              Text(
                                'Me and Anita',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                            ),
                            Positioned(
                              left: 20,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Now',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Monthly Review Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MONTHLY REVIEW',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          Navigator.pushNamed(context, '/task_list');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildReviewCard('Done', doneCount, Colors.green, context),
                        _buildReviewCard('In Progress', inProgressCount, Colors.orange, context),
                        _buildReviewCard('Waiting', waitingCount, Colors.blue, context),
                        _buildReviewCard('Review', reviewCount, Colors.purple, context),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 0, // Dashboard is the first tab
        onTap: (index) {
          if (index == 0) {
          } else if (index == 1) {
            Navigator.pushNamed(context, '/files');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/notifications');
          }
        },
      ),
    );
  }

  Widget _buildReviewCard(String title, int count, Color color, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}