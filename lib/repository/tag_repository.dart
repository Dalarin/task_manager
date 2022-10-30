import 'package:task_manager/bloc/tag_bloc/tag_provider.dart';

import '../models/tag.dart';

class TagRepository {
  final _provider = TagProvider();

  Future<List<Tag>?> fetchTagsByUserId(int userId) =>
      _provider.fetchTagByUserId(userId);

  Future<List<Tag>?> fetchTagsByTaskId(int taskId) =>
      _provider.fetchTagByTaskId(taskId);

  Future<Tag?> updateTag(int tagId, Tag tag) => _provider.updateTag(tagId, tag);

  Future<Tag?> createTag(Tag tag) => _provider.createTag(tag);

  Future<bool> deleteTag(int tagId) => _provider.deleteTag(tagId);
}
