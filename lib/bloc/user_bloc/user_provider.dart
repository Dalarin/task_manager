import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:task_manager/providers/constants.dart';

import '../../models/user.dart';

class ServerNotReachable implements Exception {
  final String message;

  const ServerNotReachable(this.message);

  @override
  String toString() {
    return message;
  }
}

class UserProvider {
  User? _codeHandler(int statusCode, int successCode, String body) {
    if (statusCode == successCode) {
      return User.fromJson(json.decode(body));
    } else if (statusCode == 404) {
      throw const SocketException('Отсутствует интернет соединение');
    } else if (statusCode == 502) {
      throw const ServerNotReachable('Отсутствует связь с сервером.');
    }
    return null;
  }

  Future<List<User>?> fetchUsersByTaskId(int taskId) async {
    Response response =
        await get(Uri.parse('$apiURI/users/task?taskId=$taskId'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      return list.map((e) => User.fromJson(e)).toList();
    }
    return null;
  }

  Future<List<User>?> fetchUsersByListId(listId) async {
    Response response =
        await get(Uri.parse('$apiURI/users/list?listId=$listId'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      return list.map((e) => User.fromJson(e)).toList();
    }
    return null;
  }

  // TODO: ВЫНЕСТИ КОДЫ В ОТДЕЛЬНУЮ ФУНКЦИЮ
  Future<User?> readUser(int userId) async {
    Response response = await get(Uri.parse('$apiURI/users/?id=$userId'));
    return _codeHandler(response.statusCode, 202, response.body);
  }

  Future<User?> auth(String email, String password) async {
    Response response = await get(Uri.parse(
      '$apiURI/auth/?login=$email&password=$password',
    ));
    return _codeHandler(response.statusCode, 202, response.body);
  }

  Future<User?> confirmLogin(User user) async {
    Response response = await get(
      Uri.parse(
          '$apiURI/auth/validate?email=${user.email}&password=${user.password}'),
    );
    return _codeHandler(response.statusCode, 200, response.body);
  }

  Future<User?> createUser(User user) async {
    Response? response = await post(
      Uri.parse('$apiURI/users'),
      body: jsonEncode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return _codeHandler(response.statusCode, 201, response.body);
  }

  Future<User?> updateUser(User user) async {
    Response response = await put(
      Uri.parse('$apiURI/users/?id=${user.id}'),
      body: jsonEncode(user.toJson()),
    );
    return _codeHandler(response.statusCode, 200, response.body);
  }

  Future<bool> deleteUser(int userId) async {
    Response response = await delete(Uri.parse('$apiURI/users/?id=$userId'));
    return response.statusCode == 200;
  }

  Future<bool> deleteUserFromTask(int taskId, int userId) async {
    Response response = await delete(
        Uri.parse('$apiURI/users/task?taskId=$taskId&userId=$userId'));
    return response.statusCode == 200;
  }

  Future<bool> deleteUserFromList(int listId, int userId) async {
    Response response = await delete(
        Uri.parse('$apiURI/users/list?listId=$listId&userId=$userId'));
    return response.statusCode == 200;
  }
}
