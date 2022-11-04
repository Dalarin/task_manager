// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repository/task_repository.dart';

import '../../models/tag.dart';

part 'task_state.dart';

part 'task_event.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  TaskBloc(this._taskRepository) : super(TaskInitial()) {
    on<CreateTask>((event, emit) => _createTask(event, emit));
    on<DayOfTasksSelected>((event, emit) => _selectTasksOfDay(event, emit));
    on<UpdateTask>((event, emit) => _updateTask(event, emit));
    on<DeleteTask>((event, emit) => _deleteTask(event, emit));
    on<GetTasksOfList>((event, emit) => _getTasksOfList(event, emit));
    on<GetTaskList>((event, emit) => _getTaskList(event, emit));
  }

  void _catchHandler(event, emit, Exception exception) {
    if (exception is SocketException) {
      emit(const TaskError(
        'Ошибка. Проверьте интернет соединение и попробуйте снова',
      ));
    } else {
      emit(const TaskError('Ошибка загрузки информации'));
    }
  }

  _createTask(CreateTask event, emit) async {
    try {
      if (event.title.isEmpty || event.description.isEmpty) {
        emit(const TaskError('Ошибка'));
      } else {
        emit(TaskLoading());
        Task? task = await _taskRepository.createTask(Task(
          userID: event.userId,
          title: event.title,
          description: event.description,
          creationDate: event.creationDate,
          completeDate: event.completeDate,
          isCompleted: false,
          tags: event.tags,
        ));
        if (task != null) {
          event.tasks.add(task);
          emit(TaskListLoaded(event.tasks));
        } else {
          emit(const TaskError('Ошибка при создании задания'));
        }
      }
    } on Exception catch (exception, _) {
      _catchHandler(event, emit, exception);
    }
  }

  _selectTasksOfDay(DayOfTasksSelected event, emit) async {
    try {
      emit(TaskLoading());
      List<Task>? tasks = await _taskRepository.fetchTasksByDate(
          event.selectedDay, event.userId);
      if (tasks != null) {
        emit(TaskListLoaded(tasks));
      } else {
        emit(const TaskError('Ошибка при получении информации'));
      }
    } on Exception catch (exception, _) {
      _catchHandler(event, emit, exception);
    }
  }

  _deleteTask(event, emit) async {
    try {
      bool deleted = await _taskRepository.deleteTask(event.taskId);
      if (!deleted) {
        emit(const TaskError('Ошибка при удалении задания'));
      } else {
        event.tasks.removeWhere((element) => element.id == event.taskId);
        emit(TaskListLoaded(event.tasks));
      }
    } on Exception catch (exception, _) {
      _catchHandler(event, emit, exception);
    }
  }

  _updateTask(event, emit) async {
    try {
      Task? updated = await _taskRepository.updateTask(
        event.taskId,
        event.task,
      );
      if (updated == null) {
        emit(const TaskError('Ошибка при обновлении задания'));
      } else {
        event.tasks.add(updated);
        emit(TaskListLoaded(event.tasks));
      }
    } on Exception catch (exception, _) {
      _catchHandler(event, emit, exception);
    }
  }

  _getTasksOfList(event, emit) async {
    try {
      emit(TaskLoading());
      final taskList = await _taskRepository.fetchTasksByListId(event.listId);
      if (taskList != null) {
        emit(TaskListLoaded(taskList));
      } else {
        emit(const TaskError('Ошибка при получении информации'));
      }
    } on Exception catch (exception, _) {
      _catchHandler(event, emit, exception);
    }
  }

  _getTaskList(event, emit) async {
    try {
      emit(TaskLoading());
      final taskList = await _taskRepository.fetchTasksByUserId(event.userId);
      if (taskList != null) {
        emit(TaskListLoaded(taskList));
      } else {
        emit(const TaskError('Ошибка при получении информации'));
      }
    } on Exception catch (exception, _) {
      _catchHandler(event, emit, exception);
    }
  }
}
