part of 'invite_bloc.dart';

abstract class InviteEvent extends Equatable {
  const InviteEvent();

  @override
  List<Object> get props => [];

}

class UpdateInvite extends InviteEvent {
  final int inviteId;
  final Invite invite;
  final List<Invite> invites;

  const UpdateInvite(this.inviteId, this.invite, this.invites);

}

class CreateInvite extends InviteEvent {
  final String email;
  final Task task;

  const CreateInvite(this.email, this.task);

}

class DeleteInvite extends InviteEvent {
  final int id;

  const DeleteInvite(this.id);
}

class GetInvites extends InviteEvent {
  final int taskId;

  const GetInvites(this.taskId);
}
