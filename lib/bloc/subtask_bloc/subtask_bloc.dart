import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'subtask_event.dart';
part 'subtask_state.dart';

class SubtaskBloc extends Bloc<SubtaskEvent, SubtaskState> {
  SubtaskBloc() : super(SubtaskInitial()) {
    on<SubtaskEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
