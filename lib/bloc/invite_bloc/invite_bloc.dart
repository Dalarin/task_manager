import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/models/list.dart';
import 'package:task_manager/models/listInvite.dart';
import 'package:task_manager/providers/validator.dart';

import '../../models/task.dart';
import '../../models/taskInvite.dart';
import '../../models/user.dart';
import '../../repository/invite_repository.dart';

part 'invite_event.dart';

part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final InviteRepository _repository;

  InviteBloc(this._repository) : super(InviteInitial()) {
    on<CreateTaskInvite>((event, emit) => _createTaskInvite(event, emit));
    on<DeleteTaskInvite>((event, emit) => _deleteTaskInvite(event, emit));
    on<GetInvitesByTask>((event, emit) => _getInvitesByTaskId(event, emit));
    on<GetTaskInvitesByUser>(
        (event, emit) => _getTaskInvitesByUserId(event, emit));
    on<CreateListInvite>((event, emit) => _createListInvite(event, emit));
    on<DeleteListInvite>((event, emit) => _deleteListInvite(event, emit));
    on<GetInvitesByList>((event, emit) => _getInvitesByListId(event, emit));
    on<GetListInvitesByUser>(
        (event, emit) => _getListInvitesByUserId(event, emit));
  }

  _exceptionHandler(exception, emit) {}

  _createTaskInvite(CreateTaskInvite event, emit) async {
    try {
      if (event.email.isEmpty) {
        emit(const InviteError('Заполните поле и попробуйте снова'));
      } else {
        if (!Validator.validateEmail(event.email)) {
          emit(const InviteError(
              'Введите email в формате email@email.ru и попробуйте снова'));
        } else {
          TaskInvite? creation = TaskInvite(
            task: event.task,
            user: event.invitedBy,
            inviteDate: DateTime.now(),
          );
          TaskInvite? invite =
              await _repository.createTaskInvite(event.email, creation);
          if (invite != null) {
            event.invites.add(invite);
            emit(InviteTaskLoaded(event.invites));
          } else {
            emit(const InviteError('Ошибка создания приглашения'));
          }
        }
      }
    } catch (exception) {
      _exceptionHandler(exception, emit);
    }
  }

  _createListInvite(CreateListInvite event, emit) async {
    try {
      if (event.email.isEmpty) {
        emit(const InviteError('Заполните поле и попробуйте снова'));
      } else {
        if (!Validator.validateEmail(event.email)) {
          emit(const InviteError(
              'Введите email в формате email@email.ru и попробуйте снова'));
        } else {
          ListInvite? creation = ListInvite(
            listModel: event.listModel,
            user: event.invitedBy,
            inviteDate: DateTime.now(),
          );
          ListInvite? invite = await _repository.createListInvite(
            event.email,
            creation,
          );
          if (invite != null) {
            event.invites.add(invite);
            emit(InviteListLoaded(invites: event.invites));
          } else {
            emit(const InviteError('Ошибка создания приглашения'));
          }
        }
      }
    } catch (exception) {
      _exceptionHandler(exception, emit);
    }
  }

  _deleteTaskInvite(DeleteTaskInvite event, emit) async {
    try {
      bool deleted = await _repository.deleteTaskInvite(event.id);
      if (deleted) {
        event.invites.removeWhere((element) => element.id == event.id);
        emit(InviteTaskLoaded(event.invites));
      } else {
        emit(const InviteError('Ошибка удаления приглашения'));
      }
    } catch (exception) {
      _exceptionHandler(exception, emit);
    }
  }

  _deleteListInvite(DeleteListInvite event, emit) async {
    try {
      bool deleted = await _repository.deleteListInvite(event.id);
      if (deleted) {
        event.invites.removeWhere((element) => element.id == event.id);
        emit(InviteListLoaded(invites: event.invites));
      } else {
        emit(const InviteError('Ошибка удаления приглашения'));
      }
    } catch (exception) {
      _exceptionHandler(exception, emit);
    }
  }

  _getInvitesByTaskId(GetInvitesByTask event, emit) async {
    try {
      emit(InviteLoading());
      List<TaskInvite>? invites =
          await _repository.fetchInvitesByTaskId(event.taskId);
      if (invites != null) {
        emit(InviteTaskLoaded(invites));
      } else {
        emit(const InviteError('Ошибка загрузки'));
      }
    } catch (exception) {
      _exceptionHandler(exception, emit);
    }
  }

  _getInvitesByListId(GetInvitesByList event, emit) async {
    try {
      emit(InviteLoading());
      List<ListInvite>? invites = await _repository.fetchInvitesByListId(
        event.listId,
      );
      if (invites != null) {
        emit(InviteListLoaded(invites: invites));
      } else {
        emit(const InviteError('Ошибка загрузки'));
      }
    } catch (exception) {
      _exceptionHandler(exception, emit);
    }
  }

  _getListInvitesByUserId(GetListInvitesByUser event, emit) async {
    try {
      emit(InviteLoading());
      List<ListInvite>? invites = await _repository.fetchListInvitesByUserId(
        event.userId,
      );
      if (invites != null) {
        emit(InviteListLoaded(invites: invites));
      } else {
        emit(const InviteError('Ошибка загрузки'));
      }
    } catch (exception) {
      _exceptionHandler(exception, emit);
    }
  }

  _getTaskInvitesByUserId(GetTaskInvitesByUser event, emit) async {
    try {
      emit(InviteLoading());
      List<TaskInvite>? invites =
          await _repository.fetchTaskInvitesByUserId(event.userId);
      if (invites != null) {
        emit(InviteTaskLoaded(invites));
      } else {
        emit(const InviteError('Ошибка загрузки'));
      }
    } catch (exception) {
      _exceptionHandler(exception, emit);
    }
  }
}
