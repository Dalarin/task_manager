part of 'invite_bloc.dart';

abstract class InviteEvent extends Equatable {
  const InviteEvent();

  @override
  List<Object> get props => [];
}

class UpdateTaskInvite extends InviteEvent {
  final TaskInvite invite;
  final List<TaskInvite> invites;

  const UpdateTaskInvite({required this.invite, required this.invites});
}

class UpdateListInvite extends InviteEvent {
  final TaskInvite invite;
  final List<ListInvite> invites;

  const UpdateListInvite({required this.invite, required this.invites});
}

class CreateTaskInvite extends InviteEvent {
  final String email;
  final Task task;
  final User invitedBy;
  final List<TaskInvite> invites;

  const CreateTaskInvite({
    required this.email,
    required this.task,
    required this.invites,
    required this.invitedBy,
  });
}

class CreateListInvite extends InviteEvent {
  final String email;
  final ListModel listModel;
  final User invitedBy;
  final List<ListInvite> invites;

  const CreateListInvite({
    required this.email,
    required this.listModel,
    required this.invites,
    required this.invitedBy,
  });
}

class DeleteTaskInvite extends InviteEvent {
  final int id;
  final List<TaskInvite> invites;

  const DeleteTaskInvite({required this.id, required this.invites});
}

class DeleteListInvite extends InviteEvent {
  final int id;
  final List<ListInvite> invites;

  const DeleteListInvite({required this.id, required this.invites});
}

class GetInvitesByTask extends InviteEvent {
  final int taskId;

  const GetInvitesByTask({required this.taskId});
}

class GetInvitesByList extends InviteEvent {
  final int listId;

  const GetInvitesByList({required this.listId});
}

class GetTaskInvitesByUser extends InviteEvent {
  final int userId;

  const GetTaskInvitesByUser({required this.userId});
}

class GetListInvitesByUser extends InviteEvent {
  final int userId;

  const GetListInvitesByUser({required this.userId});
}

class AcceptTaskInvite extends InviteEvent {
  final TaskInvite taskInvite;
  final List<TaskInvite> taskInviteList;

  const AcceptTaskInvite({required this.taskInvite, required this.taskInviteList});
}

class AcceptListInvite extends InviteEvent {
  final ListInvite listInvite;
  final List<ListInvite> listInviteList;

  const AcceptListInvite({required this.listInvite, required this.listInviteList});
}
