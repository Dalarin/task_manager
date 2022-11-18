part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserListLoaded extends UserState {
  final List<User> users;

  const UserListLoaded({required this.users});
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});
}
