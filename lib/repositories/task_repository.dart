import '../model/Task.dart';
import '../services/backendServices.dart';

class TaskRepository {
  Future<List<Task>> getTasks() => BackendService.getTasks();
  Future<void> createTask(Task task) => BackendService.createTask(task);
  Future<void> updateTask(int id, Task task) => BackendService.updateTask(id, task);
  Future<void> deleteTask(int id) => BackendService.deleteTask(id);
}
