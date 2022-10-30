part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];

}

class RegisterStarted extends RegisterEvent {
  final String email;
  final String phone;
  final String password;
  final String fio;

  const RegisterStarted(this.email, this.phone, this.password, this.fio);
}
