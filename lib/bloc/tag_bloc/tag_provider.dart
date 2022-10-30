import 'dart:convert';
import 'dart:developer';

import 'package:task_manager/bloc/task_bloc/task_provider.dart';

import '../../models/tag.dart';
import 'package:http/http.dart';

import '../../providers/constants.dart';

class TagProvider {
  Future<List<Tag>?> fetchTagByTaskId(int taskId) async {
    Response response = await get(Uri.parse('$apiURI/tags/?taskId=$taskId'));
    if (response.statusCode == 200) {
      var list = json.decode(response.body) as List;
      List<Tag> tags = list.map((tag) => Tag.fromJson(tag)).toList();
      return tags;
    }
    return null;
  }

  Future<List<Tag>?> fetchTagByUserId(int userId) async {
    Response response = await get(Uri.parse('$apiURI/tags/?userId=$userId'));
    if (response.statusCode == 200) {
      var list = json.decode(response.body) as List;
      List<Tag> tags = list.map((tag) => Tag.fromJson(tag)).toList();
      return tags;
    }
    return null;
  }

  Future<Tag?> createTag(Tag tag) async {
    Response response = await post(
      Uri.parse('$apiURI/tags/'),
      body: tag.toJson(),
    );
    if (response.statusCode == 201) {
      Tag? tag = Tag.fromJson(jsonDecode(response.body));
      return tag;
    }
    return null;
  }

  Future<Tag?> updateTag(int tagId, Tag tag) async {
    Response response = await put(
      Uri.parse('$apiURI/tags/?id=$tagId'),
      body: tag.toString(),
    );
    if (response.statusCode == 200) {
      Tag? tag = Tag.fromJson(jsonDecode(response.body));
      return tag;
    }
    return null;
  }

  Future<bool> deleteTag(int tagId) async {
    Response response = await delete(Uri.parse('$apiURI/tags/?id=$tagId'));
    return response.statusCode == 200 ? true : false;
  }
}
