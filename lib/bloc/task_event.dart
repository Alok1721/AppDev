import '../model/Task.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);
}

class UpdateTask extends TaskEvent {
  final int id;
  final Task task;
  UpdateTask(this.id, this.task);
}

class DeleteTask extends TaskEvent {
  final int id;
  DeleteTask(this.id);
}
