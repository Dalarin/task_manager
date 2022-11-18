import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user.dart';
import '../../repository/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  UserBloc(this._repository) : super(UserInitial()) {
    on<GetUsersByTaskId>((event, emit) => _fetchUsersByTaskId(event, emit));
    on<GetUsersByListId>((event, emit) => _fetchUsersByListId(event, emit));
    on<DeleteUserFromTask>((event, emit) => _deleteUserFromTask(event, emit));
    on<DeleteUserFromList>((event, emit) => _deleteUserFromList(event, emit));
    on<DeleteUser>((event, emit) => _deleteUser(event, emit));
  }

  _deleteUser(DeleteUser event, emit) async {}

  _deleteUserFromTask(DeleteUserFromTask event, emit) async {
    emit(UserLoading());
    bool deleted = await _repository.deleteUserFromTask(
      event.taskId,
      event.userId,
    );
    if (deleted) {
      emit(const UserListLoaded(users: []));
    } else {
      emit(const UserError(message: 'Ошибка удаления пользователя'));
    }
  }

  _fetchUsersByTaskId(GetUsersByTaskId event, emit) async {
    emit(UserLoading());
    List<User>? users = await _repository.fetchUsersByTaskId(event.taskId);
    if (users != null) {
      emit(UserListLoaded(users: users));
    } else {
      emit(const UserError(message: 'Ошибка загрузки пользователей'));
    }
  }

  _fetchUsersByListId(GetUsersByListId event, emit) async {
    emit(UserLoading());
    List<User>? users = await _repository.fetchUsersByListId(event.listId);
    if (users != null) {
      emit(UserListLoaded(users: users));
    } else {
      emit(const UserError(message: 'Ошибка загрузки пользователей'));
    }
  }

  _deleteUserFromList(DeleteUserFromList event, emit) async {
    emit(UserLoading());
    bool deleted =
        await _repository.deleteUserFromList(event.listId, event.userId);
    if (deleted) {
      emit(const UserListLoaded(users: []));
    } else {
      emit(const UserError(message: 'Ошибка загрузки пользователей'));
    }
  }
}
