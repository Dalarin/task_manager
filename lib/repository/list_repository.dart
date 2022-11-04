import 'package:task_manager/bloc/list_bloc/list_provider.dart';
import 'package:task_manager/models/list.dart' as model;

class ListRepository {
  final _repository = ListProvider();

  Future<List<model.ListModel>?> fetchListByUserId(int userId) =>
      _repository.fetchListByUserId(userId);

  Future<model.ListModel?> createList(model.ListModel list) => _repository.createList(list);

  Future<bool> deleteList(int listId) => _repository.deleteList(listId);

  Future<model.ListModel?> updateList(model.ListModel list) => _repository.updateList(list);
}
