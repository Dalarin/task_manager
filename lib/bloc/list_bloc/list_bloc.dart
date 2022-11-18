
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/models/list.dart';

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
    on<AddListToTask>((event, emit) => _addListToTask(event, emit));
  }

  void _catchHandler(event, emit, Exception exception) {
    emit(const ListError('Ошибка'));
  }

  _deleteList(DeleteList event, emit) async {
    try {
      emit(ListLoading());
      bool deleted = await _repository.deleteList(event.listModel.id!);
      if (!deleted) {
        emit(const ListError('Ошибка удаления списка'));
      } else {
        event.list.remove(event.listModel);
        emit(ListLoaded(event.list));
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }


  _addListToTask(AddListToTask event, emit) async {
    try {
      ListModel? list = await _repository.updateList(event.listModel);
      if (list != null) {

      } else {
        emit(const ListError('Ошибка добавления списка в задание'));
      }
    }on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _updateList(UpdateList event, emit) async {
    try {
      emit(ListLoading());
      ListModel? list = await _repository.updateList(event.list);
      if (list != null) {
        event.lists.removeWhere((element) => element.id == event.list.id!);
        event.lists.add(list);
        event.lists.sort((a,b) => a.id!.compareTo(b.id!));
        emit(ListLoaded(event.lists));
      } else {
        emit(const ListError('Ошибка обновления списка'));
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _createList(CreateList event, emit) async {
    try {
      emit(ListLoading());
      ListModel? isCreated = await _repository.createList(ListModel(
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
