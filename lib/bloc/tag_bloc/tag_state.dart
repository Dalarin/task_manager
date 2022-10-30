part of 'tag_bloc.dart';

abstract class TagState extends Equatable {
  const TagState();

  @override
  List<Object> get props => [];
}

class TagInitial extends TagState {}

class TagLoading extends TagState {}

class TagListLoaded extends TagState {
  final List<Tag> tagModel;

  const TagListLoaded(this.tagModel);
}

class TagError extends TagState {
  final String? message;

  const TagError(this.message);
}
