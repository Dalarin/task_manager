import 'dart:convert';

import 'package:http/http.dart';

import '../../models/listInvite.dart';
import '../../models/taskInvite.dart';
import '../../providers/constants.dart';

class InviteProvider {
  Future<List<TaskInvite>?> fetchTaskInvitationsByUserId(int userId) async {
    Response response =
        await get(Uri.parse('$apiURI/invite/task/user?userId=$userId'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      return list.map((invite) => TaskInvite.fromJson(invite)).toList();
    }
    return null;
  }

  Future<List<ListInvite>?> fetchListInvitationsByUserId(int userId) async {
    Response response =
        await get(Uri.parse('$apiURI/invite/list/user?userId=$userId'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      return list.map((invite) => ListInvite.fromJson(invite)).toList();
    }
    return null;
  }

  Future<List<TaskInvite>?> fetchInvitationsByTaskId(int taskId) async {
    Response response =
        await get(Uri.parse('$apiURI/invite/task?taskId=$taskId'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      return list.map((invite) => TaskInvite.fromJson(invite)).toList();
    }
    return null;
  }

  Future<List<ListInvite>?> fetchInvitationsByListId(int listId) async {
    Response response =
        await get(Uri.parse('$apiURI/invite/list?listId=$listId'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      return list.map((invite) => ListInvite.fromJson(invite)).toList();
    }
    return null;
  }

  Future<TaskInvite?> createTaskInvite(String email, TaskInvite invite) async {
    Response response = await post(
      Uri.parse('$apiURI/invite/task?email=$email'),
      body: jsonEncode(invite.toJsonCreation()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201
        ? TaskInvite.fromJson(jsonDecode(response.body))
        : null;
  }

  Future<ListInvite?> createListInvite(String email, ListInvite invite) async {
    Response response = await post(
      Uri.parse('$apiURI/invite/list?email=$email'),
      body: jsonEncode(invite.toJsonCreation()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201
        ? ListInvite.fromJson(jsonDecode(response.body))
        : null;
  }

  Future<TaskInvite?> updateTaskInvite(TaskInvite invite) async {
    Response response = await put(
      Uri.parse('$apiURI/invite/task?id=${invite.id}'),
      body: jsonEncode(invite.toJsonCreation()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200
        ? TaskInvite.fromJson(jsonDecode(response.body))
        : null;
  }

  Future<ListInvite?> updateListInvite(ListInvite invite) async {
    Response response = await put(
      Uri.parse('$apiURI/invite/list?id=${invite.id}'),
      body: jsonEncode(invite.toJsonCreation()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200
        ? ListInvite.fromJson(jsonDecode(response.body))
        : null;
  }

  Future<bool> acceptTaskInvite(TaskInvite taskInvite) async {
    Response response = await post(
      Uri.parse('$apiURI/invite/task/accept'),
      body: jsonEncode(taskInvite.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }


  Future<bool> acceptListInvite(ListInvite listInvite) async {
    Response response = await post(
      Uri.parse('$apiURI/invite/list/accept'),
      body: jsonEncode(listInvite.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }




  Future<bool> deleteTaskInvite(int inviteId) async {
    Response response =
        await delete(Uri.parse('$apiURI/invite/task?id=$inviteId'));
    return response.statusCode == 200;
  }

  Future<bool> deleteListInvite(int inviteId) async {
    Response response =
        await delete(Uri.parse('$apiURI/invite/list?id=$inviteId'));
    return response.statusCode == 200;
  }
}
