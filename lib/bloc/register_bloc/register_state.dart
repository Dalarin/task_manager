part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterLoaded extends RegisterState {
  final User user;

  const RegisterLoaded(this.user);
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);
}
