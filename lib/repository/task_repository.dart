import '../models/task.dart';
import '../bloc/task_bloc/task_provider.dart';

class TaskRepository {
  final _provider = TaskProvider();

  Future<List<Task>?> fetchTasksByUserId(int userId) =>
      _provider.fetchTasksByUserId(userId);

  Future<List<Task>?> fetchTasksByListId(int listId) =>
      _provider.fetchTasksByListId(listId);

  Future<bool> deleteTask(int taskId) => _provider.deleteTask(taskId);

  Future<Task?> createTask(Task task) => _provider.createTask(task);

  Future<List<Task>?> fetchTasksByDate(DateTime dateTime, int userId) => _provider.fetchTasksByDate(dateTime, userId);

  Future<Task?> updateTask(int taskId, Task task) =>
      _provider.updateTask(taskId, task);
}

class NetworkError extends Error {}
