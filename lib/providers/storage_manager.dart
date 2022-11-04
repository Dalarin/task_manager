import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class StorageManager {
  static void saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", json.encode(user.toJson()));
  }

  static Future<User?> readUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("user");
    return user != null ? User.fromJson(json.decode(user)) : null;
  }
}
