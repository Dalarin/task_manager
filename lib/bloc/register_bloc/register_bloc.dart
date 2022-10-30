import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user.dart';
import '../../repository/user_repository.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc(this._userRepository) : super(RegisterInitial()) {
    on<RegisterStarted>((event, emit) => _registerEvent(event, emit));
  }

  _registerEvent(event, emit) async {
    try {
      if (event.fio.isEmpty ||
          event.password.isEmpty ||
          event.email.isEmpty ||
          event.phone.isEmpty) {
        emit(const RegisterError(
          'Заполните данные и попробуйте снова',
        ));
        emit(RegisterInitial());
      } else {
        emit(RegisterLoading());
        final user = await _userRepository.createUser(User(
          password: event.password,
          phone: event.phone,
          email: event.email,
          fio: event.fio,
        ));
        emit(user != null
            ? RegisterLoaded(user)
            : const RegisterError('Ошибка регистрации'));
      }
    } on SocketException {
      emit(const RegisterError(
        'Ошибка. Проверьте интернет соединение и попробуйте снова',
      ));
      emit(RegisterInitial());
    } on Exception {
      emit(const RegisterError('Ошибка регистрации'));
    }
  }
}
