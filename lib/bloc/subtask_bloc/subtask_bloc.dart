import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/subtask.dart';
import '../../models/task.dart';
import '../../repository/subtask_repository.dart';

part 'subtask_event.dart';

part 'subtask_state.dart';

class SubtaskBloc extends Bloc<SubtaskEvent, SubtaskState> {
  final SubtaskRepository _repository;

  SubtaskBloc(this._repository) : super(SubtaskInitial()) {
    on<UpdateSubtask>((event, emit) => _updateSubtask(event, emit));
    on<CreateSubtask>((event, emit) => _createSubtask(event, emit));
    on<DeleteSubtask>((event, emit) => _deleteSubtask(event, emit));
    on<GetSubtasks>((event, emit) => _getSubtasks(event, emit));
  }

  _catchHandler(event, emit, Exception exception) {
    if (exception is SocketException) {
      emit(const SubtaskError(
        'Ошибка. Проверьте интернет соединение и попробуйте снова',
      ));
    } else {
      emit(const SubtaskError('Ошибка загрузки информации'));
    }
  }

  _updateSubtask(UpdateSubtask event, emit) async {
    try {
      SubTask? subtask = await _repository.updateSubtask(
        event.subTask,
        event.subtaskId,
      );
      if (subtask != null) {
        emit(SubtaskLoading());
        event.subtaskList.remove(event.subTask);
        event.subtaskList.add(subtask);
        event.subtaskList.sort((a,b) => a.id!.compareTo(b.id!));
        emit(SubtaskLoaded(event.subtaskList));
      } else {
        emit(const SubtaskError('Ошибка обновления'));
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _createSubtask(CreateSubtask event, emit) async {
    try {
      if (event.title.isNotEmpty) {
        SubTask? subtask = await _repository.createSubtask(SubTask(
          task: event.task,
          title: event.title,
          isCompleted: false,
        ));
        if (subtask != null) {
          emit(SubtaskLoading());
          event.task.subTasks.add(subtask);
          emit(SubtaskLoaded(event.task.subTasks));
        } else {
          emit(const SubtaskError('Ошибка создания подзадания'));
        }
      } else {
        emit(const SubtaskError('Заполните все поля и попробуйте снова'));
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _deleteSubtask(DeleteSubtask event, emit) async {
    try {
      bool deleted = await _repository.deleteSubtask(event.subtaskId);
        if (deleted) {
          emit(SubtaskLoading());
          event.subtaskList.removeWhere(
            (element) => element.id == event.subtaskId,
          );
        emit(SubtaskLoaded(event.subtaskList));
      } else {
        emit(const SubtaskError('Ошибка удаления информации'));
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _getSubtasks(GetSubtasks event, emit) async {
    try {
      emit(SubtaskLoading());
      List<SubTask>? subtasks = await _repository.fetchSubtasksByTaskId(
        event.taskId,
      );
      if (subtasks != null) {
        emit(SubtaskLoaded(subtasks));
      } else {
        emit(const SubtaskError('Ошибка загрузки информации'));
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }
}
