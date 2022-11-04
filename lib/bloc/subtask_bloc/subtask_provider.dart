import 'dart:convert';

import 'package:http/http.dart';
import 'package:task_manager/models/subtask.dart';
import 'package:task_manager/providers/constants.dart';

class SubtaskProvider {
  Future<List<SubTask>?> fetchSubtasksByTaskId(int taskId) async {
    Response response = await get(Uri.parse('$apiURI/subtasks?taskId=$taskId'));
    if (response.statusCode == 200) {
      var list = json.decode(response.body) as List;
      return list.map((subtask) => SubTask.fromJson(subtask)).toList();
    }
    return null;
  }

  Future<SubTask?> updateSubtask(SubTask subTask, int id) async {
    Response response = await put(
      Uri.parse('$apiURI/subtasks?id=$id'),
      body: jsonEncode(subTask.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200
        ? SubTask.fromJson(json.decode(response.body))
        : null;
  }

  Future<bool> deleteSubtask(int id) async {
    Response response = await delete(Uri.parse('$apiURI/subtasks?id=$id'));
    return response.statusCode == 200;
  }

  Future<SubTask?> createSubtask(SubTask subTask) async {
    Response response = await post(
      Uri.parse('$apiURI/subtasks'),
      body: jsonEncode(subTask.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201
        ? SubTask.fromJson(json.decode(response.body))
        : null;
  }
}
