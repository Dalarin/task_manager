
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/invite.dart';
import '../../models/task.dart';
import '../../repository/invite_repository.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  InviteRepository _repository;
  InviteBloc(this._repository) : super(InviteInitial()) {
    on<InviteEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
