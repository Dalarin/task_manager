import 'package:task_manager/bloc/invite_bloc/invite_provider.dart';
import 'package:task_manager/models/listInvite.dart';

import '../models/taskInvite.dart';

class InviteRepository {
  final _repository = InviteProvider();

  Future<List<TaskInvite>?> fetchTaskInvitesByUserId(int userId) =>
      _repository.fetchTaskInvitationsByUserId(userId);

  Future<List<ListInvite>?> fetchListInvitesByUserId(int userId) =>
      _repository.fetchListInvitationsByUserId(userId);

  Future<List<TaskInvite>?> fetchInvitesByTaskId(int taskId) =>
      _repository.fetchInvitationsByTaskId(taskId);

  Future<List<ListInvite>?> fetchInvitesByListId(int listId) =>
      _repository.fetchInvitationsByListId(listId);

  Future<TaskInvite?> createTaskInvite(String email, TaskInvite invite) =>
      _repository.createTaskInvite(email, invite);

  Future<ListInvite?> createListInvite(String email, ListInvite invite) =>
      _repository.createListInvite(email, invite);

  Future<TaskInvite?> updateTaskInvite(TaskInvite invite) =>
      _repository.updateTaskInvite(invite);

  Future<ListInvite?> updateListInvite(ListInvite invite) =>
      _repository.updateListInvite(invite);

  Future<bool> deleteTaskInvite(int inviteId) =>
      _repository.deleteTaskInvite(inviteId);

  Future<bool> deleteListInvite(int inviteId) =>
      _repository.deleteListInvite(inviteId);
}
