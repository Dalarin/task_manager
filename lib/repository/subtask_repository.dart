import 'package:task_manager/bloc/subtask_bloc/subtask_provider.dart';
import 'package:task_manager/models/subtask.dart';

class SubtaskRepository {
  final _provider = SubtaskProvider();

  Future<List<SubTask>?> fetchSubtasksByTaskId(int taskId) =>
      _provider.fetchSubtasksByTaskId(taskId);

  Future<SubTask?> updateSubtask(SubTask subTask, int id) =>
      _provider.updateSubtask(subTask, id);

  Future<bool> deleteSubtask(int id) => _provider.deleteSubtask(id);

  Future<SubTask?> createSubtask(SubTask subTask) =>
      _provider.createSubtask(subTask);
}
