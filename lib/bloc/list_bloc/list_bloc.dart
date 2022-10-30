import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/models/list.dart' as model;

import '../../repository/list_repository.dart';

part 'list_event.dart';

part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ListRepository _repository;

  ListBloc(this._repository) : super(ListInitial()) {
    on<LoadLists>((event, emit) => _loadList(event, emit));
    on<CreateList>((event, emit) => _createList(event, emit));
    on<UpdateList>((event, emit) => _updateList(event, emit));
    on<DeleteList>((event, emit) => _deleteList(event, emit));
  }

  void _catchHandler(event, emit, Exception exception) {
    if (exception is SocketException) {
      emit(const ListError(
        'Ошибка. Проверьте интернет соединение и попробуйте снова',
      ));
    } else {
      emit(const ListError('Ошибка авторизации'));
    }
  }

  _deleteList(event, emit) async {}

  _updateList(event, emit) async {}

  _createList(event, emit) async {
    try {
      emit(ListLoading());
      model.List? isCreated = await _repository.createList(model.List(
        userId: event.userId,
        title: event.title,
        completeBy: event.creationDate,
      ));
      if (isCreated != null) {
        event.list.add(isCreated);
        emit(ListLoaded(event.list));
      } else {
        emit(const ListError('Ошибка создания списка'));
      }
    } on Exception catch (_, exception) {
      _catchHandler(event, emit, _);
    }
  }

  _loadList(event, emit) async {
    try {
      emit(ListLoading());
      var lists = await _repository.fetchListByUserId(event.userId);
      if (lists != null) {
        emit(ListLoaded(lists));
      } else {
        emit(const ListError('Ошибка при загрузке информации'));
      }
    } on Exception catch (_, exception) {
      _catchHandler(event, emit, _);
    }
  }
}
