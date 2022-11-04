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
      emit(const ListError('Ошибка загрузки информации'));
    }
  }

  _deleteList(event, emit) async {}

  _updateList(UpdateList event, emit) async {
    try {
      model.ListModel? list = await _repository.updateList(event.list);
      if (list != null) {
        print('update');
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _createList(CreateList event, emit) async {
    try {
      emit(ListLoading());
      model.ListModel? isCreated = await _repository.createList(model.ListModel(
        userId: event.userId,
        title: event.title,
        completeBy: event.creationDate,
        tasks: [],
      ));
      if (isCreated != null) {
        event.list.add(isCreated);
        emit(ListLoaded(event.list));
      } else {
        emit(const ListError('Ошибка создания списка'));
      }
    } on Exception catch (_) {
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
    } on Exception catch (_) {
      _catchHandler(event, emit, _);
    }
  }
}
