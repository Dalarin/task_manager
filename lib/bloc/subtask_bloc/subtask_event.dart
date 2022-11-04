part of 'subtask_bloc.dart';

abstract class SubtaskEvent extends Equatable {
  const SubtaskEvent();

  @override
  List<Object> get props => [];
}

class UpdateSubtask extends SubtaskEvent {
  final int subtaskId;
  final List<SubTask> subtaskList;
  final SubTask subTask;

  const UpdateSubtask(this.subTask, this.subtaskId, this.subtaskList);
}

class CreateSubtask extends SubtaskEvent {
  final List<SubTask> subtaskList;
  final int taskId;
  final String title;


  const CreateSubtask(this.taskId, this.title, this.subtaskList);
}

class DeleteSubtask extends SubtaskEvent {
  final List<SubTask> subtaskList;
  final int subtaskId;

  const DeleteSubtask(this.subtaskId, this.subtaskList);
}

class GetSubtasks extends SubtaskEvent {
  final int taskId;

  const GetSubtasks(this.taskId);
}
