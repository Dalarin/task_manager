import 'dart:convert';

import 'package:http/http.dart';
import 'package:task_manager/models/list.dart' as model;
import 'package:task_manager/providers/constants.dart';

class ListProvider {
  Future<List<model.List>?> fetchListByUserId(int userId) async {
      Response response = await get(Uri.parse('$apiURI/list/?userId=$userId'));
      if (response.statusCode == 200) {
        var list = json.decode(response.body) as List;
        return list.map((list) => model.List.fromJson(list)).toList();
      }
    return null;
  }

  Future<bool> deleteList(int listId) async {
    Response response = await delete(Uri.parse('$apiURI/list/?id=$listId'));
    return response.statusCode == 200 ? true : false;
  }

  Future<model.List?> createList(model.List list) async {
    Response response = await post(
      Uri.parse('$apiURI/list/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(list.toJson()),
    );
    return response.statusCode == 201
        ? model.List.fromJson(jsonDecode(response.body))
        : null;
  }

  Future<bool> updateList(model.List list) async {
    Response response = await put(
      Uri.parse('$apiURI/list/?id=${list.id}'),
      body: jsonEncode(list.toJson()),
    );
    return response.statusCode == 200 ? true : false;
  }
}
