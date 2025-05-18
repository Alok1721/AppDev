import '../model/Task.dart';
import '../data/task_api_service.dart';

class TaskRepository {
  final TaskApiService apiService;

  TaskRepository(this.apiService);

  Future<List<Task>> getTasks() => apiService.fetchTasks();
  Future<void> createTask(Task task) => apiService.createTask(task);
  Future<void> updateTask(int id, Task task) => apiService.updateTask(id, task);
  Future<void> deleteTask(int id) => apiService.deleteTask(id);
}