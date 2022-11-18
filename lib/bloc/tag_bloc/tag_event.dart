part of 'tag_bloc.dart';

abstract class TagEvent extends Equatable {
  const TagEvent();

  @override
  List<Object> get props => [];
}

class UpdateTag extends TagEvent {
  final int tagId;
  final Tag tag;
  final List<Tag> tags;

  const UpdateTag(this.tagId, this.tag, this.tags);
}

class CreateTag extends TagEvent {
  final String title;
  final int color;
  final int userId;
  final List<Tag> tags;

  const CreateTag({
    required this.title,
    required this.userId,
    required this.color,
    required this.tags,
  });
}

class DeleteTag extends TagEvent {
  final int tagId;
  final List<Tag> tags;

  const DeleteTag(this.tagId, this.tags);
}

class GetTag extends TagEvent {
  final int tagId;

  const GetTag(this.tagId);
}

class GetTagsListOfUser extends TagEvent {
  final int userId;

  const GetTagsListOfUser(this.userId);
}

class GetTagsListOfTask extends TagEvent {
  final int taskId;

  const GetTagsListOfTask(this.taskId);
}
