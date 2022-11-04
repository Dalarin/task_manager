part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AppStarting extends AuthState {}

class AuthLoaded extends AuthState {
  final User user;

  const AuthLoaded(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
