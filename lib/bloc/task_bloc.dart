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
        emit(TaskLoaded(tasks));
      } catch (e) {
        print("ERROR loading tasks: $e");
        emit(TaskError("Failed to load tasks"));
      }
    });

    on<AddTask>((event, emit) async {
      try {
        await repository.createTask(event.task);
        add(LoadTasks());
      } catch (e) {
        emit(TaskError("Failed to add task"));
      }
    });

    on<UpdateTask>((event, emit) async {
      try {
        await repository.updateTask(event.id, event.task);
        add(LoadTasks());
      } catch (e) {
        emit(TaskError("Failed to update task"));
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        await repository.deleteTask(event.id);
        add(LoadTasks());
      } catch (e) {
        emit(TaskError("Failed to delete task"));
      }
    });
  }
}
