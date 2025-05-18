import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_state.dart';
import '../bloc/task_event.dart';
import '../model/Task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  DateTime _currentMonth = DateTime(2025, 5);
  DateTime _selectedDate = DateTime(2025, 5, 16);
  List<DateTime> _datesInMonth = [];

  @override
  void initState() {
    super.initState();
    _updateDatesInMonth();
    print('TaskListScreen: Loading tasks'); // Debug
    context.read<TaskBloc>().add(LoadTasks());
  }

  void _updateDatesInMonth() {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    _datesInMonth = List.generate(
      daysInMonth,
          (index) => DateTime(_currentMonth.year, _currentMonth.month, index + 1),
    );
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      _selectedDate = DateTime(_currentMonth.year, _currentMonth.month, 1);
      _updateDatesInMonth();
    });
  }

  void _nextMonth() {
    setState() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _selectedDate = DateTime(_currentMonth.year, _currentMonth.month, 1);
      _updateDatesInMonth();
    };
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left, color: Theme.of(context).colorScheme.onSurface),
                        onPressed: _previousMonth,
                      ),
                      Text(
                        _monthName(_currentMonth.month),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right, color: Theme.of(context).colorScheme.onSurface),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 60,
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    Map<DateTime, int> taskCounts = {};
                    if (state is TaskLoaded) {
                      for (var task in state.tasks) {
                        final taskDate = DateTime(
                          task.targetDateTime.year,
                          task.targetDateTime.month,
                          task.targetDateTime.day,
                        );
                        taskCounts[taskDate] = (taskCounts[taskDate] ?? 0) + 1;
                      }
                    }
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: _datesInMonth.map((date) {
                        final isSelected = date.day == _selectedDate.day &&
                            date.month == _selectedDate.month &&
                            date.year == _selectedDate.year;
                        final taskCount = taskCounts[date] ?? 0;
                        return _buildDateCard(
                          context,
                          date.day.toString(),
                          _weekdayName(date.weekday),
                          isSelected,
                          taskCount,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoaded) {
                      if (state.tasks.isEmpty) {
                        return const Center(child: Text("No tasks available"));
                      }
                      final tasksForSelectedDate = state.tasks.where((task) {
                        return task.targetDateTime.day == _selectedDate.day &&
                            task.targetDateTime.month == _selectedDate.month &&
                            task.targetDateTime.year == _selectedDate.year;
                      }).toList();
                      tasksForSelectedDate.sort((a, b) {
                        if (a.priority != b.priority) {
                          return b.priority.compareTo(a.priority);
                        }
                        return a.targetDateTime.compareTo(b.targetDateTime);
                      });
                      final ongoingTasks = tasksForSelectedDate.where((task) => !task.status).toList();
                      final completedTasks = tasksForSelectedDate.where((task) => task.status).toList();

                      if (tasksForSelectedDate.isEmpty) {
                        return const Center(child: Text("No tasks for this date"));
                      }

                      return ListView(
                        children: [
                          if (ongoingTasks.isNotEmpty) ...[
                            Row(
                              children: [
                                Text(
                                  'Ongoing',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.pink,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...ongoingTasks.map((task) => _buildTaskCard(context, task, Colors.pink)),
                            const SizedBox(height: 24),
                          ],
                          if (completedTasks.isNotEmpty) ...[
                            Row(
                              children: [
                                Text(
                                  'Completed',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...completedTasks.map((task) => _buildTaskCard(context, task, Colors.green)),
                          ],
                        ],
                      );
                    } else if (state is TaskError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<TaskBloc>().add(LoadTasks());
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: Text("No data"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_task');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildDateCard(BuildContext context, String day, String weekday, bool isSelected, int taskCount) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _selectDate(DateTime(_currentMonth.year, _currentMonth.month, int.parse(day))),
          child: Container(
            width: 60,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  weekday,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.8)
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (taskCount > 0)
          Positioned(
            top: 0,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Text(
                taskCount.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, Color groupColor) {
    return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: groupColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
          Checkbox(
          value: task.status,
          onChanged: (bool? value) {
            if (value != null) {
              final updatedTask = Task(
                id: task.id,
                title: task.title,
                description: task.description,
                status: value,
                createdAt: task.createdAt,
                priority: task.priority,
                targetDateTime: task.targetDateTime,
              );
              context.read<TaskBloc>().add(UpdateTask(task.id, updatedTask));
            }
          },
          activeColor: Theme.of(context).colorScheme.primary,
          checkColor: Theme.of(context).colorScheme.onPrimary,
        ),
        const SizedBox(width: 8),
        Column(
            children: [
            Text(
            _formatTime(task.targetDateTime),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.bold,
    ),
    ),
    Text(
    _formatPeriod(task.targetDateTime),
    style: Theme.of(context).textTheme.bodyMedium,
    ),
    ],
    ),
    const SizedBox(width: 16),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    task.title,
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    fontWeight: FontWeight.bold,
    decoration: task.status ? TextDecoration.lineThrough : null,
    color: task.status
    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
        : Theme.of(context).colorScheme.onSurface,
    ),
    ),
    const SizedBox(height: 4),
    Row(
    children: [
    Stack(
    children: [
    CircleAvatar(
    radius: 12,
    backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
    ),
    Positioned(
    left: 16,
    child: CircleAvatar(
    radius: 12,
    backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
    ),
    ),
    ],
    ),
    const SizedBox(width: 8),
    Text(
    'Unassigned',
    style: Theme.of(context).textTheme.bodyMedium,
    ),
    ],
    ),
    ],
    ),
    ),
    IconButton(
    icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.onSurface),
    onPressed: () {
    context.read<TaskBloc>().add(DeleteTask(task.id));
    },
    ),
    ],
    ),
    );
    }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    return '$hour ${dateTime.hour < 12 ? 'AM' : 'PM'}';
  }

  String _formatPeriod(DateTime dateTime) {
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$minute';
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _weekdayName(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
}