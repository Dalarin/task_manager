part of 'subtask_bloc.dart';

abstract class SubtaskState extends Equatable {
  const SubtaskState();

  @override
  List<Object> get props => [];
}

class SubtaskInitial extends SubtaskState {}

class SubtaskLoading extends SubtaskState {}

class SubtaskLoaded extends SubtaskState {
  final List<SubTask> subTasks;

  const SubtaskLoaded(this.subTasks);
}

class SubtaskError extends SubtaskState {
  final String message;

  const SubtaskError(this.message);
}
