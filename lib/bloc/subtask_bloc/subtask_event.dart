part of 'subtask_bloc.dart';

abstract class SubtaskEvent extends Equatable {
  const SubtaskEvent();

  @override
  List<Object> get props => [];
}

class UpdateSubtask extends SubtaskEvent {
  final int subtaskId;
  final Task task;
  final List<SubTask> subtaskList;
  final SubTask subTask;

  const UpdateSubtask(this.subTask, this.task, this.subtaskId, this.subtaskList);
}

class CreateSubtask extends SubtaskEvent {
  final Task task;
  final String title;


  const CreateSubtask(this.title, this.task);
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
