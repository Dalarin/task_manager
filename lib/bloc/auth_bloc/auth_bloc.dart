import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user.dart';
import '../../repository/user_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc(this._userRepository) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) => _authEvent(event, emit));
  }


  void _catchHandler(event, emit, Exception exception) {
    if (exception is SocketException) {
      emit(const AuthError(
        'Ошибка. Проверьте интернет соединение и попробуйте снова',
      ));
    } else {
      emit(const AuthError('Ошибка авторизации'));

    }
  }

  _authEvent(LoginEvent event, Emitter emit) async {
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError('Заполните данные и попробуйте снова'));
        emit(AuthInitial());
      } else {
        emit(AuthLoading());
        final user = await _userRepository.auth(event.email, event.password);
        emit(user != null
            ? AuthLoaded(user)
            : const AuthError('Ошибка. Пользователь не найден'));
      }
    } on Exception catch (_, exception) {
      _catchHandler(event, emit, _);
    }
  }
}
