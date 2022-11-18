part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class UpdateTask extends TaskEvent {
  final int taskId;
  final Task task;
  final List<Task> tasks;

  const UpdateTask(this.taskId, this.task, this.tasks);
}


class CreateTask extends TaskEvent {
  final List<Task> tasks;
  final int userId;
  final String title;
  final String description;
  final DateTime creationDate;
  final DateTime completeDate;
  final List<Tag> tags;
  final List<SubTask> subtasks;


  const CreateTask(this.userId, this.title, this.description, this.creationDate, this.completeDate, this.tags, this.tasks, this.subtasks);
}

class DayOfTasksSelected extends TaskEvent {
  final DateTime selectedDay;
  final int userId;

  const DayOfTasksSelected(this.selectedDay, this.userId);
}

class DeleteTask extends TaskEvent {
  final int taskId;
  final List<Task> tasks;

  const DeleteTask(this.taskId, this.tasks);
}

class GetTask extends TaskEvent {
  final int taskId;

  const GetTask(this.taskId);
}

class GetTaskList extends TaskEvent {
  final int userId;

  const GetTaskList(this.userId);
}

class GetTasksOfList extends TaskEvent {
  final int listId;

  const GetTasksOfList(this.listId);
}
