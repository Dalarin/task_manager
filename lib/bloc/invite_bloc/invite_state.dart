part of 'invite_bloc.dart';

abstract class InviteState extends Equatable {
  const InviteState();

  @override
  List<Object> get props => [];
}

class InviteInitial extends InviteState {}

class InviteLoading extends InviteState {}

class InviteLoaded extends InviteState {
  final List<Invite> invites;

  const InviteLoaded(this.invites);
}

class InviteError extends InviteState {
  final String message;

  const InviteError(this.message);
}
