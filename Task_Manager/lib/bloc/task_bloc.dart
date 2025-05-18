import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../repositories/task_repository.dart';
import '../model/Task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final List<Task> tasks = await repository.getTasks();
        print('TaskBloc: Loaded ${tasks.length} tasks'); // Debug
        emit(TaskLoaded(tasks));
      } catch (e) {
        print('TaskBloc: Error loading tasks: $e'); // Debug
        emit(TaskError('Failed to load tasks: $e'));
      }
    });

    on<AddTask>((event, emit) async {
      try {
        await repository.createTask(event.task);
        if (state is TaskLoaded) {
          final updatedTasks = List<Task>.from((state as TaskLoaded).tasks)..add(event.task);
          print('TaskBloc: Added task, new count: ${updatedTasks.length}'); // Debug
          emit(TaskLoaded(updatedTasks));
        } else {
          add(LoadTasks());
        }
      } catch (e) {
        print('TaskBloc: Error adding task: $e'); // Debug
        emit(TaskError('Failed to add task: $e'));
      }
    });

    on<UpdateTask>((event, emit) async {
      try {
        await repository.updateTask(event.id, event.task);
        if (state is TaskLoaded) {
          final updatedTasks = (state as TaskLoaded).tasks.map((task) {
            return task.id == event.id ? event.task : task;
          }).toList();
          print('TaskBloc: Updated task ID ${event.id}'); // Debug
          emit(TaskLoaded(updatedTasks));
        } else {
          add(LoadTasks());
        }
      } catch (e) {
        print('TaskBloc: Error updating task: $e'); // Debug
        emit(TaskError('Failed to update task: $e'));
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        await repository.deleteTask(event.id);
        if (state is TaskLoaded) {
          final updatedTasks = (state as TaskLoaded).tasks.where((task) => task.id != event.id).toList();
          print('TaskBloc: Deleted task ID ${event.id}, new count: ${updatedTasks.length}'); // Debug
          emit(TaskLoaded(updatedTasks));
        } else {
          add(LoadTasks());
        }
      } catch (e) {
        print('TaskBloc: Error deleting task: $e'); // Debug
        emit(TaskError('Failed to delete task: $e'));
      }
    });
  }
}