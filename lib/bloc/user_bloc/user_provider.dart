import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:task_manager/providers/constants.dart';

import '../../models/user.dart';

class UserProvider {
  Future<User?> readUser(int userId) async {
    Response response = await get(Uri.parse('$apiURI/users/?id=$userId'));
    return response.statusCode == 200
        ? User.fromJson(json.decode(response.body))
        : null;
  }

  Future<User?> auth(String email, String password) async {
    Response response = await get(Uri.parse(
      '$apiURI/auth/?login=$email&password=$password',
    ));
    if (response.statusCode == 404) throw const SocketException('EROR');
    return response.statusCode == 202
        ? User.fromJson(json.decode(response.body))
        : null;
  }

  Future<User?> createUser(User user) async {
    Response? response = await post(Uri.parse('$apiURI/users'),
        body: jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'});
    return response.statusCode == 201
        ? User.fromJson(json.decode(response.body))
        : null;
  }

  Future<User?> updateUser(User user) async {
    Response response = await put(
      Uri.parse('$apiURI/users/?id=${user.id}'),
      body: jsonEncode(user.toJson()),
    );
    return response.statusCode == 200
        ? User.fromJson(json.decode(response.body))
        : null;
  }

  Future<bool> deleteUser(int userId) async {
    Response response = await delete(Uri.parse('$apiURI/users/?id=$userId'));
    return response.statusCode == 200 ? true : false;
  }
}
