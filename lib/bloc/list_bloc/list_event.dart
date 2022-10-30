part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();
  @override
  List<Object> get props => [];

}

class UpdateList extends ListEvent {
  final int listId;
  final model.List list;

  const UpdateList(this.listId, this.list);
}

class CreateList extends ListEvent {
  final int userId;
  final String title;
  final DateTime creationDate;
  final List<model.List> list;

  const CreateList(this.userId, this.title, this.creationDate, this.list);
}

class DeleteList extends ListEvent {
  final int listId;
  const DeleteList(this.listId);
}

class LoadLists extends ListEvent{
  final int userId;
  const LoadLists(this.userId);
}
