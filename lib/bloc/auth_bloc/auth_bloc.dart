
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/providers/storage_manager.dart';
import 'package:task_manager/providers/constants.dart' as constant;

import '../../models/user.dart';
import '../../repository/user_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc(this._userRepository) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) => _authEvent(event, emit));
    on<AppStarted>((event, emit) => _appStarted(event, emit));
  }

  void _catchHandler(event, emit, Exception exception) {
    emit(AuthError(exception.toString()));
  }

  _appStarted(AppStarted event, Emitter emit) async {
    try {
      emit(AppStarting());
      User? user = await StorageManager.readUser();
      if (user != null) {
        User? confirmedUser = await _userRepository.confirmLogin(user);
        if (confirmedUser != null) {
          constant.user = confirmedUser;
          emit(AuthLoaded(confirmedUser));
        } else {
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    } on Exception catch (_) {
      _catchHandler(event, emit, _);
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
        if (user != null) {
          StorageManager.saveUser(user);
          emit(AuthLoaded(user));
        } else {
          emit(const AuthError('Ошибка. Пользователь не найден'));
        }
      }
    } on Exception catch (_) {
      _catchHandler(event, emit, _);
    }
  }
}
