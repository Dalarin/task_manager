part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();
  @override
  List<Object> get props => [];

}

class UpdateList extends ListEvent {
  final ListModel list;
  final List<ListModel> lists;

  const UpdateList({required this.lists, required this.list});
}

class AddListToTask extends ListEvent {
  final ListModel listModel;
  const AddListToTask({required this.listModel});
}

class CreateList extends ListEvent {
  final int userId;
  final String title;
  final DateTime creationDate;
  final List<ListModel> list;

  const CreateList(this.userId, this.title, this.creationDate, this.list);
}

class DeleteList extends ListEvent {
  final ListModel listModel;
  final List<ListModel> list;
  const DeleteList({required this.listModel, required this.list});
}

class LoadLists extends ListEvent{
  final int userId;
  const LoadLists(this.userId);
}
