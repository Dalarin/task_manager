import 'package:task_manager/bloc/user_bloc/user_provider.dart';

import '../models/user.dart';

class UserRepository {
  final _provider = UserProvider();

  Future<List<User>?> fetchUsersByTaskId(int taskId) =>
      _provider.fetchUsersByTaskId(taskId);

  Future<List<User>?> fetchUsersByListId(listId) =>
      _provider.fetchUsersByListId(listId);

  Future<User?> fetchUserById(int id) => _provider.readUser(id);

  Future<User?> auth(String email, String password) =>
      _provider.auth(email, password);

  Future<User?> confirmLogin(User user) => _provider.confirmLogin(user);

  Future<User?> createUser(User user) => _provider.createUser(user);

  Future<User?> updateUser(User user) => _provider.updateUser(user);

  Future<bool> deleteUser(int userId) => _provider.deleteUser(userId);

  Future<bool> deleteUserFromTask(int taskId, int userId) =>
      _provider.deleteUserFromTask(taskId, userId);

  deleteUserFromList(int listId, int userId) =>
      _provider.deleteUserFromList(listId, userId);
}
