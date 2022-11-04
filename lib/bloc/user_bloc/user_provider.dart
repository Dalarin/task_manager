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


  // TODO: ВЫНЕСТИ КОДЫ В ОТДЕЛЬНУЮ ФУНКЦИЮ
  Future<User?> readUser(int userId) async {
    Response response = await get(Uri.parse('$apiURI/users/?id=$userId'));
    if (response.statusCode == 202) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw const SocketException('Отсутствует интернет соединение');
    } else if (response.statusCode == 502) {
      throw const ServerNotReachable('Отсутствует связь с сервером.');
    }
    return null;
  }

  Future<User?> auth(String email, String password) async {
    Response response = await get(Uri.parse(
      '$apiURI/auth/?login=$email&password=$password',
    ));
    if (response.statusCode == 202) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw const SocketException('Отсутствует интернет соединение');
    } else if (response.statusCode == 502) {
      throw const ServerNotReachable('Отсутствует связь с сервером.');
    }
    return null;
  }

  Future<User?> confirmLogin(User user) async {
    Response response = await get(Uri.parse(
      '$apiURI/auth/validate?email=${user.email}&password=${user.password}',
    ));
    if (response.statusCode == 202) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw const SocketException('Отсутствует интернет соединение');
    } else if (response.statusCode == 502) {
      throw const ServerNotReachable('Отсутствует связь с сервером.');
    }
    return null;
  }

  Future<User?> createUser(User user) async {
    Response? response = await post(Uri.parse('$apiURI/users'),
        body: jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw const SocketException('Отсутствует интернет соединение');
    } else if (response.statusCode == 502) {
      throw const ServerNotReachable('Отсутствует связь с сервером.');
    }
    return null;
  }

  Future<User?> updateUser(User user) async {
    Response response = await put(
      Uri.parse('$apiURI/users/?id=${user.id}'),
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw const SocketException('Отсутствует интернет соединение');
    } else if (response.statusCode == 502) {
      throw const ServerNotReachable('Отсутствует связь с сервером.');
    }
    return null;
  }

  Future<bool> deleteUser(int userId) async {
    Response response = await delete(Uri.parse('$apiURI/users/?id=$userId'));
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw const SocketException('Отсутствует интернет соединение');
    } else if (response.statusCode == 502) {
      throw const ServerNotReachable('Отсутствует связь с сервером.');
    }
    return response.statusCode == 200 ? true : false;
  }
}
