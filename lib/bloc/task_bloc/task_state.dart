part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskListLoaded extends TaskState {
  final List<Task> list;

  const TaskListLoaded(this.list);
}


class TaskUpdated extends TaskState{}


class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);
}
