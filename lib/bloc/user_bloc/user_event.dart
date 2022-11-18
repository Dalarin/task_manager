part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUsersByTaskId extends UserEvent {
  final int taskId;

  const GetUsersByTaskId({required this.taskId});
}

class GetUsersByListId extends UserEvent {
  final int listId;

  const GetUsersByListId({required this.listId});
}

class UpdateUser extends UserEvent {
  final User user;

  const UpdateUser({required this.user});
}

class DeleteUser extends UserEvent {
  final int userId;

  const DeleteUser({required this.userId});
}

class DeleteUserFromTask extends UserEvent {
  final int taskId;
  final int userId;

  const DeleteUserFromTask({required this.taskId, required this.userId});
}

class DeleteUserFromList extends UserEvent {
  final int listId;
  final int userId;

  const DeleteUserFromList({required this.listId, required this.userId});
}
