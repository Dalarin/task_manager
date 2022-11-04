import 'dart:convert';

import 'package:http/http.dart';
import 'package:task_manager/models/list.dart' as model;
import 'package:task_manager/providers/constants.dart';

class ListProvider {
  Future<List<model.ListModel>?> fetchListByUserId(int userId) async {
    Response response = await get(Uri.parse('$apiURI/list?userId=$userId'));
    if (response.statusCode == 200) {
      var list = json.decode(response.body) as List;
      return list.map((list) => model.ListModel.fromJson(list)).toList();
    }
    return null;
  }

  Future<bool> deleteList(int listId) async {
    Response response = await delete(Uri.parse('$apiURI/list?id=$listId'));
    return response.statusCode == 200 ? true : false;
  }

  Future<model.ListModel?> createList(model.ListModel list) async {
    Response response = await post(
      Uri.parse('$apiURI/list'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(list.toJson()),
    );
    return response.statusCode == 201
        ? model.ListModel.fromJson(jsonDecode(response.body))
        : null;
  }

  Future<model.ListModel?> updateList(model.ListModel list) async {
    Response response = await put(
      Uri.parse('$apiURI/list?id=${list.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(list.toJson()),
    );
    return response.statusCode == 200
        ? model.ListModel.fromJson(jsonDecode(response.body))
        : null;
  }
}
