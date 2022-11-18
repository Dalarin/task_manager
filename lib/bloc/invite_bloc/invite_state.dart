part of 'invite_bloc.dart';

abstract class InviteState extends Equatable {
  const InviteState();

  @override
  List<Object> get props => [];
}

class InviteInitial extends InviteState {}

class InviteLoading extends InviteState {}

class InviteTaskLoaded extends InviteState {
  final List<TaskInvite> invites;

  const InviteTaskLoaded(this.invites);
}

class InviteListLoaded extends InviteState {
  final List<ListInvite> invites;
  const InviteListLoaded({required this.invites});
}

class InviteError extends InviteState {
  final String message;

  const InviteError(this.message);
}
